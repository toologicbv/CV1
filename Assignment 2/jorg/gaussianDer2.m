function imOut=gaussianDer(image_path, kernel_length, sigma)
% implementation of first order Gaussian derivative
% applied to an image
% input parameters:
% (1) image_path: absolute path to image
% (2) G: 1D gaussian filter
% (3) sigma: standard deviation
% returns:
% (1) imOut:
% (2) Gd:

min_range = -kernel_length/2.;
max_range = kernel_length/2.;
x = linspace(min_range, max_range, kernel_length);
G = gaussian(sigma, kernel_length); 
Gd = -(x ./ sigma^2) .* G;
imIn = im2double(imread(image_path));
[~, ~, ch] = size(imIn);
if ch == 1
    imOut = conv2(imIn, Gd);
else
    imOut = convn(imIn, Gd);
end
imOut = im2bw(imOut, 0.01);

end % gaussianDer