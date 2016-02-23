function plot_diff_1D_2D_conv(image_path, sigma, kernel_length)
    % Make of a plot of the absolute differences of 2 x 1D
    % and 2D convolution
    % input parameters:
    % (1) image_path: absolute path to image
    % (2) sigma: standard deviation 
    % (3) kernel_length: length of the kernel
    
    % perform two times 1D convolution and one 2D convolution
    imOut1 = gaussianConv(image_path, sigma, sigma, kernel_length);
    imOut2 = gaussianConv2d(image_path, sigma, kernel_length);
    % take the differences and plot the results, take the different bewteen a 2d conv filter and 2 times the 1d filter 
    diff_1d_2d = abs(imOut1 - imOut2);
    [height, width] = size(diff_1d_2d);
    sample_size = 2;
    [X, Y] = meshgrid(1:sample_size:height, width:-sample_size:1);
    Z = diff_1d_2d(1:sample_size:height, 1:sample_size:width);
    figure
    surf(X,Y,Z')
    title('Absolute differences 2 x 1D and 2D convolution');
end