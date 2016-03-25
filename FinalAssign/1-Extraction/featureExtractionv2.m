function [SIFT_OUT,IMAGES_INDEX] = featureExtractionv2(root_dir, mode, sampling, cspaces, img_cat, save_data)
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
% colorSIFT: array of colorspaces, can be one or more or empty (only
%            Intensity then). Possible values:
%            RGB, rgb , opp
% img_cat: one category e.g. 'cars' 
% save_data: boolean indicating whether the result matrices will be saved
% to the image-category directory
%
% Output parameters:
% ===================
% returns the following matrices 
% (1) one matrix for all features of all images.
%     dimension N x 128 (N = number of features)
% (2) 
% 
%

    % prepare the output matrix for the SIFT descriptors
    SIFT_OUT = [];
    
    %vector that with size (features of all imges per class, 1) this
    %contains for every feature for this class the image ID, so we know
    %which feature belongs to which images when we are going to make the
    %histograms
    IMAGES_INDEX = [];

    % prepare the input directory based on the "mode" and the "category"
    i_dir = strcat(root_dir, '/', img_cat, '_', mode, '/');
    % construct search mask
    search_mask = strcat(i_dir, '*.jpg');
    ifiles = dir(search_mask);
    % initialize matrix for this category
    SIFT_OUT_CAT = [];

    % variable to identify the image
    index = 1;
    % loop through images
    for i=1:length(ifiles)
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
        % vector with the img ID for all the feature vectors for this
        % img
        index_vector = zeros(size(sift_d, 1), 1);
        index_vector(:) = index;


        % dit doe ik ook voor img 2 (die krijgt dan ID 2 i.p.v 1) etc.
        %Echter, deze functie werkt nu alleen als je de feature descriptors bepaalt voor 1 class, niet meer omdat je dan de ID's 
        % niet meer kloppen
        % ook moeten we even checken of dit blijft werken als we met
        % meerdere cspaces werken etc.

        index =  index + 1;
        IMAGES_INDEX = cat(1, IMAGES_INDEX,index_vector);

        % finally make a matrix per image
        % first column contains image number in that category
        sift_d = double(sift_d);
        t = cat(2, repmat(imgID, size(sift_d, 1), 1), sift_d);
        SIFT_OUT_CAT = cat(1, SIFT_OUT_CAT, t);
    end  % loop through images

    % save results for this category
    if size(SIFT_OUT_CAT,1) > 1 && save_data
        save(strcat(i_dir, img_cat, '_', mode, '.mat'), 'SIFT_OUT_CAT');
    end


    % save result to file
    if size(SIFT_OUT,1) > 1 && save_data
        % save(strcat(img_cat, '_', mode, '.mat'), 'SIFT_OUT');
        save(strcat('features_', mode, '.mat'), 'SIFT_OUT');
    end

% ======================== END MAIN FUNCTION ===========================


end % featureExtractionv2