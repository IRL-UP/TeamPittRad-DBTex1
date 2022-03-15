clear; close all;

% load inferences of the models
load yolov5m_baseline_actFPs.mat proc_bbox
proc_bbox1 = proc_bbox;

% score_th = 0.25;
% indx = proc_bbox.Score>score_th;
% proc_bbox(~indx,:)= [];
% proc_bbox.Score = proc_bbox.Score *1;
% proc_bbox1 = proc_bbox;

load yolov5l_baseline_actFPs.mat proc_bbox
proc_bbox2 = proc_bbox;

% indx = proc_bbox.Score>score_th;
% proc_bbox(~indx,:)= [];
% proc_bbox.Score = proc_bbox.Score * 1;
% proc_bbox2 = proc_bbox;

% Concaternating
proc_bbox = [proc_bbox1; proc_bbox2];
  

%% volumetric post-processing

d = 1;
oPID = string([]); oUID = string([]); oview = string([]); 
ox = []; oy = []; ow = []; oh = []; oz = [];  od = []; os = [];

[PID2,IA,IC] = unique(proc_bbox.PID);
for i = 1:length(PID2)
    pindx = find(IC == i);
    
    uids = proc_bbox.UID(pindx);
    views = proc_bbox.view(pindx);
    scores = proc_bbox.Score(pindx);
    labels = proc_bbox.label(pindx);
    bbox = [proc_bbox.X(pindx) proc_bbox.Width(pindx) proc_bbox.Y(pindx) proc_bbox.Height(pindx) proc_bbox.slice(pindx)];
    [uids2,IA2,IC2] = unique(uids);
    pimg = [];
    
    for j = 1:length(uids2)
        pimg(j).rcc = zeros(2500,2000,100,'single');
        pimg(j).rmlo = zeros(2500,2000,100,'single'); 
        pimg(j).lcc = zeros(2500,2000,100,'single');
        pimg(j).lmlo = zeros(2500,2000,100,'single');
        uindx = find(IC2 == j);
        
        for ij = 1:length(uindx)
            R = bbox(uindx(ij),3)+1; R2 = bbox(uindx(ij),4)+R;
            C = bbox(uindx(ij),1)+1; C2 = bbox(uindx(ij),2)+C;
            S = bbox(uindx(ij),5)+1; 

            views3 = views{uindx(ij)};
            labels2 = labels(uindx(ij));
            if labels2 >0
                sc = scores(uindx(ij));
            else
                sc = scores(uindx(ij));
            end
            if 1 %labels2 >0
%                 if length(pimg) < j
                    switch views3(1:3)
                        case 'rcc'
                            pimg(j).rcc(R:R2,C:C2,S) = (sc);

                        case 'rml'
                            pimg(j).rmlo(R:R2,C:C2,S) = (sc );

                        case 'lcc'
                            pimg(j).lcc(R:R2,C:C2,S) = (sc );
                        case 'lml'
                            pimg(j).lmlo(R:R2,C:C2,S) = (sc ); 
                    end
