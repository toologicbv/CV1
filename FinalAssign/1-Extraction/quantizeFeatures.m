function [ hist_matrix ] = quantizeFeatures (SIFT_OUT,IMAGES_INDEX,amount_of_images, C)
    % Function that returns a histogram matrix for every images in a specific image category   
    %
    % Computervision I / Final Assignment
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % 
    % Input parameters:
    % (1) SIFT_OUT: images discriptors where we want a histrogram of
    % (2) IMAGES_INDEX: center point of each cluster of the visual vocabulary
    % (3) amount_of_images: images discriptors where we want a histrogram of
    % (4) C: center point of each cluster of the codebook
    
    % first we computes for every vector in SIFT_OUT the index
    % closest centroid. The resulting matrix can be used to construct the
    % histogram for each image, i.e. the histogram of visual words that
    % characterizes a specific image
    clust_idxs_train = dsearchn(C', double(SIFT_OUT));
    hist_matrix = [];
    
    for i=1:amount_of_images
        % find the indexes of the features of this image in the
        % IMAGES_INDEX matrix
        feature_idx = find(IMAGES_INDEX == i);
        % use this indexes to get the features of this images and ma
        [hist_vector, ~] = hist(clust_idxs_train(feature_idx), linspace(1,size(C,2),size(C,2)));
        hist_vector = hist_vector ./ sum(feature_idx);
        hist_matrix =  cat(1,hist_matrix, hist_vector);
    end 
end
