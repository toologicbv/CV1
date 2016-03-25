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
    
    % function that culculate for every vector in SIFT_OUT the index
    % closest centroid 
    
    % clust_idxs_train is een vector, voor ieddere feature bij welk center
    % point deze feature hoort, bv 1 200, 20 etc. Deze kunnen we tellen
    % voor de histrogram
    clust_idxs_train = dsearchn(C', double(SIFT_OUT));
    hist_matrix = [];
    
    
    
    % NOTE AAN JORG: Ik ben er vrij zeker van dat dit proces goed gaat,
    % maar zou je dit nog even kunnen checken, miss zie ik iets over het
    % hoofd? Miss gaat dat met linspace(1,size(C,2),size(C,2) nog niet
    % helemaal goed
    
    for i=1:amount_of_images
        % find the indexes of the features of this image in the
        % IMAGES_INDEX matrix
        feature_idx = find(IMAGES_INDEX == i);
        counter = counter + length(feature_idx); 
        % use this indexes to get the features of this images and ma
        [hist_vector, ~] = hist(clust_idxs_train(feature_idx), linspace(1,size(C,2),size(C,2)));
        hist_vector = hist_vector ./ sum(feature_idx);
        hist_matrix =  cat(1,hist_matrix, hist_vector);
    end 
end
