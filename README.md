# Biopsied lesion detection using non-biopsied (actionable) false postive findings (actFPs)
- Biopseid lesion detection framework on DBT image using non-biopsied (actionable) false postives findings (actFPs). 
- The algorihtms were developed using MATLAB (ver 2021) and Pytorch framework during the DBTex (phase 1) Grand challenge participation by Team-PittRad (University of Pittsburgh).


## DBTex biopsied lesion detection challenge
- Challenge Website, https://spie-aapm-nci-dair.westus2.cloudapp.azure.com/competitions/4

## Read DBT DICOM image
Use the "dcmread_image" functions from "duke-dbt-data.py",
https://github.com/MaciejMazurowski/duke-dbt-data

## Preprocessing
- dcm2png_train.m: Pre-processing DBTex Train Set to create 2D slices for constructing our traning set
- dcm2png_val.m: Pre-processing DBTex Validation/Test Set

## Model training
- The lesion detection models used MS COCO-pretrained YOLOv5 as detector model, https://github.com/ultralytics/yolov5 in Pytorch framework


## Baseline FPs Findings 
- Updating_BaselineFPs_label.m: Creating image-label pairs for baseline FPs findings


## Lesion inferencing
- YOLOv5 deteciton method, https://github.com/ultralytics/yolov5, was used for preliminary lesion inferencing on DBT image slice in Pytorch framework

## Post Processing
- consolidate_inferences_single.m: Inferecning for DBTex submission format from a single model 
- consolidate_inferences_ensemble.m: Inferencing using Ensemble approach for DBTex submission

## Prerequisite
### Read DBT DICOM image
- Use the "dcmread_image" functions from "duke-dbt-data.py", https://github.com/MaciejMazurowski/duke-dbt-data


## Additional Functions
- Use from "duke-dbt-data", https://github.com/MaciejMazurowski/duke-dbt-data
- YOLOv5 repository in Pytorch, https://github.com/ultralytics/yolov5
