function imOut = gaussianConv(image_path , sigma_x , sigma_y, kernel_length)
% function that convolves an image with 2D Gaussian
% input parameters:
% (1) image_path: absolute path to image
% (2) sigma_x: standard deviation for x-dimension
% (3) sigma_y: standard deviation for y-dimension
% (4) kernel_length: length of the kernel
% returns:
% imOut: the convolved image

% in this version we first slide the 1D filter over the image
% in the x direction and then in the y direction
GX = gaussian(sigma_x, kernel_length);
GY = gaussian(sigma_y', kernel_length);
im = imread(image_path);
im = im2double(im);
imOut = conv2(im, GX, 'same');
imOut = conv2(imOut, GY, 'same');

end % gaussianConv