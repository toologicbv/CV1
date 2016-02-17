function imOut = gaussianConv(image_path , sigma_x , sigma_y)
% function that convolves an image with 2D Gaussian
% input parameters:
% (1) image_path: absolute path to image
% (2) sigma_x: standard deviation for x-dimension
% (3) sigma_y: standard deviation for y-dimension
% returns:
% imOut: the convolved image

GX = gaussian(sigma_x);
GY = gaussian(sigma_y');
im = imread(image_path);
im = im2double(im);
imOut = conv2(im, GX);
imOut = conv2(imOut, GY);

end % gaussianConv