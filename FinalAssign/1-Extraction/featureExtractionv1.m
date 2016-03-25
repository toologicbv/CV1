function [SIFT_OUT,IMAGES_INDEX,amount_of_images] = featureExtractionv1(root_dir, mode, sampling, cspaces, img_cat, save_data, images_per_class)
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
    % three potential colorspaces: RGB, rgb and opponent

    if strcmp(img_cat, ' ') || strcmp(img_cat,'') || strcmp(img_cat, 'all')
        num_cats = length(img_cats);
    else
        num_cats = 1;
        img_cats = { img_cat };
    end

    
    % NOTE!!!!!!! THIS IS 500, 50 IS FOR DEVELOPMENT(MAURITS)
    max_amount_img_per_class = 50;
    
    mode = 'train';
    if images_per_class > max_amount_img_per_class 
        images_per_class = max_amount_img_per_class;
    end 
    

    % prepare the output matrix for the SIFT descriptors
    SIFT_OUT = [];
    
    %vector that with size (features of all imges per class, 1) this
    %contains for every feature for this class the image ID, so we know
    %which feature belongs to which images when we are going to make the
    %histograms
    IMAGES_INDEX = [];
    
    % counter how many images we have 
    amount_of_images = 0;
    
    %counter variable
    index = 1;
    for cats=1:num_cats  % loop through all image categories
        % prepare the input directory based on the "mode" and the "category"
        i_dir = strcat(root_dir, '/', img_cats{cats}, '_', mode, '/');
        % construct search mask
        search_mask = strcat(i_dir, '*.jpg');
        ifiles = dir(search_mask);
        % initialize matrix for this category
        SIFT_OUT_CAT = [];
        IMG_INDEX = [];
        
        
        % this is the total amount of images we processed in this function,
        % so for every new class we have to add the amount of images
        amount_of_images = amount_of_images + length(ifiles);
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
            % vecor with the img ID for all the feature vectors for this
            % img
            index_vector = zeros(size(sift_d, 1), 1);
            index_vector(:) = index;
            
            % AAN JORG: Zou je even kijken hoe dit beter/handiger kan.
            % IMG_INDEX is een vector die per feature bijhoudt van welke
            % images deze feature is, ik neem even aan (en dit klopt ook)
            % dat we altijd van img001, img002, img003 etc. gaan. Stel ik
            % krijg voor de eerstes image 200 feature. Dan maak ik een
            % index_vector van size(200,1) met allemaal 1'en (de ID's) van
            % de img voor deze features.
            
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
            save(strcat(i_dir, img_cats{cats}, '_', mode, '.mat'), 'SIFT_OUT_CAT');
        end
    end % loop through all image categories

    % save result to file
    if size(SIFT_OUT,1) > 1 && save_data
        % save(strcat(img_cats{cats}, '_', mode, '.mat'), 'SIFT_OUT');
        save(strcat('features_', mode, '.mat'), 'SIFT_OUT');
    end

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