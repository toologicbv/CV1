function photometric_stereo()

    load_yn = true;
    % number of light sources/images
    N = 5;
    dim1 = 512;
    dim2 = 512;
    k_factors = ones(N,1);
    k_factors(:) = 0.78;
    V = construct_source_vectors(k_factors);
    IM = read_images(dim1, dim2, N);
    [rho, NR, P, Q] = initialize(dim1, dim2, N);
    
    if load_yn
        load bigMat.mat
    else
        [NR, ref_image, P, Q] = compute_surface_normals(IM, N, V, NR, P, Q);
    end
    imshow(ref_image)
    
    show_surf_normals(NR, 4)
    
    function [V]=construct_source_vectors(k_factors)
        % We assume 5 light source directions for each pixel in the image
        % (1) frontal (2) left-above (3) right-above (4) left-below
        % (5) right-below
        % further we assume the light source is far away
        % input parameters:
        % (1) k_factors: the scaling factor per direction of the
        %                light source that we don't know. Assuming
        %                input is a column vector
        S = [0 0 sqrt(3); 1 1 1; 1 -1 1; -1 1 1; -1 -1 1] .* sqrt(1/3);
        V = repmat(k_factors, 1, 3) .* S;
      
    end % construct_source_vectors

    function [IM]=read_images(dim1, dim2, N)
        % read all images into a multi dimensional matrix
        % third dimension is image index number
        % input parameters:
        % (1) N: number of images
        % returns 3-dim matrix
        IM = zeros(dim1, dim2, N, 'uint8');
        for i=1:N
            i_file = ['sphere', num2str(i), '.png'];
            IM(:,:,i) = imread(i_file);
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
        view([0, 90]);
        axis off;
        axis equal;
        drawnow;

    end % show_surf_normals

    function compute_depth_map(P, Q)
        % input parameter
        % (1) P: matrix of derivatives wrt x-value
        % (2) Q: matrix of derivatives wrt y-value
        % returns:
        % depth matrix
        
        
        
    end % compute_depth_map

end % end of function photometric_stereo