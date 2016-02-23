function [imOut, Gd]=gaussianDer(image_path, kernel_length, sigma)
% implementation of first order Gaussian derivative
% applied to an image
% input parameters:
% (1) image_path: absolute path to image
% (2) kernel_length: the length of the kernel
% (3) sigma: standard deviation
% returns:
% (1) imOut: the convoluted image with highlighted edges
% (2) Gd: the first order derivative of the Gaussian
% NOTE:
% we deliberately changed the function parameters (in comparison
% to what was described in the assignment.
% It made more sense for us not to pass the G parameter
% because the function should also take the sigma paramter,
% and so in principle one could pass a different sigma
% than the one that was used for G.

min_range = -kernel_length/2.;
max_range = kernel_length/2.;
x = linspace(min_range, max_range, kernel_length);
% construct the 1D filter
G = gaussian(sigma, kernel_length); 
% calculate the first order Gaussian derivative
Gd = -(x ./ sigma^2) .* G;
% load the image and convert to double
imIn = im2double(imread(image_path));
[~, ~, ch] = size(imIn);
% if the image does not contain color information use conv2
% other wise use convn function
if ch == 1
    imOut = conv2(imIn, Gd);
else
    imOut = convn(imIn, Gd);
end

end % gaussianDer