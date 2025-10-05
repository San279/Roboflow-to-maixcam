## Converting YOLO11 .onnyx to .cvimodel (REFERECE FROM SOPHGO SG2002)
[Original repo](https://github.com/AIWintermuteAI/maixcam-model-conversion?tab=readme-ov-file)
<br/>

[en](https://github.com/San279/Roboflow-to-maixcam/blob/main/README-det.md)
<br/>

![alt text](assets/det.jpg)
<br/>
<br/>

#### 1. Model transformation

- สำหรับโมเดลตรวจจับวัตถุ ให้อัปโหลดไฟล์ .onnx ของคุณไปที่ https://netron.app/ และใส่ชื่อของ convolution ตัวสุดท้ายใน --output_names "" หรือใช้ YOLO11 สามารถใช้คำสั่งนี้ได้เลย 
<br/>

- อย่าลืม set ค่า input_shapes ให้ตรงกับ imgz จาก Google Colab

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

#### 2. การสอบเทียบค่าความละเอียด (Quantization calibration)

- ให้อัพโหลดใช้รูปภาพเหล่านี้ต้องเป็นภาพที่โมเดลจะได้เห็นตอน deploy ประมาณ 100 รูป (เช่น หากคุณกำลังตรวจจับรถยนต์ ให้ใช้รูปภาพรถยนต์) รูปภาพในแฟ้มนี้สามารถนำไปใช้สำหรับตรวจจับผู้คนเท่านั้น

```
run_calibration yolov11n.mlir \
--dataset ./calibration_images-det \
--input_num 100 \
-o yolov11n_cali_table
```
<br/><br/>

#### 3. การแปลง (Conversion)

- ขั้นตอนสุดท้าย แปลงโมเดลเป็น .cvimodel

```
model_deploy \
--mlir yolov11n.mlir \
--quantize INT8 \
--calibration_table yolov11n_cali_table \
--processor cv181x \
--model yolov11n_cv181x_int8_sym.cvimodel
```
<br/><br/>

#### 4. แก้ไข labels ใน model-det.mud

- เปิดไฟล์ model-det.mud และเพิ่ม labels ให้ตรงกับชุดข้อมูลจาก Roboflow หากต้องการดู labels ให้นำทางหน้าหลักของโปรเจกต์เพื่อดูคลาส
<br/>

![alt text](assets/4-det.jpg) 
<br/>

- แก้ไข labels ให้ เหมือนกัน
<br/>

![alt text](assets/4.1-det.jpg) 
<br/><br/>


#### 5. อัปโหลดโมเดลและรันสคริปต์
- เชื่อมต่อกับ MaixCam โดยใช้ MaixVision IDE อัปโหลดไฟล์ model-det.mud และ (yolov11n_cv181x_int8_sym.cvimodel) ไปยังไดเรกทอรี models ของ MaixCam
<br/>

![alt text](assets/5-det.jpg) 
<br/>

- รันสคริปต์ detect.py

![alt text](assets/5.1-det.jpg) 



