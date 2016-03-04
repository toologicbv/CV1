function [u,v]=LucasKanadeAlgorithm( img_1_path, img_2_path)
    % Function that calculate optical flow for two imput images 
    % detector
    % input parameters:
    % (1) img_1_path: path to image 1
    % (2) img_2_path: path to image 2
    % (3) sigma: sigma of the gaussian to use for convolution
    

    % convert images to double values
    if isa(img_1_path, 'char')
        img_1 = im2double(imread(img_1_path));
        img_2 = im2double(imread(img_2_path));
    else
        img_1 = im2double(img_1_path);
        img_2 = im2double(img_2_path);
    end
   
    % check if both images have the same dimentions
    if (size(img_1,1) ~= size(img_2,1)) | (size(img_1,2) ~= size(img_2,2))
        error('input is not the same');
    end;
    if (size(img_1,3) ~= 1) || (size(img_2,3) ~= 1)
        % proces works only for gray scale, bring back to grey scale if the
        % images is in RGB (or other format)
        img_1 = rgb2gray(img_1);
        img_2 = rgb2gray(img_2);
    end;
    % get the size of the original image
    [y_size, x_size] = size(img_1);
    % window size for this function is 15
    w_size = 15;
    % calculate the offset to find the midpoint of the patch windows
    w_off = floor( (w_size - 1) / 2);
    % Compute Ix (x direction derivitive), Iy (y direction derivitive) and
    % It
    % [Ix, Iy, It] = computeIntensityDerivs(img_1, img_2);
    %[Ix, Iy, It] = computeIntensityDerivs(img_1, img_2);
    [Ix, Iy, It]=computeWithGausDerivatives(img_1, img_2, 1);
    % initialize matrices for the result of the displacements
    
    [X, Y] = meshgrid(w_off+1:w_size:size(Ix,2)-w_off, w_off+1:w_size:size(Ix,1)-w_off);
    u = zeros(size(X));
    v = zeros(size(Y));
    % starting with offset + 1 until size x-dim minus offset
    x = 0; y = 0;
    for i = w_off+1:w_size:size(Ix,1)-w_off
        x = x + 1;
        for j = w_off+1:w_size:size(Ix,2)-w_off
            y = y + 1;
            Ix_b = Ix(i-w_off:i+w_off, j-w_off:j+w_off);
            Iy_b = Iy(i-w_off:i+w_off, j-w_off:j+w_off);
            It_b = It(i-w_off:i+w_off, j-w_off:j+w_off);
            % disp([num2str(i), '/', num2str(j)])
            Ix_b = Ix_b(:);
            Iy_b = Iy_b(:);
            b = -It_b(:); % make a column-v of b block
            A = [Ix_b Iy_b]; % make matrix with two column vectors
            V = pinv(A)*b; % get pixel displacement
            % store results
            u(x,y)=V(1);
            v(x,y)=V(2);
        end
        y = 0;
    end
   
    figure
    if isa(img_1_path, 'char')
        imshow(img_2);
    else
        imshow(img_2_path);
    end
    hold on;
    quiver(X, Y, u, v, 'y')    

    function [Ix, Iy, It]= computeWithGausDerivatives(im1, im2, sigma)
       
        k_length = floor((6 * sigma) + 1);
        G = fspecial('gaussian', [1 k_length], sigma);
        [~, Gd]=gaussianDer(im1 ,G, sigma);
        Ix = conv2(im1, Gd, 'same');
        Iy = conv2(im1, Gd', 'same');
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
end

