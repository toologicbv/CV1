function [ C ] = kMeansClustering( features, k )
    % Function that returns k clusters in the dataset 
    %
    % Computervision I / Assignment 4
    % J�rg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % 
    % Input parameters:
    % (1) features: images discriptors where we want to train our knn on
    [C, ~] = vl_kmeans(double(features)', k);
    %k_clusters = kmeans(double(features),k)
end

