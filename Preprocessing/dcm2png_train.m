clear; close all;

% Load DBTex train dataset
load BCSDBTfilepathstrain.mat
load BCSDBTlabelstrain.mat
load BCSDBTboxestrain.mat

sdrive = 'J:\DBT_challenge\'; % Image Source. 
ddrive = 'J:\DBT_challenge_Proc\'; % Image Destination. 
                              
% enable access to Python
% pe = pyenv;
% pe = pyenv('Version','C:\Users\UsrName\AppData\Local\Programs\Python\Python37\python.EXE');

for i = 1:length(BCSDBTfilepathstrain.PatientID)
    PID = char(BCSDBTfilepathstrain.PatientID(i));
    descriptive_path = BCSDBTfilepathstrain.descriptive_path(i);
    view = char(BCSDBTfilepathstrain.View(i));
    
    if BCSDBTlabelstrain.Normal(i)
        label = 'Normal'; tlabel = '0';
    elseif BCSDBTlabelstrain.Cancer(i)
        label = 'Cancer'; tlabel = '1';
    elseif BCSDBTlabelstrain.Benign(i)
        label = 'Benign'; tlabel = '2';
    elseif BCSDBTlabelstrain.Actionable(i)
        label = 'Actionable'; tlabel = '3';
    end
    
    if 0 % Matlab binary to png
        img_path = fullfile(sdrive,'processed_mat',label,PID);
        disp(['Reading: ',PID,'_',view]);
        load(fullfile(img_path,[PID,'_',view,'.mat']));
    end
    if 1 % DICOM to png
        image_path = fullfile(sdrive,descriptive_path);
        disp(['Reading: ',PID,'_',view]);
        image = py.duke_dbt_data.dcmread_image(pyargs('fp', image_path, 'view', view));
        img = uint16(image); % convert python ndarray to matlab uint16
        img = permute(img,[2 3 1]); % python order, z-x-y. Change it to Matlab order, x-y-z
    end
    
    % % Create directory
    img_path = fullfile(ddrive,'processed_img2','images',label,PID,view);
    label_path = fullfile(ddrive,'processed_img2','labels',label,PID,view);
    if ~isfolder(img_path)
        mkdir(img_path);
    end
    if ~isfolder(label_path)
        mkdir(label_path);
    end
    
    % % create YOLO label file
    [sy, sx] = size(img(:,:,1));
    pindx = strcmp(BCSDBTboxestrain.PatientID,PID);
    vindx = strcmp(BCSDBTboxestrain.View,view);
    boxindx = find(pindx&vindx);
    box_text = [];
    X = []; Y = []; Width = []; Height = []; slice = [];
    Xmax = []; Ymax = []; Xmin = []; Ymin = []; Xcenter = []; Ycenter = [];
    if ~isempty(boxindx)
        for ii = 1:length(boxindx)
            X(ii) = BCSDBTboxestrain.X(boxindx(ii));
            Y(ii) = BCSDBTboxestrain.Y(boxindx(ii));
            Width(ii) = BCSDBTboxestrain.Width(boxindx(ii));
            Height(ii) = BCSDBTboxestrain.Height(boxindx(ii));
            slice(ii) = BCSDBTboxestrain.Slice(boxindx(ii))+1;
        
            Xmax(ii) =  (X(ii) + Width(ii)); Xmin(ii) = (X(ii)); 
            Xcenter(ii) = round(0.5*(Xmax(ii)+Xmin(ii)))/sx;
            Ymax(ii) = (Y(ii)+ Height(ii)); Ymin(ii)= (Y(ii)); 
            Ycenter(ii) = round(0.5*(Ymax(ii)+Ymin(ii)))/sy;
            
            box_text{ii} = [tlabel,' ', num2str(Xcenter(ii)),' ', num2str(Ycenter(ii)),' ',...
                num2str(Width(ii)/sx),' ',num2str(Height(ii)/sy)];
            %%box_text = [tlabel, Xmin,',', Ymin,',', Xmax,',', Ymax,','];
        end
    else % for yolov5, if no objects in image, no *.txt file is required
        %box_text = [0,',', 0,',', 0,',', 0,',', label];
    end

    % % Exporting
    mid_slice = round(size(img,3)/2);
    max_slice = size(img,3);
    
    if ~isempty(boxindx)
        for ii = 1:length(boxindx)
            for j = max(slice(ii)-1,1):min(slice(ii)+1,max_slice)           
                pimg = img(:,:,j:j+2);

                slicenum = num2str(j-1);
                disp(['slice#',slicenum]);
                fname = [PID,'_',view,'_slice',slicenum,'.png'];
                
                imwrite(pimg,fullfile(img_path,fname),'BitDepth',8);
                fname = [PID,'_',view,'_slice',slicenum,'.txt'];
                fid = fopen(fullfile(label_path,fname),'a'); % changle training lable file
                fprintf(fid, '%s\n', box_text{ii});
                fclose(fid); 
            end
        end
    else
  
        for j = -floor(max_slice*15/100):2:floor(max_slice*15/100)
            pimg = img(:,:,mid_slice+j:mid_slice+j+2);
           
            slicenum = num2str(mid_slice+j-1);
            disp(['slice#',slicenum]);
            fname = [PID,'_',view,'_slice',slicenum,'.png'];
            
            imwrite(pimg,fullfile(img_path,fname),'BitDepth',8);          
            fname = [PID,'_',view,'_slice',slicenum,'.txt'];
%             fid = fopen(fullfile(label_path,fname),'a'); % changle training lable file
%                 fprintf(fid, '%s\n', box_text{ii});
%             fclose(fid); 
        end
    end
   
    disp('Done');

end
