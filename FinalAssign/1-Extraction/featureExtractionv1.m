function featureExtractionv1(root_dir, mode, sampling, cspaces, img_cat)
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
%
%
% Output parameters:
% ===================
% returns ONE matrix N x 128 (N is number of features)

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


    % prepare the output matrix for the SIFT descriptors
    SIFT_OUT = [];
    for cats=1:num_cats  % loop through all image categories
        % prepare the input directory based on the "mode" and the "category"
        i_dir = strcat(root_dir, '/', img_cats{cats}, '_', mode, '/');
        % construct search mask
        search_mask = strcat(i_dir, '*.jpg');
        ifiles = dir(search_mask);
        % initialize matrix for this category
        SIFT_OUT_CAT = [];
        % loop through images
        for i=1:length(ifiles)
            % extract image ID
            imgID = str2double(ifiles(i).name(strfind(ifiles(i).name, 'img'), end-4));
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
            t = cat(2, repmat(imgID, size(sift_d, 1), 1), sift_d);
            SIFT_OUT_CAT = cat(1, SIFT_OUT_CAT, t);
                  
        end  % loop through images
        % save results for this category
        if size(SIFT_OUT_CAT,1) > 1
            save(strcat(i_dir, img_cats{cats}, '_', mode, '.mat'), 'SIFT_OUT_CAT');
        end
    end % loop through all image categories

    % save result to file
    if size(SIFT_OUT,1) > 1
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