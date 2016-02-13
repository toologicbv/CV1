function photometric_stereo()

    load_yn = false;
    % number of light sources/images
    N = 5;
    dim1 = 512;
    dim2 = 512;
    k_factors = ones(N,1);
    k_factors(:) = 1.34;
    V = construct_source_vectors(k_factors);
    % load images, last parameter indicates whether or not 
    % to normalize the pixel values
    IM = read_images(dim1, dim2, N, false);
    [rho, NR, P, Q] = initialize(dim1, dim2, N);
    
    if load_yn
        load bigMat.mat
    else
        [NR, ref_image, P, Q] = compute_surface_normals(IM, N, V, NR, P, Q);
    end
    % show reflectance image that we reconstructed
    % imshow(ref_image)
    % show surface normals
    show_surf_normals(NR, 16)
    depth_map = compute_depth_map(P, Q);
    show_reconstructed_shape(depth_map, 16);
    
    function [V]=construct_source_vectors(k_factors)
        % We assume 5 light source directions for each pixel in the image
        % (1) frontal (2) left-above (3) right-above (4) left-below
        % (5) right-below
        % further we assume the light source is far away
        % input parameters:
        % (1) k_factors: the scaling factor per direction of the
        %                light source that we don't know. Assuming
        %                input is a column vector
        % im1 = front, below right, below left, right above, left above
        %s1 = [0.1 0.1 0.9]; s2 = [0.78 -0.6 0]; s3 = [-0.78 -0.6 0];
        %s4 = [0.78 0.6 0]; s5 = [-0.78 0.6 0]; 
        s1 = [0.1 0.1 0.9]; s2 = [0.9 -0.9 0.1]; s3 = [-0.9 -0.9 0.1];
        s4 = [0.9 0.9 0.1]; s5 = [-0.9 0.9 0.1]; 
        s1 = s1 ./ norm(s1); s2 = s2 ./ norm(s2); s3 = s3 ./ norm(s3);
        s4 = s4 ./ norm(s4); s5 = s5 ./ norm(s5);
        S = [s1; s2; s3; s4; s5];
        %S = [0 0 sqrt(3); 1 -1 0; -1 -1 0; 1 1 0;-1 1  0] .* 1/sqrt(3);
       
        V = repmat(k_factors, 1, 3) .* S;
      
    end % construct_source_vectors

    function [IM]=read_images(dim1, dim2, N, normalize)
        % read all images into a multi dimensional matrix
        % third dimension is image index number
        % input parameters:
        % (1) dim1: x-dim of image
        % (2) dim2: y-dim of image
        % (3) N: number of images
        % (4) normalize: true/false whether or not to normalize
        %                pixel values
        % returns 3-dim matrix IM (dim1, dim2, N)
        IM = zeros(dim1, dim2, N, 'uint8');
        for i=1:N
            i_file = ['sphere', num2str(i), '.png'];
            i1 = imread(i_file);
            if normalize
                IM(:,:,i) = (i1-min(i1(:))) ./ (max(i1(:)-min(i1(:))));
            else
                IM(:,:,i) = i1;
            end
        end
        
        
    end % read_images

    function [rho, NR, P, Q]=initialize(dim1, dim2, N)
        % initialize the empty matrices for the unknowns we have to
        % calculate
        % input parameters:
        % (1, 2) dim1/dim2: dimension of images
        %                N: number of images
        % albedo for each pixel
        rho = zeros(dim1, dim2, N, 'uint8');
        % Surface normal for each pixel (contains 3 values/pixel)
        NR = zeros(dim1, dim2, 3);
        % matrix of derivatives w.r.t. x and y dim
        P = zeros(dim1, dim2);
        Q = zeros(dim1, dim2);
        
    end % initialize

    function show_surf_normals(NR, step)
        
        [height, width, ~] = size(NR);

        [X, Y] = meshgrid(1:step:height, width:-step:1);
        U = NR(1:step:height, 1:step:width, 1);
        V = NR(1:step:height, 1:step:width, 2);
        W = NR(1:step:height, 1:step:width, 3);

        h = figure;
        quiver3(X, Y, zeros(size(X)), U, V, W);
        % view([0, 90]);
        drawnow;

    end % show_surf_normals

    function d_map=compute_depth_map(P, Q)
        % input parameter
        % (1) P: matrix of derivatives wrt x-value
        % (2) Q: matrix of derivatives wrt y-value
        % returns:
        % depth matrix
        
        % assuming P and Q have the same dim values
        rows = size(P,1);
        cols = size(P,2);
        d_map = zeros(rows, cols);
        
        % upper left corner is zero and remains zero
        % sum for each pixel in the left most column the y-derivs
        % (q-values)
        for row=2:rows
            d_map(row,1) = d_map(row-1,1) + Q(row,1);
        end
       
        % sum for each row over the x-derivs
        for row=1:rows
            % for each pixel in the row, except the first cell sum the
            % x-derivative values
            for col=2:cols
                d_map(row,col) = d_map(row,col-1) + P(row,col);
            end
        end
        save('depth_map', 'd_map');
        
    end % compute_depth_map

    function show_reconstructed_shape(d_map, sample_step)
        % input parameters
        % (1) d_map: depth_map of reconstructed shape
        
        [height, width, ~] = size(d_map);

        [X, Y] = meshgrid(1:sample_step:height, width:-sample_step:1);
        d_m = d_map(1:sample_step:height, 1:sample_step:width);
        figure();
        colormap(gray);
        surf(X,Y,d_m)
        % axis off;
        % axis equal;
    end % show_reconstructed_shape

end % end of function photometric_stereo