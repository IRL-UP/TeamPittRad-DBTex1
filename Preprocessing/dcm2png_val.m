clear; close all;

% Load DBTex validation/test dataset
load BCSDBTfilepathsvalidation.mat
sdrive = 'J:\DBT_challenge\Validation\'; % Image Source
ddrive = 'J:\DBT_challenge\Validation_Proc\'; % Image Destination 
                              
% enable access to Python
% pe = pyenv;
% pe = pyenv('Version','C:\Users\UsrName\AppData\Local\Programs\Python\Python37\python.EXE');

for i = 1:length(BCSDBTfilepathsvalidation.PatientID)
    PID = char(BCSDBTfilepathsvalidation.PatientID(i));
    UID = char(BCSDBTfilepathsvalidation.StudyUID(i)); 
    descriptive_path = BCSDBTfilepathsvalidation.descriptive_path(i);
    view = char(BCSDBTfilepathsvalidation.View(i));
    
    if 0 % Matlab binary to png
        img_path = fullfile(sdrive,'processed_mat',PID);
        disp(['Reading: ',PID,'_',view]);
        load(fullfile(img_path,[PID,'_',UID,'_',view,'.mat']));
    end
    if 1 % DICOM to png
        image_path = fullfile(sdrive,descriptive_path);
        disp(['Reading: ',PID,'_',view]);
        image = py.duke_dbt_data.dcmread_image(pyargs('fp', image_path, 'view', view));
        img = uint16(image); % convert python ndarray to matlab uint16
        img = permute(img,[2 3 1]); % python order, z-x-y. Change it to Matlab order, x-y-z
    end
    
    %% Create directory 
    img_path = fullfile(ddrive,'processed_img2','images',PID,UID,view);
    label_path = fullfile(ddrive,'processed_img2','labels',PID,UID,view);
    if ~isfolder(img_path)
        mkdir(img_path);
    end
%     if ~isfolder(label_path)
%         mkdir(label_path);
%     end
    

    %% Export
    mid_slice = round(size(img,3)/2);
    max_slice = size(img,3);
    rng_slice = 70; % percent to cover
  
    for j = -floor(max_slice*(rng_slice/2)/100):1:floor(max_slice*(rng_slice/2)/100)
        pimg = img(:,:,mid_slice+j:mid_slice+j+2);

        slicenum = num2str(mid_slice+j-1);
        disp(['slice#',slicenum]);
        fname = [PID,'_',UID,'_',view,'_slice',slicenum,'.png'];
        imwrite(pimg,fullfile(img_path,fname),'BitDepth',8);

    end
    disp('Done');
end