inputs_path = "/workspace/inputs"
outputs_path = "/workspace/outputs"
directories = ["videos", "audios", "subtitles"]

# NMT function
def nmt_translation(output_asr, client):
    output_nmt = []

    for original_entry in output_asr:
        text_to_translate = original_entry[0]

        # Construct prompt to instruct the model to translate from French to English
        prompt = (
                "Translate the following text from French to English. "
                "Return ONLY the translation. "
                "Do NOT add notes, explanations, or alternate versions. "
                "Output must be a single line, plain text, nothing else. "
                "Here is the text:\n\n"
            f"{text_to_translate}"
        )

        # Create prompt history
        history = [{"role": "user", "content": prompt}]

        try:
            # Make a chat completion request
            response = client.chat.completions.create(
                model="Llama-3.1-8B-Instruct",
                messages=history,
                temperature=0, 
                max_tokens=1024
            )

            # Extract the translated text
            translated_text = response.choices[0].message.content.strip()
        except Exception as e:
            raise Exception(f"Translation failed for text:\n'{text_to_translate}'\nError: {str(e)}")

        # Construct a new entry with the translated text
        new_entry = [translated_text] + original_entry[1:]
        output_nmt.append(new_entry)

    return output_nmt