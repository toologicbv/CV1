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
    
    % size in the x and y direction of the original images 
    x_org = size(I2, 2)
    y_org = size(I2, 1);
    
    % find transformation between image one and two
    N = 400;
    tform = RANSACv1(img_path1, img_path2, N, false)
    
    % matrix [m1,m2;m3,m4] needs to be transposed
    tform(1:2,1:2) = tform(1:2,1:2)';
    
    x =  round(abs(tform(1,3)),0);
    y =  (round(abs(tform(2,3)),0) /2) - 1 ;
    
    tform = affine2d(tform');
    I2 = imwarp(I2,tform);
    
    %size of the transformed second images
    y_transformed = size(I2, 1);
    x_transformed = size(I2, 2);
    
     
    % diff_y is the extra padding that is added by rotating the images in the y direction
    diff_y = ((y_transformed - y_org) / 2);
    y = y - diff_y;
    
    % for the x lenght of the new images, add the two input images and subtract
    % the momevent in the x direction and subtrackt the new padding of images 2
    
    x_length = size(I1,1) + size(I2,1) - x - (x_transformed - x_org);
    y_length = max(round(y,0) + size(I1,2), size(I1,2));

    % Create new image
    
    newimage = zeros(y_length, x_length);
    newimage(y:(size(I2,1))-1+y, x:size(I2,2)-1 +x) = I2;
    newimage(1:size(I1,1), 1:size(I1,2)) = I1;
    
    figure, imshow(newimage);   
end
