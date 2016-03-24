function repImages(root_dir, mode, img_cats, K)
% function that represents images as quantized histograms
% 
% Input parameters:
% ===================
% root_dir: Root directory where images are situated
% mode: 2 possible values "train" or "test", also determines where to look
%       for the input images
% img_cat: {'all'} or array of categories e.g. {'motorbikes', 'cars'}
% K: number of clusters that codebook is using

%
% example invocation
% repImages('S:/Workspace/CV_FINAL/ImageData', 'train', {'faces'}, 200);
%

 
    if strcmp(img_cats{1}, 'all')
       img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};
       num_cats = length(img_cats);
    else
       num_cats = length(img_cats);

    end
    
    % loop through categories we have to process
    
    for cat=1:num_cats
        % made K (number of clusters) a parameter so that the specific
        % file that contains the calculated clusters can be distinguished
        % 
        inputDir = strcat(root_dir, '/', img_cats{cat}, '_', mode, '/');
        in_c_filename = [inputDir, img_cats{cat}, 'Clusters', num2str(K), '.mat'];
        % load calculated clusters from file, they should be in the
        % trainings directory of the specific image category
        clusters = loadMatrixFromFile(in_c_filename);
        % load features from file for this image category
        img_sifts = loadFeaturesFromFile(root_dir, img_cats{cat}, mode);
        % the first column of img_sifts contains the image ID's without any
        % preceding zeros (like in the images img012.jpg). But the matrix
        % contains many feature rows for one image, therefore we need to
        % determine the unique image numbers from the sift matrix.
        [C,~,~] = unique(img_sifts(:,1));
        % initialize new matrix, add one to colums for image ID
        q_hists = zeros(length(C), size(clusters,2)+1);
        length(C)
        for i=1:length(C)
            % select the features that belong to this (i) specific image
            img_features = img_sifts(img_sifts(:,1) == C(i),:);
            % omit the first column because it's the image ID
            img_features = img_features(:, 2:end); 
            % quantize the features with the codebook loaded earlier
            hist = transpose(quantizeFeatures(img_features, clusters));
            % store result of quantized features
            % concatenate with image ID (img_sifts(i,1))
            q_hists(i,1) = C(i);
            q_hists(i,2:end) = hist;
            
        end
        % save the visual words for the images from this category. The file
        % will be saved in the current working directory
        out_filename = [ img_cats{cat}, '_', 'vwords', num2str(K), '.mat' ];
        save (out_filename, 'q_hists');
        
    end


% ======================== END MAIN FUNCTION ===========================

% ========================= SUB FUNCTIONS ==============================
    function img_sifts=loadFeaturesFromFile(root_dir, img_cat, mode)
        
        i_dir = strcat(root_dir, '/', img_cat, '_', mode, '/');
        % construct search mask
        filename = strcat(i_dir,  img_cat, '_', mode, '.mat');
        % we always assume that the loaded file only contains ONE variable
        foo = load(filename);
        variables = fieldnames(foo);
        img_sifts = foo.(variables{1});
        
    end % loadFeaturesFromFile


end % repImages