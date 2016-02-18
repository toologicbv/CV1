function imOut = gaussianConv2d(image_path , sigma , kernel_length)
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
g = gaussian(sigma, kernel_length);
% construct 2D filter by means of an outer product
G = g' * g;
im = im2double(imread(image_path));
imOut = conv2(im, G, 'same');

end % gaussianConv2D