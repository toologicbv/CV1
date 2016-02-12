function photometric_stereo()

    load_yn = false;
    % number of light sources/images
    N = 5;
    dim1 = 512;
    dim2 = 512;
    k_factors = ones(N,1);
    k_factors(:) = 0.76;
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
    % depth_map = compute_depth_map(P, Q);
    % show_reconstructed_shape(depth_map, 16);
    
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
        S = [0 0 sqrt(3); 1 -1 0; -1 -1 0; 1 1 0;-1 1  0] .* 1/sqrt(3);
        % S = [ 0 0 1; 1/sqrt(2) 1/sqrt(2) 0; 1/sqrt(2) -1/sqrt(2) 0; ...
        %    -1/sqrt(2) -1/sqrt(2) 0; -1/sqrt(2) 1/sqrt(2) 0]; 
        V = repmat(k_factors, 1, 3) .* S;
      
    end % construct_source_vectors

    function [IM]=read_images(dim1, dim2, N, normalize)
        % read all images into a multi dimensional matrix
        % third dimension is image index number
        % input parameters:
        % (1) N: number of images
        % returns 3-dim matrix
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
        
        N = size(P,1);
        M = size(P,2);
        d_map = zeros(N, M, 1);
        
        % upper left corner is zero and remains zero
        for y=1:M
            for x=2:N
                % sum for each column over the y-derivs
                d_map(x,y) = d_map(x-1,y) + Q(x,y);
            end
        end
        % sum for each row over the x-derivs
        for x=1:N
            for y=2:M
                d_map(x,y) = d_map(x,y-1) + P(x,y);
            end
        end
        save('depth_map', 'd_map');
        
    end % compute_depth_map

    function show_reconstructed_shape(d_map, sample_step)
        % input parameters
        % (1) d_map: depth_map of reconstructed shape
        
        [height, width, ~] = size(d_map);

        [X, Y] = meshgrid(1:sample_step:height, width:-sample_step:1);
        h2 = figure();
        surf(d_map)
        % axis off;
        % axis equal;
    end % show_reconstructed_shape

end % end of function photometric_stereo