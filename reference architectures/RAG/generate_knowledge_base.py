import boto3
from PyPDF2 import PdfReader
import requests
import psycopg2
from psycopg2.extras import execute_values
from psycopg2 import OperationalError
import os
from markdownify import markdownify as md
import time # for the wait function

# Variables that wont change much and are not sensitive
S3_endpoint = "https://s3.gra.io.cloud.ovh.net/"
S3_container_name = "rag-knowledge-files"
ovhcloud_embedding_endpoint_url = 'https://multilingual-e5-base.endpoints.kepler.ai.cloud.ovh.net/api/text2vec'
ovhcloud_llm_endpoint_url = 'https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/chat/completions'
postgre_host = 'postgresql-5840cdf3-oa2f926d2.database.cloud.ovh.net'
postgre_db = 'defaultdb'
postgre_port = '20184'
sslmode = "require"

# variables that could change and are sensitive which will be provided via environment variables
S3_secret_key = os.getenv('S3_SECRET_KEY')
S3_access_key = os.getenv('S3_ACCESS_KEY')
ovhcloud_ai_endpoint_api_key = os.getenv('OVHCLOUD_AI_ENDPOINT_API_KEY')
postgre_password = os.getenv("POSTGRE_PASSWORD")
postgre_user = os.getenv("POSTGRE_USER")

# Connect to PostgreSQL. If connection fails, it will raise an exception, print the error and the program will stop
# we will use the default database
try:
    conn = psycopg2.connect(
        dbname="defaultdb",
        user=postgre_user,
        password=postgre_password,
        host=postgre_host,
        port=postgre_port,
        sslmode=sslmode
    )
    print("Connection to PostgreSQL DB successful")
except OperationalError as e:
    print(f"The error '{e}' occurred")
cur = conn.cursor()

# check if the pgvector extension exists, if not activate it. Without this Postgre will now accept vectors and you won’t be able to do vector similarity search
cur.execute("CREATE EXTENSION IF NOT EXISTS vector")
conn.commit()

# check if the embeddings table exists, if not create it
# embeddings table stores the embeddings but also the document name, the page number and the text itself
cur.execute("CREATE TABLE IF NOT EXISTS embeddings (id SERIAL PRIMARY KEY, document_name TEXT, page_number INT, text TEXT, embedding VECTOR)")
conn.commit()
# we make sure the table is empty. This means every time we launch this job it will regenerate the full tabled based on all the documents in the object storage.
cur.execute("TRUNCATE TABLE embeddings;")
conn.commit()

# Connect to S3 and print the list of files
s3 = boto3.client('s3',
                  endpoint_url=S3_endpoint,
                  aws_access_key_id=S3_access_key,
                  aws_secret_access_key=S3_secret_key)
bucket = s3.list_objects(Bucket=S3_container_name)

# only select the pdf files and then for each count the number of pages and display the nb
for obj in bucket['Contents']:
    if obj['Key'].endswith('.pdf'):
        # Download the PDF file
        s3.download_file(S3_container_name, obj['Key'], 'temp.pdf')

        # Read the PDF file
        with open('temp.pdf', 'rb') as file:
            reader = PdfReader(file)
            print(f"Number of pages in {obj['Key']}:", len(reader.pages))
            # for each page, extract the text and send it to the embedding endpoint
            for page_num in range(len(reader.pages)):
                page = reader.pages[page_num]
                text = page.extract_text()
                # Generate embeddings
                response = requests.post(ovhcloud_embedding_endpoint_url, json={"text": text}, headers={'Authorization': f'Bearer {ovhcloud_ai_endpoint_api_key}'})
                embeddings = response.json()
                data = [(obj['Key'], page_num, text, embeddings)]
                # Insert embeddings into PostgreSQL
                try:
                    execute_values(
                        cur,
                        "INSERT INTO embeddings (document_name, page_number, text, embedding) VALUES %s",
                        data
                    )
                    conn.commit()
                except Exception as e:
                    print(f"Error inserting data for {obj['Key']} page {page_num}: {e}")
                    print("INSERT INTO embeddings (document_name, page_number, text, embedding) VALUES %s" % data)
                    conn.rollback()
                # 3 second wait in order now to reach API limit calls
                time.sleep(3)

            # close the file and then delete the temp file
            file.close()
        # delete the temp file temp.pdf
        os.remove('temp.pdf')
# check how many rows are in the embeddings table and print it
cur.execute("SELECT COUNT(*) FROM embeddings")
print("PDF files added - DB now has", cur.fetchone()[0], " embeddings")

# Function to get all 'guide.en-ie.md' files in a directory and its subdirectories
def get_guide_md_files(directory):
    guide_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file == 'guide.en-ie.md':
                guide_files.append(os.path.join(root, file))
    return guide_files


# Function to extract sections from markdown text
def extract_md_sections(md_text):
    sections = []
    current_section = []
    lines = md_text.split('\n')

    for line in lines:
        if line.startswith('#'):
            if current_section:
                sections.append('\n'.join(current_section))
                current_section = []
        current_section.append(line)

    if current_section:
        sections.append('\n'.join(current_section))

    return sections


# Local directory containing markdown files
local_directory = 'docs/pages/'

# Process 'guide.en-ie.md' files in the local directory
guide_files = get_guide_md_files(local_directory)

for guide_file in guide_files:
    with open(guide_file, 'r', encoding='utf-8') as file:
        md_text = file.read()

    sections = extract_md_sections(md_text)

    for section_num, section_text in enumerate(sections):
        # Add folder structure at the beginning of the text
        folder_structure = os.path.relpath(guide_file, local_directory)
        text_with_structure = f"{folder_structure}\n\n{section_text}"

        # Generate embeddings
        response = requests.post(ovhcloud_embedding_endpoint_url, json={"text": text_with_structure},
                                 headers={'Authorization': f'Bearer {ovhcloud_ai_endpoint_api_key}'})
        embeddings = response.json()

        data = [(folder_structure, section_num, text_with_structure, embeddings)]
        # Insert embeddings into PostgreSQL
        try:
            execute_values(
                cur,
                "INSERT INTO embeddings (document_name, page_number, text, embedding) VALUES %s",
                data
            )
            conn.commit()
        except Exception as e:
            print(f"Error inserting data for {guide_file} section {section_num}: {e}")
            conn.rollback()

        # 3-second wait to avoid reaching API rate limits
        time.sleep(3)

# check how many rows are in the embeddings table and print it
cur.execute("SELECT COUNT(*) FROM embeddings")
print("Markdown Docs added - DB now has", cur.fetchone()[0], " embeddings")

# Close the connection
cur.close()
conn.close()
