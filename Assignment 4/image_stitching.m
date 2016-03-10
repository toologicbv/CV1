function [ output_args ] = image_stitching( img_path1, img_path2 )
    % Implementation of a image stichting alogirtme 
    %
    % Computervision I / Assignment 4
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % **** NOTE *****
    % we are using vlfeat-0.9.20 package
    % 
    % Input parameters:
    % (1) img_path1: absolute file path to image 1
    % (2) img_path2: absolute file path to image 2

    % load images
    I1_255 = imread(img_path1);
    I2_255 = imread(img_path2);

    % if necessary convert ot grayscale
    if size(I1_255,3) > 1
        I1 = im2single(rgb2gray(I1_255));
        I2 = im2single(rgb2gray(I2_255));
    else
        I1 = im2single(I1_255);
        I2 = im2single(I2_255);
    end

    N = 200;
    %tform = RANSACv1(img_path1, img_path2, N, true)
    tform = [0.9878,   -0.0881, -204.9841;
             0.0880,    0.9960,  -55.9973;
             0,         0,    1.0000];
    tform(1:2,1:2) = tform(1:2,1:2)';
    
    x =  round(abs(tform(1,3)),0);
    round(abs(tform(2,3)),0)
    y =  round(abs(tform(2,3)),0) - 41;
    
    
    tform = affine2d(tform');
    size(I2)
    I2 = imwarp(I2,tform);
    size(I2)
    
    x_length= max(round(x,0) + size(I1,1), size(I1,1));

    y_length = max(round(y,0) + size(I1,2), size(I1,2));

    % Create new image
    newimage = zeros(x_length, y_length);
    newimage(y:size(I2,1)-1+y, x:size(I2,2)-1+x) = I2;
    newimage(1:size(I1,1), 1:size(I1,2)) = I1;
    
    figure, imshow(newimage);   
end