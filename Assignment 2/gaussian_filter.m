function  gaussian_filter(image, kernelLength, sigma)
% input parameters:
% (1) image name
% (2) lenght of the kernel one wants to use for filtering the images
% (3) sigma for the gaussian


% load the image and convert values to doubles
IM = im2double(imread(image));

x = linspace(-kernelLength / 2, kernelLength / 2, kernelLength);
gaussFilter = (1 / (sigma * sqrt(2*pi))) * exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter) % normalize
im_out=imfilter(IM,gaussFilter);
imshow(im_out);

subplot(2,1,1), imshow(im_out)
title(['filtered Images with a gaussian filter']);
subplot(2,1,2), imshow(IM)
title(['Original images']);

end

