function [ C, A ] = kMeansClustering( features, k )
    % Function that returns k clusters in the dataset 
    %
    % Computervision I / Final Project
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % 
    % Input parameters:
    % (1) features: images discriptors where we want to train our knn on
    [C, A] = vl_kmeans(double(features)', k);
end

