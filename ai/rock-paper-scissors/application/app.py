from ultralytics import YOLO
import streamlit as st
import os

#######################################################################################################################
## 🎯 The aim of this script is to create an Rock/Paper/Scissors application based on a trained model (from YOLO).   ##
## ℹ️ Note on the environments variables:                                                                            ##
##      - WORK_PATH (default value: '/workspace/data/') is the path where get the model and store de snapshots       ##
#######################################################################################################################

# 🛠 Get configuration from environment variables
WORK_PATH = os.getenv('WORK_PATH', '/workspace/data/')


# Save uploaded photo
def save_photo(photo):
    photoAbsolutePath = WORK_PATH + photo.name

    with open(photoAbsolutePath, 'wb') as f:
        f.write(photo.getbuffer())

    return photoAbsolutePath


def predict_from_buffer(img_file_buffer_player_x):
  detected_sign = None
  detected_elements = 0

  # Save the photo if takentensor([2., 0.])
  if img_file_buffer_player_x is not None:
      photoPath = save_photo(img_file_buffer_player_x)

      # 🔎 Prediction
      player_results = model.predict(photoPath, verbose=True, save=True, conf=0.5)

      # Verify that only one sign has been detected
      for r in player_results:
        detected_elements += len(r.boxes.cls)
  
      # 📈 Display results
      for r in player_results:
        if detected_elements == 0:
            st.warning("No sign has been detected. Please take a new photo.")
        elif detected_elements > 1:
            st.warning("More than one sign has been detected. Please take a new photo.")
        else:
          detected_sign = r.names[int(r.boxes.cls[0])]
          st.write(detected_sign)
  return detected_sign


# Find the winner of the game between Player1 & Player 2
def find_winner(first_input, second_input):
    # One or both images have not been detected
    if first_input is None or second_input is None:
        return None

    if first_input == second_input:
        result = "tie"
    elif (first_input, second_input) == ("Rock", "Scissors") or \
         (first_input, second_input) == ("Scissors", "Paper") or \
         (first_input, second_input) == ("Paper", "Rock"):
        result = "first_player"
        message = "The first player wins."
    else:
        result = "second_player"
        message = "The second player wins."

    if result == "tie":
      st.info("Wow, it's a tie!", icon="🟰")
    else:
      st.success(message, icon="✅")

# main
if __name__ == '__main__':
    # App title
    st.write("## Welcome to the 🪨 📄 ✂️ game!")

    # 🧠 Load the model
    model = YOLO(WORK_PATH + "best.torchscript")

    # 📸 Create 2 columns to place a camera input for each player
    col1, col2 = st.columns(2)

    # Player 1
    with col1:
        # 📸 Camera input
        img_file_buffer_player1 = st.camera_input("Player 1 - Take your picture:", key="Player1")
        pred_player1 = predict_from_buffer(img_file_buffer_player1)

    # Player 2
    with col2:
        # 📸 Camera input
        img_file_buffer_player2 = st.camera_input("Player 2 - Take your picture:", key="Player2")
        pred_player2 = predict_from_buffer(img_file_buffer_player2)

    # Display winner
    find_winner(pred_player1, pred_player2)