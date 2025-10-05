[basic]
type = cvimodel
model = yolo_cls_int8_sym.cvimodel

[extra]
model_type = classifier
input_type = rgb
mean = 0, 0, 0
scale = 0.00392156862745098, 0.00392156862745098, 0.00392156862745098
anchors = 10,13, 16,30, 33,23, 30,61, 62,45, 59,119, 116,90, 156,198, 373,326
labels = Female_19-36, Female_3-18, Female_37-65, Male_19-36, Male_3-18, Male_37-65