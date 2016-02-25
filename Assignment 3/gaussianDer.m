function [imOut, Gd]=gaussianDer(imIn ,G, sigma)
% implementation of first order Gaussian derivative
% applied to an image
% input parameters:
% (1) imIn: image in grayscale
% (2) G: 1D gaussian filter
% (3) sigma: standard deviation
% returns:
% (1) imOut: convolved image with Gaussian derivative
% (2) Gd: Gaussian derivative

[y_size, x_size] = size(G);
% if we need to take derivative in the y-direction
% we also need to transpose the x-vector that we
% construct below
y_direction = false;
% assuming 1D kernel
if y_size == 1
    kernel_length = x_size; 
else
    % derivative in y-direction
    y_direction = true;
    kernel_length = y_size;
end
min_range = -(kernel_length - 1)/2.;
max_range = (kernel_length - 1)/2.;
x = linspace(min_range, max_range, kernel_length);
if y_direction
    % as mentioned above, transpose x-vector
    x = x';
end
Gd = -(x ./ sigma^2) .* G;

% if the image does not contain color information use conv2
% other wise use convn function
imOut = conv2(imIn, Gd, 'same');

end % gaussianDer