%                 else
%                     switch views3(1:3)
%                         case 'rcc'
%                             pimg(j).rcc(R:R2,C:C2,S) = 0.5*(sc + pimg(j).rcc(R:R2,C:C2,S));
% 
%                         case 'rml'
%                             pimg(j).rmlo(R:R2,C:C2,S) = 0.5*(sc + pimg(j).rmlo(R:R2,C:C2,S));
% 
%                         case 'lcc'
%                             pimg(j).lcc(R:R2,C:C2,S) = 0.5*(sc + pimg(j).lcc(R:R2,C:C2,S));
%                         case 'lml'
%                             pimg(j).lmlo(R:R2,C:C2,S) = 0.5*(sc + pimg(j).lmlo(R:R2,C:C2,S)); 
%                     end
%                 end
            end
        end

        if sum(pimg(j).rcc(:)) > 0
            pimg(j).rcc = pimg(j).rcc/max(pimg(j).rcc(:)); 
            timg = imclose(pimg(j).rcc>0,strel('cube',5));
            an = bwlabeln(timg);
            for ji = 1:max(an(:))
                [r,c,v] = ind2sub(size(an),find(an == ji));
                x = min(c); x2 = max(c);
                y = min(r); y2 = max(r);
                z = min(v); z2 = max(v);
                scrs = max(pimg(j).rcc(an == ji));

                oPID(d,1) = PID2(i);
                oUID(d,1) = uids2(j);
                oview(d,1) = "rcc";
                ox(d,1) = x; oy(d,1) = y; oz(d,1) = z;
                ow(d,1) = x2-x+1; oh(d,1) = y2-y+1; od(d,1) = z2-z+1;
                os(d,1) =  scrs;

                d = d+1;
            end
                
        end
        if sum(pimg(j).rmlo(:)) > 0
            pimg(j).rmlo = pimg(j).rmlo/max(pimg(j).rmlo(:));
            timg = imclose(pimg(j).rmlo>0,strel('cube',5));
            an = bwlabeln(timg);
            for ji = 1:max(an(:))
                [r,c,v] = ind2sub(size(an),find(an == ji));
                x = min(c); x2 = max(c);
                y = min(r); y2 = max(r);
                z = min(v); z2 = max(v);
                scrs = max(pimg(j).rmlo(an == ji));

                oPID(d,1) = PID2(i);
                oUID(d,1) = uids2(j);
                oview(d,1) = "rmlo";
                ox(d,1) = x; oy(d,1) = y; oz(d,1) = z;
                ow(d,1) = x2-x+1; oh(d,1) = y2-y+1; od(d,1) = z2-z+1;
                os(d,1) = scrs;

                d = d+1;
            end
        end
        if sum(pimg(j).lcc(:)) > 0
            pimg(j).lcc = pimg(j).lcc/max(pimg(j).lcc(:));
            timg = imclose(pimg(j).lcc>0,strel('cube',5));
            an = bwlabeln(timg);
            for ji = 1:max(an(:))
                [r,c,v] = ind2sub(size(an),find(an == ji));
                x = min(c); x2 = max(c);
                y = min(r); y2 = max(r);
                z = min(v); z2 = max(v);
                scrs = max(pimg(j).lcc(an == ji));

                oPID(d,1) = PID2(i);
                oUID(d,1) = uids2(j);
                oview(d,1) = "lcc";
                ox(d,1) = x; oy(d,1) = y; oz(d,1) = z;
                ow(d,1) = x2-x+1; oh(d,1) = y2-y+1; od(d,1) = z2-z+1;
                os(d,1) = scrs;

                d = d+1;
            end
        end
        if sum(pimg(j).lmlo(:)) > 0
            pimg(j).lmlo = pimg(j).lmlo/max(pimg(j).lmlo(:));
            timg = imclose(pimg(j).lmlo>0,strel('cube',5));
            an = bwlabeln(timg);
            for ji = 1:max(an(:))
                [r,c,v] = ind2sub(size(an),find(an == ji));
                x = min(c); x2 = max(c);
                y = min(r); y2 = max(r);
                z = min(v); z2 = max(v);
                scrs = max(pimg(j).lmlo(an == ji));

                oPID(d,1) = PID2(i);
                oUID(d,1) = uids2(j);
                oview(d,1) = "lmlo";
                ox(d,1) = x; oy(d,1) = y; oz(d,1) = z;
                ow(d,1) = x2-x+1; oh(d,1) = y2-y+1; od(d,1) = z2-z+1;
                os(d,1) = scrs;

                d = d+1;
            end
        end
        disp('done');
    end
end
PatientID = oPID; StudyUID = oUID; View = oview; 
X = ox-1; Width = ow; Y = oy-1; Height = oh; Z = oz-1; 
Depth = od; Score = os;
proc_bbox2 = table(PatientID,StudyUID,View,X,Width,Y,Height,Z,Depth,Score);

% save Ensemble_M+L.mat proc_bbox2
writetable(proc_bbox2,'Ensemble_M+L.csv'); % For DBTex Submission


 