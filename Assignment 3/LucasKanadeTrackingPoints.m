function [new_r, new_c]=LucasKanadeTrackingPoints(img_1, img_2, r, c, window_size)
% function that computes optical flow vectors for an array of corner points
% (detected by Harris-Detector).
% input parameters:
% (1 + 2) images one and two
% (3 + 4) coordinates of corner points
% (5) window size of patch. NOTE: we're assuming an odd window size
% r: vector of row indices
% c: vector of column indices
% returns: 
% (1) new_r: row indices after displacement
% (2) new_c: colum indices after displacement

    % compute total number of pixels in patch
    num_pixels = window_size^2;
    % Compute Ix (x direction derivitive), Iy (y direction derivitive) and
    % It
    % For this function there are two options using IntensityDerivs or
    % GaussianDerivs, IntensityDerivs are used because they give much
    % better results. The other option is still available
    [Ix, Iy, It] = computeIntensityDerivs(img_1, img_2);
   
    %Other option GausDerivatives in comments 
    %[Ix, Iy, It]=computeWithGausDerivatives(img_1, img_2, 1);
    % initialize matrices for the result of the displacements
    % Ignore corner points that are to close to image borders
    half_w_size = floor( (window_size - 1) / 2);
    indexes = find( r <= (size(Iy, 1) - half_w_size) & r > half_w_size & ...
        c <= (size(Ix, 2) -  half_w_size) & c > half_w_size );
    r = r(indexes);
    c = c(indexes);
    
    % first build patch window around corner point
    % then compute approximated displacement vector for corner point
    new_r = zeros(1, length(indexes));
    new_c = zeros(1, length(indexes));
    for i=1:length(indexes)
        % compute the patch offsets w.r.t the corner point

        r_min = r(i) - half_w_size;
        r_max = r(i) + half_w_size;
        c_min = c(i) - half_w_size;
        c_max = c(i) + half_w_size;
        % construct the building blocks of A matrix and b
        Ix_block = Ix(r_min:r_max, c_min:c_max);
        Iy_block = Iy(r_min:r_max, c_min:c_max);
        It_block = It(r_min:r_max, c_min:c_max);
        Ix_block = Ix_block(:);
        Iy_block = Iy_block(:);
        It_block = It_block(:);
        A = [Ix_block Iy_block];

        b =  -It_block;
        V = pinv(A) * b;
        % compute the new coordinates of the corner points
        new_r(i) = r(i) + round(V(1), 0);
        new_c(i) = c(i) + round(V(2), 0);
    end

    function [Ix, Iy, It]=computeWithGausDerivatives(im1, im2, sigma)
       
        k_length = floor((6 * sigma) + 1);
        G = fspecial('gaussian', [1 k_length], sigma);
        [~, Gd]=gaussianDer(im1 ,G, sigma);
        Ix = conv2(im1, Gd, 'valid');
        Iy = conv2(im1, Gd', 'valid');
        It = imabsdiff(im2, im1);
    end
    function [I_x, I_y, I_t]=computeIntensityDerivs(im1, im2)
        % computes the intensity derivatives I(x+deltax, y+deltay,
        % t+deltat)
        % input parameters:
        % image 1 and 2
        % returns: the three derivatives
        
        % setup our derivative filters, we use backward filter
        ft_x =  [-1 1; -1 1];
        ft_y =  [-1 -1; 1 1];
        ft_t =  [ 1  1; 1 1];
        ctype = 'valid';
        
        I_x = conv2(im1, ft_x, ctype); 
        I_y = conv2(im1, ft_y, ctype);
        I_t = conv2(im1, ft_t, ctype) + conv2(im2, -ft_t, ctype);
    end % computeIntensityDerivs

end % LucasKanadeTrackingPoints



