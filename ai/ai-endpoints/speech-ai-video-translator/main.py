# /// Import dependencies \\\
import gradio as gr
from utils import process_video

# /// Config \\\
# gradio interface theme
api_theme = gr.themes.Default(primary_hue="blue")

# translation modes
translation_mode_list = ["Subtitles", "Voice dubbing"]
voices_list = ["Female-1", "Male-1", "Female-Calm", "Female-Neutral", "Female-Happy", "Female-Angry", "Female-Fearful", "Female-Sad", "Male-Calm", "Male-Neutral", "Male-Happy", "Male-Angry"]


# /// Gradio functions \\\
# change source language
def reset_inputs():
    # reset all components
    return gr.Radio(
        label="Translation mode",
        choices=translation_mode_list,
    ), gr.Dropdown(
        visible=False,
    ), gr.Video(
        label="Translated video in French 🇫🇷",
        visible=True,
        show_download_button=True,
        interactive=False,
    )

# change source language
def translation_mode_change(translation_mode):
    
    if translation_mode == "Voice dubbing":
        voice_type = gr.Dropdown(
            label="Voice gender",
            choices=voices_list,
            value=voices_list[0],
            visible=True,
            interactive=True,
        )
    else:
        voice_type = gr.Dropdown(
            label="Voice gender",
            visible=False,
        )
        
    return voice_type


# /// Gradio Block \\\
with gr.Blocks(theme=api_theme) as demo:

    # Row n°1 - Intro
    with gr.Row():
        # add title and description
        gr.HTML(
            """
            <div align="center">
                <h1> 🎥 VIDEO TRANSLATOR 🌍 </h1>
            </div>
            <br>
            <div align="center">
                <p>Upload your video, select the translation type, choose the voice and let the magic happen!</p>
            </div>
            <br>
            """
        )

    # Row n°2 - Processing
    with gr.Row():
        # Row n°2 / Column n°1 - User inputs
        with gr.Column():

            # Video input
            with gr.Row():
                video_input = gr.Video(
                    label="Video input in English 🇬🇧 (.mp4)",
                    sources="upload",
                    format="mp4",
                    max_length=600,   
                )

            # Translation mode
            with gr.Row():
                translation_mode = gr.Radio(
                    label="Translation mode",
                    choices=translation_mode_list,
                    value=translation_mode_list[0],
                )

            # Voice gender
            with gr.Row():
                voice_type = gr.Dropdown(
                    label="Voice gender-emotion",
                    visible=False,
                )

            # Submit input
            with gr.Row():
                submit = gr.Button("Submit", variant="primary")
                clear = gr.Button("Clear")

        # Row n°2 / Column n°2 - Model outputs
        with gr.Column():
            video_title = gr.Markdown(
                label="Video title",
                visible=False,
            )
            video_output = gr.Video(
                label="Translated video in French 🇫🇷",
                visible=True,
                show_download_button=True,
                interactive=False,
            )

    # change and click actions
    translation_mode.change(
        fn=translation_mode_change,
        inputs=translation_mode,
        outputs=[voice_type]
    )
    
    submit.click(fn=process_video, inputs=[video_input, translation_mode, voice_type], outputs=video_output)
    clear.click(fn=reset_inputs, inputs=[], outputs=[translation_mode, voice_type, video_output]) 

demo.launch(server_name="0.0.0.0", server_port=8000)
