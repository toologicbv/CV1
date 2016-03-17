function featureExtractionv1(root_dir, mode, sampling, colorSIFT, img_cat)
% function that extracts SIFT features from images
%
% Input parameters:
% root_dir: Root directory where images are situated
% mode: 2 possible values "train" or "test", also determines where to look
%       for the input images
% sampling: 3 possible values "point", "dense" or "all"
% colorSIFT: true/false, indicates whether or not to compute the color SIFT
%            decriptors

    % define the image categories
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};

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
        % loop through images
        for i=1:length(ifiles)
            imgFile = strcat(i_dir, ifiles(i).name); 
            Img = imread(imgFile);
            % if we also need to compute colorSIFT descriptors we need to
            % transform the image
            if colorSIFT 

            end
            sift_d = compute_graySIFT_desc(Img, sampling);
            SIFT_OUT = cat(1, SIFT_OUT, sift_d);

        end  % loop through images

    end % loop through all image categories

    % save result to file
    if size(SIFT_OUT,1) > 1
        % save(strcat(img_cats{cats}, '_', mode, '.mat'), 'SIFT_OUT');
        save(strcat('features_', mode, '.mat'), 'SIFT_OUT');
    end

% ======================== END MAIN FUNCTION ===========================

% ========================= SUB FUNCTIONS ==============================
    function sift_d=compute_graySIFT_desc(I1, sample_mode)
        
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
            [~, d2] = vl_dsift(I1);
            sift_d = cat(2, d1, d2);  
        end
        % we need to return the transpose because d is 128 x K
        sift_d = transpose(sift_d);
        
    end  % compute_graySIFT_desc
% ========================= SUB FUNCTIONS ==============================

end % featureExtractionv1