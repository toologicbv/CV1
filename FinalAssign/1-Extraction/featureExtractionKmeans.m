function [SIFT_OUT] = featureExtractionKmeans(root_dir, sampling, cspace, images_per_class)
% function that extracts SIFT features from images contained in the
% different subdirectories (categories) of the root directory e.g. faces,
% motorbikes etc.
% Computervision I / Final Assignment
% Jörg Sander / 10881530
% Maurits Bleeker / 10694439
%
% Input parameters:
% ===================
% root_dir: Root directory where images are situated
% mode: 2 possible values "train" or "test", also determines where to look
%       for the input images
% sampling: 3 possible values "point", "dense" or "all"
% cspace: colorspaces, can be one or empty (only
%            Intensity then). Possible values:
%            RGB, rgb , opp
% images_per_class: the amount of images you want to sample random for
% training
%
% Output parameters:
% ===================
% returns the following matrix to the current working directory
% (1) one matrix for all features of all images.
%     dimension N x 128 (N = number of features)

    % define the image categories
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};
    num_cats = length(img_cats);
    % for the construction of the codebook we only sample images from the
    % training directory of the image categories
    mode = 'train';
    
    % three potential colorspaces: RGB, rgb and opponent
    
    % prepare the output matrix for the SIFT descriptors
    SIFT_OUT = [];
    for cats=1:num_cats  % loop through all image categories
        % prepare the input directory based on the "mode" and the "category"
        i_dir = strcat(root_dir, '/', img_cats{cats}, '_', mode, '/');
        % construct search mask
        search_mask = strcat(i_dir, '*.jpg');
        ifiles = dir(search_mask);
        % determine the total number of images for this category
        amount_img_per_class = length(ifiles);
        % make sure that image_per_class is never greater than the total
        % number of images we have in this category
        if images_per_class > amount_img_per_class 
            images_per_class = amount_img_per_class;
        end
        % random sample n images_per_class from the total amount_img_per_class
        random_img_indexes = randsample(linspace(1,amount_img_per_class,amount_img_per_class),images_per_class);
        
        % loop through images
        for i= random_img_indexes
            % extract image ID
            
            imgFile = strcat(i_dir, ifiles(i).name); 
            Img = imread(imgFile);
            % if we also need to compute colorSIFT descriptors we need to
            % transform the image       
            sift_d = compute_SIFT_desc(Img, sampling);
            
            SIFT_OUT = cat(1, SIFT_OUT, sift_d);
            if ~ isempty(cspace)
                sift_c_d = processColorChannels(Img, cspace, sampling);
                % concatenate Intensity features WITH color features
                sift_d   = cat(1, sift_d, sift_c_d);
                SIFT_OUT = cat(1, SIFT_OUT, sift_d);
            end
            
        end  % loop through images
        
    end % loop through all image categories
% ======================== END MAIN FUNCTION ===========================

end % featureExtractionKmeans