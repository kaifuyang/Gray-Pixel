clc; clear;
load('F:\Datasets\CCdatasets\ColorCheckerRECommended\colorchecker\groundtruthcoordinates\ColorCheckerData.mat');  
main_path='F:\Datasets\CCdatasets\ColorCheckerRECommended\colorchecker\images\';
maskpath = 'F:\Datasets\CCdatasets\ColorCheckerRECommended\colorchecker\masks\';

files = dir(fullfile(main_path,'*.tiff')); 
Nimg=length(files); 

for i = 1:Nimg
    fprintf(2,'Processing image %d/%d...\n',i,Nimg);
    
    img = double(imread([main_path files(i).name]));
    idx = find(files(i).name == '_');
    gt = REC_groundtruth(str2num(files(i).name(1:idx-1)),:);

    mask1 = rgb2gray(imread([maskpath 'mask1_' files(i).name(idx+1:end)]));
    mask2 = rgb2gray(imread([maskpath 'mask2_' files(i).name(idx+1:end)]));
    mask3 = rgb2gray(imread([maskpath 'mask3_' files(i).name(idx+1:end)]));
    
    mask = ~(logical(mask1) & logical(mask2) & logical(mask3));
    
    [Pillum,Greyout] = GrayAnchoring(img,mask);
    Perf(i) = angerr(Pillum,gt);

end

[men,median,trimean,bst25,wst25] = evaluate(Perf);
[median,men,trimean,bst25,wst25]


