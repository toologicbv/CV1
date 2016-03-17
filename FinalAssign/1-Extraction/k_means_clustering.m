function [ k_clusters ] = k_means_clustering( features, k )
    % Function that returns k clusters in the dataset 
    %
    % Computervision I / Assignment 4
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % 
    % Input parameters:
    % (1) features: images discriptors where we want to train our knn on
    [C, A] = VL_KMEANS(double(features)', k) 
    %k_clusters = kmeans(double(features),k)
end

