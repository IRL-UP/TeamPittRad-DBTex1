close all; clear;
% % Load data
src = '..\DBT_challenge\Train_Proc';
label_loc = '..\DBT_challenge\results\labels'; % labels of baselineFPs
dst = '..\DBT_challenge\Img_FPs'; % destination image dir
load BCSDBTlabelstrain.mat
lnames = dir([label_loc,'*.txt']);

% % Storing image-label pair
for i = 1:length(lnames)
    disp(lnames(i).name);
    indx = strfind(lnames(i).name,'_');
    PID = lnames(i).name(1:indx(1)-1);
    view = lnames(i).name(indx(1)+1:indx(2)-1);
    slicen = lnames(i).name(indx(2)+1:end-4);
    
    findx = strcmp(BCSDBTlabelstrain.PatientID,PID);
    vindx = strcmp(BCSDBTlabelstrain.View,view);
    
    ii = find(findx&vindx);
    
    if BCSDBTlabelstrain.Normal(ii)
        label = 'Normal'; tlabel = '0';
    elseif BCSDBTlabelstrain.Cancer(ii)
        label = 'Cancer'; tlabel = '1';
    elseif BCSDBTlabelstrain.Benign(ii)
        label = 'Benign'; tlabel = '2';
    elseif BCSDBTlabelstrain.Actionable(ii)
        label = 'Actionable'; tlabel = '3';
    end
    
    img_path = fullfile(dst,'\images\',label,PID,view);
    label_path = fullfile(dst,'\labels\',label,PID,view);
    
    if ~isfolder(img_path)
        mkdir(img_path);
    end
    if ~isfolder(label_path)
        mkdir(label_path);
    end
    
    box_text = textread(fullfile(lnames(i).folder,lnames(i).name));
    box_text(:,1) = str2double(tlabel);
    
    ipath = fullfile(src,'\images\',label,PID,view);
    SR = fullfile(ipath,[lnames(i).name(1:end-4),'.png']);
    DS = fullfile(img_path,[lnames(i).name(1:end-4),'.png']);
    copyfile(SR,DS);
    fid = fopen(fullfile(label_path,lnames(i).name),'w'); % changle training lable file
  
    for ij = 1:size(box_text,1)
        fprintf(fid, '%s\n', num2str(box_text(ij,:))) ;
    end
    fclose(fid); 
end
