function [SIFT_OUT] = featureExtractionKmeans(root_dir, sampling, cspaces, images_per_class, amount_img_per_class)
% function that extracts SIFT features from images
%
% Input parameters:
% ===================
% root_dir: Root directory where images are situated
% mode: 2 possible values "train" or "test", also determines where to look
%       for the input images
% sampling: 3 possible values "point", "dense" or "all"
% colorSIFT: array of colorspaces, can be one or more or empty (only
%            Intensity then). Possible values:
%            RGB, rgb , opp
% img_cat: one category e.g. 'cars' or 'all' for all categories
% images_per_class: the amount of images you want to sample random for
% training
% amount_img_per_class: how many images does a class contains in total, in
% general is this 500 for training and 50 for testing, but while developing
% to could vary
%
% Output parameters:
% ===================
% saves the following matrices to the current working directory
% (1) one matrix for all features of all images.
%     dimension N x 128 (N = number of features)
% (2) per category a matrix with all features per image. The first column
% is equal to the image number (e.g. img021.jpg => img ID = 21).
% NOTE: ths matrix is stored in the category specific directory, e.g. if
% mode = 'train' and processing category 'cars' then the matrix is stored
% in root_dir/cars_train/ directory
%
% sample invocation
% 
% featureExtractionv1('S:/workspace/cv_final/ImageData', 'train', 'point', '', 'cars');


    % global variable, binSize for dense sampling
    binSize = 8;
    % define the image categories
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};
    num_cats = length(img_cats);
    
   
    max_amount_img_per_class = 500;
    min_amount_img_per_class = 50;
    % three potential colorspaces: RGB, rgb and opponent
    
    % always get the images for training the kMeans for the training data
    mode = 'train';
    if images_per_class > max_amount_img_per_class 
        images_per_class = max_amount_img_per_class
    elseif images_per_class < min_amount_img_per_class
        images_per_class = min_amount_img_per_class
    end 


    % prepare the output matrix for the SIFT descriptors
    SIFT_OUT = [];
    for cats=1:num_cats  % loop through all image categories
        % prepare the input directory based on the "mode" and the "category"
        i_dir = strcat(root_dir, '/', img_cats{cats}, '_', mode, '/');
        % construct search mask
        search_mask = strcat(i_dir, '*.jpg');
        ifiles = dir(search_mask);
        
        % random sample n images_per_class from the total amount_img_per_class
        random_img_indexes = randsample(linspace(1,amount_img_per_class,amount_img_per_class),images_per_class);
        
        % loop through images
        for i= random_img_indexes
            % extract image ID
            imgID = str2double(ifiles(i).name(4:end-4));
            imgFile = strcat(i_dir, ifiles(i).name); 
            Img = imread(imgFile);
            % if we also need to compute colorSIFT descriptors we need to
            % transform the image       
            sift_d = compute_SIFT_desc(Img, sampling);
            
            SIFT_OUT = cat(1, SIFT_OUT, sift_d);
            if ~ isempty(cspaces)
                sift_c_d = processColorChannels(Img, cspaces, sampling);
                % concatenate Intensity features WITH color features
                sift_d   = cat(1, sift_d, sift_c_d);
                SIFT_OUT = cat(1, SIFT_OUT, sift_d);
            end
            % finally make a matrix per image
            % first column contains image number in that category
            sift_d = double(sift_d);
        end  % loop through images
        
    end % loop through all image categories

   

% ======================== END MAIN FUNCTION ===========================

% ========================= SUB FUNCTIONS ==============================

    function sift_c_out=processColorChannels(I1, cspaces, sample_mode)
        % find features in rgb image, first encode RGB to rgb
        % then find features
        % 
        % loop through color spaces
        sift_c_out = [];
        
        for c=1:length(cspaces)
           
            if strcmp(cspaces{c}, 'RGB')
                % in case of RGB we don't need to convert
                imgc = I1;
            else
                % convert to target colorspace
                imgc = convertColorspace(I1, cspaces{c}); 
            end
            % loop through color channels
            for ch=1:size(imgc,3)
                fd = compute_SIFT_desc(I1, sample_mode);
                sift_c_out = cat(1, sift_c_out, fd);
                % convert to opponent colorspace and then find features
            end
        end
        
    end % processColorChannels

    function sift_d=compute_SIFT_desc(I1, sample_mode)

        % if necessary convert ot grayscale
        if size(I1,3) > 1
            I1 = single(rgb2gray(I1));
        else
            I1 = single(I1);
        end
        
        if strcmp(sample_mode, 'point')
            % sparse/point sampling
            [~, sift_d] = vl_sift(I1);
        elseif strcmp(sample_mode, 'dense')
            % dense sampling
            [~, sift_d] = vl_dsift(I1);
        elseif strcmp(sample_mode, 'all')
            % compute both, point & dense
            [~, d1] = vl_sift(I1);
            [~, d2] = vl_dsift(I1, 'size', binSize);
            sift_d = cat(2, d1, d2);  
        end
        % we need to return the transpose because d is 128 x K
        sift_d = transpose(sift_d);
        
    end  % compute_graySIFT_desc
% ========================= SUB FUNCTIONS ==============================

end % featureExtractionv1