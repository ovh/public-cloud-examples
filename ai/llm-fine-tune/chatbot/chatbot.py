# Application to compare answers generation from OVHcloud AI Endpoints exposed model and fine tuned model.
# ⚠️ Do not used in production!! ⚠️

import gradio as gr
import os

from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

# 📜 Prompts templates 📜
prompt_template = ChatPromptTemplate.from_messages(
    [
        ("system", "{system_prompt}"),
        ("human", "{user_prompt}"),
    ]
)

def chat(prompt, system_prompt, temperature, top_p, model_name, model_url, api_key):
    """
    Function to generate a chat response using the provided prompt, system prompt, temperature, top_p, model name, model URL and API key.
    """

    # ⚙️ Initialize the OpenAI model ⚙️
    llm = ChatOpenAI(api_key=api_key, 
                 model=model_name, 
                 base_url=model_url,
                 temperature=temperature,
                 top_p=top_p
                 )

    # 📜 Apply the prompt to the model 📜
    chain = prompt_template | llm
    ai_msg = chain.invoke(
        {
            "system_prompt": system_prompt,
            "user_prompt": prompt
        }
    )

    # 🤖 Return answer in a compatible format for Gradio component.
    return [{"role": "user", "content": prompt}, {"role": "assistant", "content": ai_msg.content}]

# 🖥️ Main application 🖥️
with gr.Blocks() as demo:
    with gr.Row():
        with gr.Column():
            system_prompt = gr.Textbox(value="""You are a specialist on OVHcloud products.
If you can't find any sure and relevant information about the product asked, answer with "This product doesn't exist in OVHcloud""", 
                label="🧑‍🏫 System Prompt 🧑‍🏫")
            temperature = gr.Slider(minimum=0.0, maximum=2.0, step=0.01, label="Temperature", value=0.5)
            top_p = gr.Slider(minimum=0.0, maximum=1.0, step=0.01, label="Top P", value=0.0)
            model_name = gr.Textbox(label="🧠 Model Name 🧠", value='Meta-Llama-3_3-70B-Instruct')
            model_url = gr.Textbox(label="🔗 Model URL 🔗", value='https://oai.endpoints.kepler.ai.cloud.ovh.net/v1')
            api_key = gr.Textbox(label="🔑 OVH AI Endpoints Access Token 🔑", value=os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"), type="password")

        with gr.Column():
            chatbot = gr.Chatbot(type="messages", label="🤖 Response 🤖")
            prompt = gr.Textbox(label="📝 Prompt 📝", value='How many requests by minutes can I do with AI Endpoints?')
            submit = gr.Button("Submit")

    submit.click(chat, inputs=[prompt, system_prompt, temperature, top_p, model_name, model_url, api_key], outputs=chatbot)

demo.launch()