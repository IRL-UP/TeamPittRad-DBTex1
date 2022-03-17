# Biopsied lesion detection using non-biopsied (actionable) false postive findings (actFPs)
- Biopseid lesion detection framework on DBT image using non-biopsied (actionable) false postives findings (actFPs). 
- The algorihtms were developed using MATLAB (ver 2021) and Pytorch (1.7.0) framework during the DBTex (phase 1) Grand challenge participation by Team-PittRad (University of Pittsburgh).
- Team Member: Md Belayat Hossain and Juhun Lee


## DBTex Grand Challenge
- Challenge Website, https://spie-aapm-nci-dair.westus2.cloudapp.azure.com/competitions/4

## Preprocessing
- dcm2png_train.m: Pre-processing DBTex Train Set to extract 2D slices and synthesize 2.5D images for augmented image set for training the model
- dcm2png_val.m: Pre-processing DBTex Validation/Test Set


## Model training
- The lesion detection models used MS COCO-pretrained YOLOv5 as detector model, https://github.com/ultralytics/yolov5 in Pytorch framework

## Lesion inferencing
- YOLOv5 deteciton method, https://github.com/ultralytics/yolov5, was used for preliminary lesion inferencing on DBT image slice in Pytorch framework

## Baseline FPs Findings 
- Updating_BaselineFPs_label.m: Creating augmented training images (e.g., image-label pairs) using non-biopsied (actionable) FPs findings.

## Post Processing
- consolidate_inferences_single.m: Inferencing from a single model for DBTex submission format 
- consolidate_inferences_ensemble.m: Inferencing using Ensemble approach for DBTex submission

## Pre-Requisite
### Read DBT DICOM image
- Use the "dcmread_image" functions from "duke-dbt-data.py", https://github.com/MaciejMazurowski/duke-dbt-data
### MATLAB
- Image processing toolbox, MATLAB (Ver. 2021)
### Additional Functions
- Use from "duke-dbt-data", https://github.com/MaciejMazurowski/duke-dbt-data
- YOLOv5 repository in Pytorch, https://github.com/ultralytics/yolov5
