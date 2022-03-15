clear; close all;

%% load inference data
spath = 'D:\DBT_challenge\val\labels\'; % label files
imgfolder = 'E:\DBT_challenge\val\processed_img2\images\'; % image folder
outputname = 'yolov5m_baseline_actFPs.mat'; % export model name
consolidate_inference_txt(spath,imgfolder,outputname)

%% Arrange for DBTex submission format
function consolidate_inference_txt(spath,imgfolder,outputname)
fnames = dir(fullfile(spath,'*.txt'));
d = 1;
PatientID = string([]); StudyUID = string([]); View = string([]); Z = []; label = [];
for i = 1:length(fnames)
    fNa = fnames(i).name;
    indx = strfind(fNa,'_');
    PatientID(d,:) = fNa(1:indx(1)-1);
    StudyUID(d,:) = fNa(indx(1)+1:indx(2)-1);
    View(d,:) = fNa(indx(2)+1:indx(3)-1);
    
    box_text = textread(fullfile(fnames(i).folder,fnames(i).name));  
    
    img_path = fullfile(imgfolder,PatientID(d,:),StudyUID(d,:),View(d,:),[fNa(1:end-4),'.png']);
    img = imread(img_path);
    [ymax, xmax] = size(img(:,:,1));

    XcenterX = []; YCenter = []; width = []; height = []; score = [];
    for j = 1:size(box_text,1)
        Xcenter = box_text(j,2);
        Ycenter = box_text(j,3);
        width = box_text(j,4);
        height = box_text(j,5);
        score = box_text(j,6);

        PatientID(d,:) = fNa(1:indx(1)-1);
        StudyUID(d,:) = fNa(indx(1)+1:indx(2)-1);
        View(d,:) = fNa(indx(2)+1:indx(3)-1);
        
        X(d,1) = round((Xcenter - width/2)*xmax);
        Y(d,1) = round((Ycenter - height/2)*ymax);
        Width(d,1) = round(width*xmax);
        Height(d,1) = round(height*ymax);
        Score(d,1) = score;
        Z(d,:) = str2num(fNa(indx(3)+6:end-4));
        label(d,:) = box_text(j,1);
        d = d +1;
    end        
end
proc_bbox = table(PatientID,StudyUID,View,X,Width,Y,Height,Z,Score,label);
save(outputname,'proc_bbox');
end




