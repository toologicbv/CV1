function [NR, ref_image, P, Q]=compute_surface_normals(IM, N, V, NR, P, Q)
    % input parameters
    % (1) IM: image
    % (2) N: number of light sources
    % (3) V: normalized matrix of sources
    % (4) NR: initialized matrix that stores the surface normals
    % (5) P:
    % (6) Q:
    % returns:
    % (1) NR: see above
    % (2) ref_image: the reflectance image, stores for each pixel
    %                |g|-value (see page ...)
    x_num_p = size(IM, 1);
    y_num_p = size(IM, 2);
    ref_image = zeros(size(NR,1), size(NR,2), 'uint8');
    for i=1:x_num_p
        for j=1:y_num_p
            in = reshape(double(IM(i,j,:)), N, 1);
            if sum(in) ~= 0
                % construct diagonal matrix for 
                I = diag(in);
                % compute least square solution for this pixel
                g = lsqlin(I*V, I*in); 
                % normalize g(x,y)
                g_n = g ./ norm(g);
                % replace 0/x=inf with 0
                g_n(isinf(g_n))=0;
                % store result
                NR(i,j,:) = g_n;
                % store reflectance image value
                ref_image(i,j) = norm(g);
                % store the partial derivatives P=wrt-x ; Q=wrt-y
                P(i,j) = g(1) / g(3); % wrt x
                Q(i,j) = g(2) / g(3); % wrt y
            else
                % measures from images are all zero, store zero vector
                NR(i,j,:) = zeros(3,1);
                ref_image(i,j) = zeros(3,1); % acutally redundant but for clarity
                P(i,j) = 0; % wrt x
                Q(i,j) = 0; % wrt y
            end
        end
    end
    % store the matrices, so we can play later with the plotting
    save('bigMat.mat', 'NR', 'ref_image', 'P', 'Q');

end % compute_Surface_Normals