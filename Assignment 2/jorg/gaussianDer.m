function [imOut, Gd]=gaussianDer(image_path ,G, sigma)
% implementation of first order Gaussian derivative
% applied to an image
% input parameters:
% (1) image_path: absolute path to image
% (2) G: 1D gaussian filter
% (3) sigma: standard deviation
% returns:
% (1) imOut:
% (2) Gd:

[~, kernel_length] = size(G);
min_range = -(kernel_length - 1)/2.;
max_range = (kernel_length - 1)/2.;
x = linspace(min_range, max_range, kernel_length);
Gd = -(x ./ sigma^2) .* G;
imIn = im2double(imread(image_path));
imOut = conv2(imIn, Gd);

end % gaussianDer