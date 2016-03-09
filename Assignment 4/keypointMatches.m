function [f1, f2, d1, d2, T]=keypointMatches(img_path1, img_path2)
% Finds keypoint matchings between two input images based on Loewe SIFT
% implementation of Andrea Vidaldi
%
% Computervision I / Assignment 4
% Jörg Sander / 10881530
% Maurits Bleeker / 
% 
% **** NOTE *****
% we are using vlfeat-0.9.20 package
% 
% Input parameters:
% (1) img_path1: absolute file path to image 1
% (2) img_path2: absolute file path to image 2

% load images
I1 = imread(img_path1) ;
I2 = imread(img_path2) ;

% if necessary convert ot grayscale
if size(I1,3) > 1
    I1 = single(rgb2gray(I1));
    I2 = single(rgb2gray(I2));
else
    I1 = single(I1);
    I2 = single(I2);
end
% compute sift descriptors with Andrea Vidaldi Loewe implementation for
% both images
[f1, d1] = vl_sift(I1);
[f2, d2] = vl_sift(I2);
% find matches between the descriptors
[T, ~] = vl_ubcmatch(d1, d2);

end % keypointMatches