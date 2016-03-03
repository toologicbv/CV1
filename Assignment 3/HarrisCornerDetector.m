function [ H, r, c] = HarrisCornerDetector(image_path, sigma, w_size)
% Function that detects corners based on Harris Corner
% detector
% input parameters:
% (1) image_path: path to the image
% (2) sigma: standard deviation
% (3) w_size: size of the sliding window (must be an odd number)
% output parameters:
% (1) H: matrix of second order derivatives
% (2) r: row numbers of the detected corners
% (3) c: column numbers of the detected corners

    % set constant k (somewhere between 0.04-0.06)
    k = 0.04;
    % window size for non-max suppression
    % NOTE, window size must be an ODD number
    % tested with n = 15
    % threshold for non-max supression
    % with smaller window size effect is that more edges on playmobile
    % figure are found
    % results (1) playmobil figure with telephone
    % ===============================================
    % e.g. sigma = 1.4 threshold = 3.5 w_size 17 <<<=== best results so
    % far
    % e.g. sigma = 1.6 threshold = 4 w_size 35/55
    % e.g. sigma = 2.5 threshold = 3500-5000 w_szie 55
    % e.g. sigma = 1.8 threshold = 1000 w_szie 55
    max_threshold = 3.5;
    % results (2) ping pong figure with ball
    % e.g. sigma = 1.4 threshold = 3.5 w_size 17 <<<=== best results so far
    
    
    % determine kernel length based on sigma
    % http://stackoverflow.com/questions/23832852/by-which-measures-should-i-set-the-size-of-my-gaussian-filter-in-matlab
    half_k_length = floor(3*sigma) + 1;
    
    % load original image
    im_in_org = im2double(imread(image_path));
    [y_size, x_size, channels] = size(im_in_org);
    % if image is not in grayscale, convert from (assumed) RGB to grayscale
    if channels > 1
        im_in = rgb2gray(im_in_org);
    else
        im_in = im_in_org;
    end
    [x, y] = meshgrid(-half_k_length:half_k_length, -half_k_length:half_k_length);

    % smoothing filter in x and y direction
    Gxy = exp(-(x.^2 + y.^2) / (2 * sigma^2));
    % gaussian first derivative in resp. x and y-direction
    % deliberately ommited the normalizing factor
    Gx = -x .* exp(-(x.^2 + y.^2) / (2 * sigma^2));
    Gy = -y .* exp(-(x.^2 + y.^2) / (2 * sigma^2));
    
    Ix = conv2(im_in, Gx, 'same');
    Iy = conv2(im_in, Gy, 'same');
    % rescale the x and y derivatives in order to display the
    % edges properly
    nIx = rescale_image(Ix);
    nIy = rescale_image(Iy);
    
    % compute the ingredients of the auto-correlation matrices
    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Ixy = Ix .* Iy; 
    
    % convolve again in x and y direction (summing up 
    Ix2 = conv2(Ix2, Gxy, 'same');
    Iy2 = conv2(Iy2, Gxy, 'same');
    Ixy = conv2(Ixy, Gxy, 'same');

    % compute "cornerness" of each pixel
    H = ((Ix2 .* Iy2) - Ixy.^2) - ( k .* (Ix2 + Iy2).^2);
    
    % calculate the gradient, can be used to check which edges
    % are highlighted
    IG = sqrt(Ix2 + Iy2);
    IG = rescale_image(IG);
    % non-maximum suppression
    [corners, c, r] = getLocalMaxima(H, w_size, max_threshold);

    plot_derivative_images(im_in_org, nIx, nIy, IG, r, c);
    
    function imout=rescale_image(im_in)
        
        im_min = min(im_in(:));
        im_max = max(im_in(:));
        imout = (im_in + abs(im_min)) ./ (im_max + abs(im_min));
    end
   

    function [corners, c, r]=getLocalMaxima(H, w_size, threshold)
        % finds the local maxima of a patch and uses 
        % non-maximal supression to find the corner points
        % input:
        % (1) matrix H with the "Harris" reponses
        % (2) patch size (assume quadratic)
        % (3) threshold for non maximal supression
        % returns
        % (1) image matrix after non maximal supression (not really necessary)
        % (2) column coordinate value
        % (3) row coordinate value
        r = []; c = [];
        half =  (w_size - 1)/2;
        % pad the Harris reponse matrix and initialize the corner matrix
        modified_H = padarray(H, [half half]);
        corners = zeros(size(H,1), size(H,2));
        % construct utility vectors in range 1 to n
        xx = (1:w_size);
        yy = (1:w_size);
        
        for i = half:size(H,1)
            for j = half:size(H,2)
               value = H(i,j);
               w = modified_H((xx + i - half),(yy + j - half));
               max_value = max(w(:));
               % non-maximal supression
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
    
    function plot_derivative_images(i1, i2, i3, i4, r, c)
        
        figure 
        subplot(2,2,3);
        imshow(i2);
        title('Ix derivative');
        subplot(2,2,4);
        imshow(i3);
        title('Iy derivative');
        subplot(2,2,2);
        imshow(i4);
        title('gradient');
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

