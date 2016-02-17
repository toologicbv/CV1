function [imOut1, imOut2]=cmp_gaus_impl(image_path, sigma)

    im = im2double(imread(image_path));
    G = fspecial ('gaussian', 5, sigma);
    imOut1 = conv2(im,G,'same');
    imOut2 = gaussianConv(image_path, sigma, sigma);

end % cmp_gaus_impl