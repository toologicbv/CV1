function [ hist ] = quantizeFeatures( features, clusters)
    % Function that returns a histogram vector for features vector of a input images  
    %
    % Computervision I / Assignment 4
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % 
    % Input parameters:
    % (1) features: images discriptors where we want a histrogram of
    % (2) clusters: center point of each cluster of the visual vocabulary 
    hist = zeros(size(clusters',1),1);
    for i=1:size(features,1)
        distance = pdist2(clusters' , double(features(i,:)));
        index_min_distance = find(distance == min(distance));
        hist(index_min_distance) = hist(index_min_distance) + 1;
        % normalise histogram vector bij sum of features
        hist = hist ./ size(features,1);
    end 
end
