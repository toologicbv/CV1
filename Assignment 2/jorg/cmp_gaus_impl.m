function [imOut1]=cmp_gaus_impl(image_path, sigma, kernel_length)
% (1) image_path: absolute path to image
% (2) sigma: standard deviation for x and y dimension
% (3) kernel_length: length of the kernel
    im = im2double(imread(image_path));
    G = fspecial ('gaussian', kernel_length, sigma);
    types = {'full'; 'valid'; 'same'};
    figure
    for i=1:numel(types)
        subplot(2, 3, i);
        imshow(conv2(im, G, types{i}));
        title(types{i});
    imOut1 = gaussianConv(image_path, sigma, sigma, kernel_length);
    subplot(2, 3, i+1);
    imshow(imOut1)
    title('2x1D conv2');
    imOut2 = gaussianConv2d(image_path, sigma, kernel_length);
    subplot(2, 3, i+2);
    imshow(imOut2)
    title('2D conv2');
    diff_1d_2d = abs(imOut1 - imOut2);
    [height, width] = size(diff_1d_2d);
    sample_size = 2;
    [X, Y] = meshgrid(1:sample_size:height, width:-sample_size:1);
    
    Z = diff_1d_2d(1:sample_size:height, 1:sample_size:width);
    %surf(X,Y,Z')

end % cmp_gaus_impl