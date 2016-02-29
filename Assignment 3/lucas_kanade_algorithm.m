function [ output_args ] = lucas_kanade_algorithm( img_1_path, img_2_path, sigma )

    % convert images to double values
    img_1 = im2double(imread(img_1_path));
    img_2 = im2double(imread(img_2_path));

    % check if both images have the same dimentions
    if (size(img_1,1) ~= size(img_2,1)) | (size(img_1,2) ~= size(img_2,2))
        error('input is not the same');
    end;
    if (size(img_1,3) ~= 1) || (size(img_2,3) ~= 1)
        img_1 = rgb2gray(img_1);
        img_2 = rgb2gray(img_2);
    end;
    
    % window size for this function is 15
    window_size = 15;
    
    % determine kernel length based on sigma
    % http://stackoverflow.com/questions/23832852/by-which-measures-should-i-set-the-size-of-my-gaussian-filter-in-matlab
    kernel_length = floor(6*sigma) + 1;
    % create 1D kernel
    G = fspecial('gaussian', [1 kernel_length], sigma);
    
    % x- en y-afgeleide zijn hetzelfde als in opdracht 1 volgens mij, Gd
    % hebben we eigenlijk niet nodig maar kunnen we laten staan
    [Ix, Gd] = gaussianDer(img_1, G, sigma);
    [Iy, Gd] = gaussianDer(img_1, G', sigma);
   
    % It is volgens mij gewoon het absolute verschil
    It = imabsdiff(img_1, img_2);
    
    % hier rescale ik the images zodat er precies windows van 15 inpassen
    Ix = Ix(1:(floor(size(img_1, 1) / window_size)* window_size) , 1:(floor(size(img_1, 2) / window_size)*window_size));
    Iy = Ix(1:(floor(size(img_1, 1) / window_size)* window_size) , 1:(floor(size(img_1, 2) / window_size)*window_size));
    It = Ix(1:(floor(size(img_1, 1) / window_size)* window_size) , 1:(floor(size(img_1, 2) / window_size)*window_size));
    
    % dit is het aantal blokken van 15 dat past in de x en y richting , in
    % dit geval 8 maar dat is variable t.o.v. de input images
    x_blocks = floor(size(img_1, 1) / window_size);
    y_blocks = floor(size(img_1, 2) / window_size);
    
    
    % maak een vector van 8 lang, met op alle indexen 15
    x_block_length(1:x_blocks) = window_size;
    y_block_length(1:y_blocks) = window_size;
    
    % object met blokken van window * window  
    Ix_blocks = mat2cell(Ix, x_block_length,y_block_length);
	Iy_blocks = mat2cell(Iy, x_block_length,y_block_length);
    It_blocks = mat2cell(It, x_block_length,y_block_length);
    
    V = zeros((x_blocks * y_blocks),2 );
    for i=1:x_blocks
        for j =1:y_blocks
            
            Ix_block = Ix_blocks{i,j};
            Iy_block = Iy_blocks{i,j};
            It_block = It_blocks{i,j};
            
            V_block = calculate_v(Ix_block,Iy_block,It_block);
            
            V(index,:) = [V_block(1),V_block(1)];
        end 
    end 
    
    function [V] = calculate_v(Ix_block, Iy_block, It_block)
        Ix_block = reshape(Ix_block, (size(Ix_block, 1)*size(Ix_block, 2)),1);
        Iy_block = reshape(Iy_block, (size(Iy_block, 1)*size(Iy_block, 2)),1);
        It_block = reshape(It_block, (size(It_block, 1)*size(It_block, 2)),1);
        
        A = [Ix_block, Iy_block];
        b =  -1 .* It_block;
        V = (inv(A' * A) * A') * b;
    end 
end

