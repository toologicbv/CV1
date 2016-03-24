function [ hist_matrix ] = quantizeFeatures (SIFT_OUT,IMAGES_INDEX,amount_of_images, C)
    % Function that returns a histogram matrix for every images of a whole class   
    %
    % Computervision I / Assignment 4
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % 
    % Input parameters:
    % (1) SIFT_OUT: images discriptors where we want a histrogram of
    % (2) IMAGES_INDEX: center point of each cluster of the visual vocabulary
    % (3) amount_of_images: images discriptors where we want a histrogram of
    % (4) C: center point of each cluster of the visual vocabulary 
    
    clust_idxs_train = dsearchn(C', double(SIFT_OUT));
    hist_matrix = [];
    
    for i=1:amount_of_images
        feature_idx = find(IMAGES_INDEX == i);
        [hist_vector, ~] = hist(clust_idxs_train(feature_idx), linspace(1,size(C,2),size(C,2)));
        hist_vector = hist_vector ./ sum(feature_idx);
        hist_matrix =  cat(1,hist_matrix, hist_vector);
    end 
    
end
