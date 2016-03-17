function [ hist ] = quantize_features( features, clusters)
    % Function that returns a histogram vector for features vector of a input images  
    %
    % Computervision I / Assignment 4
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % 
    % Input parameters:
    % (1) features: images discriptors where we want a histrogram of
    hist = zeros(size(clusters,1),1);
    for i=1:size(features,2)
        distance = PDIST2(clusters , features(i,:));
        index_min_distance = find(distance, min(distance));
        hist(index_min_distance) = hist(index_min_distance) + 1;
    end 
end
