function [ H, r, c, Ix, Iy] = HarrisCorners(image_path, sigma)
% Function that detects corners based on Harris Corner
% detector
% input parameters:
% (1) image_path: path to the image
% 
% output parameters:
% (1) H: matrix of second order derivatives
% (2) r: row numbers of the detected corners
% (3) c: column numbers of the detected corners

    % set "empirical" constant k
    k = 0.04;
    % window size for non-max suppression
    % NOTE, window size must be an ODD number
    n = 11;
    % threshold for non-max supression
    max_threshold = -2000;
    % determine kernel length based on sigma
    % http://stackoverflow.com/questions/23832852/by-which-measures-should-i-set-the-size-of-my-gaussian-filter-in-matlab
    kernel_length = floor(6*sigma) + 1;
    % load original image
    im_in_org = im2double(imread(image_path));
    [y_size, x_size, channels] = size(im_in_org);
    % if image is not in grayscale, convert from (assumed) RGB to grayscale
    if channels > 1
        im_in = rgb2gray(im_in_org);
    else
        im_in = im_in_org;
    end
    % create 1D kernel
    G = fspecial('gaussian', [1 kernel_length], sigma);
    % compute first order derivative by means of convolution
    % in x-direction with the Gaussian derivative filter
    % WHICH CONV2 shape type should we use? SAME?
    [Ix, Gd] = gaussianDer(im_in, G, sigma);
    [Iy, Gd] = gaussianDer(im_in, G', sigma);
    % compute Ix^2: first square and then smooth again with G in x-direction
    nIx = rescale_image(Ix);
    nIy = rescale_image(Iy);
    
    A = Ix.^2;
    C = Iy.^2;
    B = Ix .* Iy; 
    nA = rescale_image(A) .* 255;
    nB = rescale_image(B) .* 255;
    nC = rescale_image(C) .* 255;
    
    H = ((nA .* nC) - nB.^2) - ( k .* (nA + nC).^2);
    % non-maximum suppression
    [corners, c, r] = get_corners(H, n, max_threshold);
    
    % nIx = rescale_image(Ix);
    % nIy = rescale_image(Iy);
    plot_derivative_images(im_in_org, Ix, Iy, r, c);
    
    function imout=rescale_image(im_in)
        
        im_min = min(im_in(:));
        im_max = max(im_in(:));
        imout = (im_in + abs(im_min)) ./ (im_max + abs(im_min));
    end
    
    function [corners, c, r]=get_corners(H, n, threshold)
        
        r = []; c = [];
        half =  (n-1)/2;
        modified_H = padarray(H, [half half]);
        corners = zeros(size(H,1), size(H,2));
        % construct utility vectors in range 1 to n
        x = (1:n);
        y = (1:n);
        
        for i = half:size(H,1)
            for j = half:size(H,2)
               value = H(i,j);
               w = modified_H((x + i - half),(y + j - half));
               max_value = max(w(:));
               if value == max_value && value >= threshold
                    corners(i,j) = value;
                    r = [r, i];
                    c = [c, j];   
               else
                   corners(i,j) = 0; 
               end
            end 
        end
    end 
    
    function plot_derivative_images(i1, i2, i3, r, c)
        
        figure
        
        subplot(2,2,2);
        %i2 = im2bw(i2, threshold);
        imshow(i2);
        title('Ix derivative');
        subplot(2,2,3);
        %i3 = im2bw(i3, threshold);
        imshow(i3);
        title('Iy derivative');
        subplot(2,2,1);
        imshow(i1);
        hold on;
        % it is odd but we have to change rows and columns, seems like
        % the plot uses reversed axis, checked our corners procedure
        % and my observation is that it works fine
        plot(c, r, 'ro')
        title('original');
        
    end % plot_derivative_images

end

