## Instructions to create the application for AI Deploy

Here you find all steps to create and run an image to create an application based on the previous trained the model (with AI Training).

### Script creation

ℹ️ You can access to the solutions in the folder [src/app/solution](../src/app/solution) ℹ️

Follow the instructions in the [/src/app/app.py](../src/app/app.py) file to add code to create an application using the model.

If you need to debug your Python application you can run locally your app.
To run your application locally:
- install dependencies: `pip install -r requirements.txt`
- download / get the weights of your trained model and copy it to a `work` folder
- set the environment variables:
 - `export WORK_PATH=./work/`
- run the application: `streamlit run app.py`

### Image build

The Python script need to access to the following path mounted as volume in your image: `/workspace/attendee`.

The volume is the S3 object container storage previously used: `$STUDENT_ID@S3GRA`

The registry used to store the image is the an Harbor registry provided by OVHcloud, ask the speakers for the URL and account.

In `/src/app/`, build the image using Docker: `docker build . -t $REGISTRY_NAME/$STUDENT_ID/yolov8-rock-paper-scissors-app:1.0.0`.  
Then, authenticate to the registry: `docker login $REGISTRY_NAME  -u $REGISTRY_LOGIN -p $REGISTRY_PASSWORD`.
⚠️ Perhaps you have to remove some previous created Docker images to free space to build this image ⚠️
Then, push the builded image: `docker push $REGISTRY_NAME/$STUDENT_ID/yolov8-rock-paper-scissors-app:1.0.0`.

### App creation

 - run the app with AI App:
```bash
ovhai app run \
    --token $AI_TOKEN \
    --name $STUDENT_ID-yolov8-rock-paper-scissors-app \
    --cpu 1 \
    --default-http-port 8501 \
    --volume $STUDENT_ID@S3GRA:/workspace/attendee:RW:cache \
    --unsecure-http \
    $REGISTRY_NAME/$STUDENT_ID/yolov8-rock-paper-scissors-app:1.0.0
```
- get the logs: `ovhai app logs -f <app id> --token $AI_TOKEN`
- get the URL:
	- get the application id: `ovhai app list --token $AI_TOKEN` 
	- find the field `Url` in the details of the application with the command: `ovhai app get <app id> --token $AI_TOKEN`
	