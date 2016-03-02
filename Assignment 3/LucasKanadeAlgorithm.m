function LucasKanadeAlgorithm( img_1_path, img_2_path)
    % Function that calculate optical flow for two imput images 
    % detector
    % input parameters:
    % (1) img_1_path: path to image 1
    % (2) img_2_path: path to image 2
    % (3) sigma: sigma of the gaussian to use for convolution
    

    % convert images to double values
    img_1 = im2double(imread(img_1_path));
    img_2 = im2double(imread(img_2_path));
   
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
    
    % window size for this function is 15
    window_size = 15;
    
    [Ix, Iy, It] = computeIntensityDerivs(img_1, img_2);

    % resize the images so that it fits exactly n times the window size
    Ix = Ix(1:(floor(size(img_1, 1) / window_size)* window_size) , 1:(floor(size(img_1, 2) / window_size)*window_size));
    Iy = Iy(1:(floor(size(img_1, 1) / window_size)* window_size) , 1:(floor(size(img_1, 2) / window_size)*window_size));
    It = It(1:(floor(size(img_1, 1) / window_size)* window_size) , 1:(floor(size(img_1, 2) / window_size)*window_size));

    % number of times the window fits in the x and y direction of the
    % images (for this example 8 times 8 *15 = 120 )
    x_blocks = floor(size(img_1, 1) / window_size);
    y_blocks = floor(size(img_1, 2) / window_size);
    
    x_block_length(1:x_blocks) = window_size;
    y_block_length(1:y_blocks) = window_size;
    
    % object with cells of window_size * window_size
    Ix_blocks = mat2cell(Ix, x_block_length,y_block_length);
	Iy_blocks = mat2cell(Iy, x_block_length,y_block_length);
    It_blocks = mat2cell(It, x_block_length,y_block_length);
    
    
    V = zeros((x_blocks * y_blocks), 4);
    index = 1;
    for i=1:x_blocks
        for j =1:y_blocks
            % select the values for every block
            Ix_block = Ix_blocks{i,j};
            Iy_block = Iy_blocks{i,j};
            It_block = It_blocks{i,j};
            
            V_block = calculate_v(Ix_block,Iy_block,It_block);
            V(index,:) = [i j V_block(1) V_block(1)];
            index = index + 1;
        end 
    end 
    
    figure
    quiver(V(:,1),V(:,2), V(:,3), V(:,4));
    axis off;
    function V = calculate_v(Ix_block, Iy_block, It_block)
        % calculate V = [u v] for a given window
        Ix_block = reshape(Ix_block, (size(Ix_block, 1)*size(Ix_block, 2)),1);
        Iy_block = reshape(Iy_block, (size(Iy_block, 1)*size(Iy_block, 2)),1);
        It_block = reshape(It_block, (size(It_block, 1)*size(It_block, 2)),1);
        
        A = [Ix_block, Iy_block];
        b =  -1 .* It_block;
        % changed to pinv instead of inv
        V = pinv(A' * A) * (A'* b);
    end 

    function [I_x, I_y, I_t]=computeIntensityDerivs(im1, im2)
        % computes the intensity derivatives I(x+deltax, y+deltay,
        % t+deltat)
        % input parameters:
        % image 1 and 2
        % returns: the three derivatives
        
        % setup our derivative filters, we use backward filter
        ft_x = 1/4 * [-1 1; -1 1];
        ft_y = 1/4 * [-1 -1; 1 1];
        ft_t = 1/4 * [ 1  1; 1 1];
        ctype = 'same';
        
        I_x = conv2(im1, ft_x, ctype) + conv2(im2, ft_x, ctype);
        I_y = conv2(im1, ft_y, ctype) + conv2(im2, ft_y, ctype);
        I_t = conv2(im1, ft_t, ctype) + conv2(im2, (-1 * ft_t), ctype);
        
    end % computeIntensityDerivs

end

