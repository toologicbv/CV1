function [SIFT_OUT,IMAGES_INDEX] = featureExtractionv2(root_dir, mode, sampling, cspace, img_cat)
% function that extracts SIFT features from images for ONE image category
%
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
% cspace: colorspace, can be one or empty (only
%            Intensity then). Possible values:
%            RGB, rgb , opp
% img_cat: one category e.g. 'cars' 
% save_data: boolean indicating whether the result matrices will be saved
% to the image-category directory
%
% Output parameters:
% ===================
% returns the following matrices 
% (1) one matrix for all features of all images of one image category.
%     dimension N x 128 (N = number of features)
% (2) a vector of the image indexes
% 
%

    % prepare the output matrix for the SIFT descriptors
    SIFT_OUT = [];
    
    % a vector that indicates the image ID for a row in matrix SIFT_OUT.
    % we use this vector when we quantize the image features.
    IMAGES_INDEX = [];

    % prepare the input directory based on the "mode" and the "category"
    i_dir = strcat(root_dir, '/', img_cat, '_', mode, '/');
    % construct search mask
    search_mask = strcat(i_dir, '*.jpg');
    ifiles = dir(search_mask);

    % variable to identify the image
    index = 1;
    % loop through images
    for i=1:length(ifiles)

        % construct input file for this image
        imgFile = strcat(i_dir, ifiles(i).name); 
        Img = imread(imgFile);
        
        % first compute the intensity SIFT descriptors
        sift_d = compute_SIFT_desc(Img, sampling);
        
        % if a colorspace is specified, compute the SIFT descriptors for
        % the different color channels
        if ~ isempty(cspace)
            sift_c_d = processColorChannels(Img, cspace, sampling);
            % concatenate Intensity features WITH color features
            sift_d   = cat(1, sift_d, sift_c_d);
            % after the concatenation of intensity and color detected
            % features, we take the unique rows for the image
            sift_d = unique(sift_d, 'rows');
            SIFT_OUT = cat(1, SIFT_OUT, sift_d);
            
        else
            % no colorSIFT features
            % concatenate to output matrix
            SIFT_OUT = cat(1, SIFT_OUT, sift_d);
        end
        % vector with the img ID for all the feature vectors for this
        % img
        index_vector = zeros(size(sift_d, 1), 1);
        index_vector(:) = index;
        index =  index + 1;
        IMAGES_INDEX = cat(1, IMAGES_INDEX, index_vector);

    end  % loop through images


% ======================== END MAIN FUNCTION ===========================


end % featureExtractionv2