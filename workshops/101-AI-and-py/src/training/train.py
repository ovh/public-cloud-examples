import ultralytics
from ultralytics import YOLO
import shutil
import os

#######################################################################################################################
## 🎯 The aim of this script is to do transfert learning on YOLOv8 model.                                            ##
## ℹ️ Note on the environments variables:                                                                            ##
##      - NB_OF_EPOCHS (default value: 50) is an environment variable passed to the Docker run command to specify    ##
## the number of epochs                                                                                              ##
##      - DEVICE_TO_USE (default value 0) is to specify to use GPU (0) or CPU (cpu)                                  ##
##		  - PATH_TO_DATASET (default value is '/workspace/attendee/data.yaml') is to specify the path to the           ##
## training dataset                                                                                                  ##
##		  - PATH_TO_EXPORTED_MODEL (default value is '/workspace/attendee/') is to specify the path where export the   ##
## trained model                                                                                                     ##
#######################################################################################################################

# ✅ Check configuration

# 🧠 Load a pretrained YOLO model


# 🛠 Get configuration from environment variables

# 💪 Train the model with new data ➡️ one GPU / NB_OF_EPOCHS iterations (epochs)

# 💾 Save the model

# ➡️ Copy the model to the object storage
