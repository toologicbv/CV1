function photometric_stereo()
    % Computer Vision 1, Assignment 1
    % Implementation of photometric stereo, February 2016
    % Jörg Sander, 10881530
    % Maurits Bleeker, 10694439
    
    % number of light sources/images
    N = 5;
    % scaling factor for unit source vectors
    k_factors = ones(N,1);
    % this value gives good results
    k_factors(:) = 1.34;
    % construct the light source vectors
    V = construct_source_vectors(k_factors);
    % load images, last parameter indicates whether or not 
    % to normalize the pixel values
    [IM, dim1, dim2] = read_images(N, false);
    % initialize matrix for surface normals, x and y partial derivatives
    % necessary for the reconstruction of the shape
    [NR, P, Q] = initialize(dim1, dim2);
    % compute the surface normals
    [NR, ref_image, P, Q] = compute_surface_normals(IM, N, V, NR, P, Q);
    
    % show reflectance image that we reconstructed
    figure(1);
    imshow(ref_image)
    title('Reflectance of surface based on g(x,y)')
    drawnow;
    % show surface normals
    show_surf_normals(NR, 16)
    depth_map = compute_depth_map(P, Q);
    show_reconstructed_shape(depth_map, 16);
    
    function [V]=construct_source_vectors(k_factors)
        % We assume 5 light source directions for each pixel in the image
        % (1) frontal 
        % (2) below right 
        % (3) below left (4) right above
        % (5) left above
        % further we assume the light source is at infinity
        % input parameters:
        % (1) k_factors: the scaling factor per direction of the
        %                light source that we don't know. Assuming
        %                input is a column vector
        % returns:
        % V matrix of scaled unit source vectors
        
        % proces of a lot of trail and error with source vectors gave the
        % best results 
        s1 = [0.1 0.1 0.9];
        s2 = [0.9 -0.9 0.1]; 
        s3 = [-0.9 -0.9 0.1];
        s4 = [0.9 0.9 0.1]; 
        s5 = [-0.9 0.9 0.1];
        
        
        s1 = s1 ./ norm(s1); 
        s2 = s2 ./ norm(s2); 
        s3 = s3 ./ norm(s3);
        s4 = s4 ./ norm(s4); 
        s5 = s5 ./ norm(s5);
        
        % stack matrix
        S = [s1; s2; s3; s4; s5];
        % compute V matrix
        V = repmat(k_factors, 1, 3) .* S;
      
    end % construct_source_vectors

    function [IM,d1,d2]=read_images(N, normalize)
        % read all images into a multi dimensional matrix
        % third dimension is image index number
        % input parameters:
        % (1) N: number of images
        % (2) normalize: true/false whether or not to normalize
        %                pixel values
        % returns:
        % 3-dim matrix IM (dim1, dim2, N)
        % x and y dimension of image(s)
        i1 = imread('sphere1.png');
        [d1, d2, ~] = size(i1);
        IM = zeros(d1, d2, N, 'uint8');
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

    function [NR, P, Q]=initialize(dim1, dim2)
        % initialize the empty matrices for the unknowns we have to
        % calculate
        % input parameters:
        % (1, 2) dim1/dim2: dimension of images
        % returns:     
        % NR: initialized matrix that stores the surface normals
        % P: matrix that stores the partial derivatives wrt x for each
        % pixel
        % Q: matrix that stores the partial derivatives wrt y for each
        % pixel
        NR = zeros(dim1, dim2, 3);
        P = zeros(dim1, dim2);
        Q = zeros(dim1, dim2);
        
    end % initialize

    function show_surf_normals(NR, sample_step)
        % input parameters
        % (1) NR: matrix that stores the surface normals
        % (2) sample_step: step size for sampling pixels
        [height, width, ~] = size(NR);

        [X, Y] = meshgrid(1:sample_step:height, width:-sample_step:1);
        U = NR(1:sample_step:height, 1:sample_step:width, 1);
        V = NR(1:sample_step:height, 1:sample_step:width, 2);
        W = NR(1:sample_step:height, 1:sample_step:width, 3);

        figure(2);
        quiver3(X, Y, zeros(size(X)), U, V, W);
        view([0, 75]);
        title('Surface normals');
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
        
    end % compute_depth_map

    function show_reconstructed_shape(d_map, sample_step)
        % input parameters
        % (1) d_map: depth_map of reconstructed shape
        % (2) sample_step: step size for sampling pixels
        [height, width, ~] = size(d_map);

        [X, Y] = meshgrid(1:sample_step:height, width:-sample_step:1);
        d_m = d_map(1:sample_step:height, 1:sample_step:width);
        figure(3);
        colormap(gray);
        surf(X,Y,d_m)
        title('Reconstructed shape')

    end % show_reconstructed_shape

end % end of function photometric_stereo