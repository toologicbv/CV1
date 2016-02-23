function comp_fspecials(image_path, sigma, kernel_length)
% (1) image_path: absolute path to image
% (2) sigma: standard deviation for x and y dimension
% (3) kernel_length: length of the kernel
    im = im2double(imread(image_path));
    G = fspecial ('gaussian', kernel_length, sigma);
    types = {'full'; 'valid'; 'same'};
    figure
    subplot(3, 2, 1);
    imshow(im);
    title('original');
    for i=1:numel(types)
        subplot(3, 2, i+1);
        im_c = conv2(im, G, types{i});
        imshow(im_c);
        title(types{i});
     
end % cmp_gaus_impl