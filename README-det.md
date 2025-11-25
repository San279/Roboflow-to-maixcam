## Converting YOLO11 .onnyx to .cvimodel (REFERECE FROM SOPHGO SG2002)
[Original repo](https://github.com/AIWintermuteAI/maixcam-model-conversion?tab=readme-ov-file)
<br/>

[en](https://github.com/San279/Roboflow-to-maixcam/blob/main/README-det.md)
<br/>

![alt text](assets/det.jpg)

<br/>
<br/>

#### 1. Build and Run Dockerfile
- Access the terminal from the root's project (Alternative IDE is preferable)
![alt text](assets/0-cmd.jpg)

![alt text](assets/0-terminal.jpg)
- Build Dockerfile
```
docker build -t sophgo-mlir:v1.7 .
```
<br/><br/>

- Run the Docker image
```
docker run -it --name tpu_mlir_session tpu-mlir-dev:latest /bin/bash
```
<br/><br/>

#### 2. Model transformation

- For classification model upload your onnyx file to (https://netron.app/) and place the name of the last convolutions in output_names "", Alternatively if you used yolov11 you can use this default command 
<br/>

- Make sure that input_shapes match imgz from your colab command

![alt text](assets/1-det.jpg)

```
model_transform \
--model_name yolov11n \
--model_def best.onnx \
--input_shapes [[1,3,320,320]] \
--mean 0.0,0.0,0.0 \
--scale 0.0039216,0.0039216,0.0039216 \
--keep_aspect_ratio \
--pixel_format rgb \
--output_names "/model.23/Concat_output_0","/model.23/Concat_1_output_0","/model.23/Concat_2_output_0","/model.23/dfl/conv/Conv_output_0","/model.23/Sigmoid_output_0" \
--mlir yolov11n.mlir
```
<br/><br/>

#### 3. Quantization calibration

- For calibration, use approximately 100 unlabeled images. These images must be specific to your model's target task (e.g., if you're detecting cars, use car images). The default face detection images in this repository should only be used if your model is a person detector

```
run_calibration yolov11n.mlir \
--dataset ./calibration_images-det \
--input_num 100 \
-o yolov11n_cali_table
```
<br/><br/>

#### 4. Conversion

- The last step is to convert the model into .cvimodel

```
model_deploy \
--mlir yolov11n.mlir \
--quantize INT8 \
--calibration_table yolov11n_cali_table \
--processor cv181x \
--model yolov11n_cv181x_int8_sym.cvimodel
```
<br/><br/>

#### 5. Edit model-det.mud labels

- Open model-det and add your own labels. To view your labels navigate to the main page of the project to view the classes
<br/>

![alt text](assets/4-det.jpg) 
<br/>

- Edit the label accordingly
<br/>

![alt text](assets/4.1-det.jpg) 
<br/><br/>


#### 6. Final step, upload model and run script in Maixcam
- Connect to MaixCam using MaixVision IDE. Upload (model-det.mud) and (yolov11n_cv181x_int8_sym.cvimodel) into MaixCam models directory
<br/>

![alt text](assets/5-det.jpg) 
<br/>

- Run the script detect.py

![alt text](assets/5.1-det.jpg) 

