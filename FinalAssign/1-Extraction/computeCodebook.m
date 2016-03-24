function computeCodebook(root_dir, mode, K, img_cats)
    % computes the K-means clusters for specific matrix of features that is
    % passed as "input file". 
    % Saves the cluster to specified output filename
    % 
    % example invocation
    % 
    % computeCodebook('S:/Workspace/CV_FINAL/ImageData', 'train', 20, {'cars', 'airplanes'})
    % computeCodebook('S:/Workspace/CV_FINAL/ImageData', 'train', 400, {'all'})
    
    img_cats = {'airplanes', 'cars', 'faces', 'motorbikes'};
    
    if strcmp(img_cats{1}, 'all')
    else
        img_cats = img_cats;
    end
    
    for i=1:length(img_cats)
        i_dir = strcat(root_dir, '/', img_cats{i}, '_', mode, '/');
        in_filename = [ i_dir, img_cats{i}, '_', mode, '.mat'];
        features = loadMatrixFromFile(in_filename);
        features = features(:, 2:end);
        clusters = kMeansClustering(features, K);
        out_filename = [ i_dir, img_cats{i}, 'Clusters', num2str(K), '.mat'];
        save(out_filename, 'clusters');
    end
    
end % computeCatClusters