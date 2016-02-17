function [NR, ref_image, P, Q]=compute_surface_normals(IM, N, V, NR, P, Q)
    % name of function may be a little misleading
    % function is not only calculating surface normals, but also
    % the partial derivatives w.r.t. x and y for each pixel
    % and the reflectance image values
    % 
    % input parameters
    % (1) IM: images
    % (2) N: number of light sources
    % (3) V: matrix of source vectors
    % (4) NR: initialized matrix that stores the surface normals
    % (5) P: matrix that stores the partial derivatives wrt x for each
    % pixel 
    % (6) Q: matrix that stores the partial derivatives wrt y for each
    % pixel
    % returns:
    % (1) NR: see above
    % (2) ref_image: the reflectance image, stores for each pixel
    %                |g|-value
    x_num_p = size(IM, 1);
    y_num_p = size(IM, 2);
    ref_image = zeros(size(NR,1), size(NR,2), 'uint8');
    for i=1:x_num_p
        for j=1:y_num_p
            % get the pixel values from all N images
            % and stack them together in a column vector
            iv = reshape(double(IM(i,j,:)), N, 1);
            % if all values are equal to zero it's not necessary to compute
            % "any" values.
            if sum(iv) ~= 0
                % construct diagonal matrix, zeroing the contributions 
                % from shadowed regions
                I = diag(iv);
                d = I*iv;
                L = I*V;
                % compute least square solution for this pixel
                g = (L.'*L)\(L.'*d);  
                % normalize g(x,y)
                if norm(g) ~= 0
                    g_n = g ./ norm(g);
                else
                    g_n = [0;0;0];
                end
                % store unit normal vector for this pixel
                NR(i,j,:) = g_n;
                % store reflectance image value for this pixel
                ref_image(i,j) = norm(g);
                % store the partial derivatives P=wrt-x ; Q=wrt-y
                % reverse sign of partial derivatives in order to have an
                % "concave" surface plot 
                P(i,j) = -g(1) / g(3); % wrt x
                Q(i,j) = -g(2) / g(3); % wrt y
            else
                % measures from images are all zero, store zero vector
                NR(i,j,:) = zeros(3,1);
                ref_image(i,j) = 0; % actually redundant but for clarity
                P(i,j) = 0; % wrt x
                Q(i,j) = 0; % wrt y
            end
        end
    end

end % compute_Surface_Normals