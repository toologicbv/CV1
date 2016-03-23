function computeCodebook(in_filename, out_filename, K)
    % computes the K-means clusters for specific matrix of features that is
    % passed as "input file". 
    % Saves the cluster to specified output filename
    % 
    % example invocation
    % 
    % computeCodebook('S:/Workspace/CV_FINAL/features_train.mat', 'carClusters200.mat', 200);
    features = loadMatrixFromFile(in_filename);
    clusters = kMeansClustering(features, K);
    save(out_filename, 'clusters');

end % computeCatClusters