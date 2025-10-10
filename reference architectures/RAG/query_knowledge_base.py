import os
import requests
import psycopg2
import gradio as gr

# Fixed variables
ovhcloud_embedding_endpoint_url = 'https://multilingual-e5-base.endpoints.kepler.ai.cloud.ovh.net/api/text2vec'
ovhcloud_llm_endpoint_url = 'https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/chat/completions'
postgre_host = 'postgresql-5840cdf3-oa2f926d2.database.cloud.ovh.net'
postgre_db = 'defaultdb'
postgre_port = '20184'
sslmode = "require"

# sensitive variables that will be provided via environment variables
ovhcloud_ai_endpoint_api_key = os.getenv('OVHCLOUD_AI_ENDPOINT_API_KEY')
postgre_password = os.getenv("POSTGRE_PASSWORD")
postgre_user = os.getenv("POSTGRE_USER")

def rag_response(message, history):
    # Get environment variables


    # Get the embeddings of the query text
    response = requests.post(ovhcloud_embedding_endpoint_url, json={"text": message}, headers={'Authorization': f'Bearer {ovhcloud_ai_endpoint_api_key}'})
    query_embedding = response.json()

    # Connect to the postgresql db and run a similarity query on this embedding to get the top 5 most similar texts
    with psycopg2.connect(dbname=postgre_db, user=postgre_user, password=postgre_password, host=postgre_host, port=postgre_port, sslmode=sslmode) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT document_name, page_number, embedding <-> %s::vector as distance, text FROM embeddings ORDER BY distance LIMIT 5", (query_embedding,))
            results = cur.fetchall()

    # Build the context string for the llm model by concatenating the top 5 most relevant texts
    system_prompt = "You are nice chatbot and you have to answer the user question based on the context provided bellow and not prior knowledge. If the answer was found in a context document, list the document name and page number. \n <context>"
    system_prompt += ''.join(f"\n Document: {result[0]}, Page: {result[1]}, Text: {result[3]} \n" for result in results)
    system_prompt += "</context>"

    # Build the history
    messages = [{"role": "system", "content": system_prompt}] + [{"role": role, "content": content} for role, content in history] + [{"role": "user", "content": message}]

    # Call the llm model api with the user question and system prompt
    response = requests.post(ovhcloud_llm_endpoint_url, json={"max_tokens": 512, "messages": messages, "model": "Mixtral-8x22B-Instruct-v0.1", "temperature": 0}, headers={"Content-Type": "application/json", "Authorization": f"Bearer {ovhcloud_ai_endpoint_api_key}"})

    # Handle response
    return response.json()["choices"][0]["message"]["content"] if response.status_code == 200 else f"{response.status_code} {response.text}"

# Launch the chat interface from gradio
gr.ChatInterface(rag_response).launch(server_name="0.0.0.0", server_port=8080)