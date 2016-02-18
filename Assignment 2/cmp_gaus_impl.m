function [imOut1, images]=cmp_gaus_impl(image_path, sigma, kernel_length)
% (1) image_path: absolute path to image
% (2) sigma: standard deviation for x and y dimension
% (3) kernel_length: length of the kernel
    im = im2double(imread(image_path));
    G = fspecial ('gaussian', kernel_length, sigma);
    types = {'full'; 'valid'; 'same'};
    images = {};
    for i=1:numel(types)
        images = [images, conv2(im, G, types{i})];
    imOut1 = gaussianConv(image_path, sigma, sigma, kernel_length);

end % cmp_gaus_impl