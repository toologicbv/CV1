function [tparams]=RANSACv1(img_path1, img_path2, N, plot_result)
% Implementation of robust least square algorithm RANSAC
%
% Computervision I / Assignment 4
% J�rg Sander / 10881530
% Maurits Bleeker / 
% 
% **** NOTE *****
% we are using vlfeat-0.9.20 package
% 
% Input parameters:
% (1) img_path1: absolute file path to image 1
% (2) img_path2: absolute file path to image 2
% (3) N: number of iterations for RANSAC algorithm
% (4) plot_result: indicates whether or not to plot the results

% load images
I1_255 = imread(img_path1) ;
I2_255 = imread(img_path2) ;

% if necessary convert ot grayscale
if size(I1_255,3) > 1
    I1 = single(rgb2gray(I1_255));
    I2 = single(rgb2gray(I2_255));
else
    I1 = single(I1_255);
    I2 = single(I2_255);
end
% compute sift descriptors with Andrea Vidaldi Loewe implementation for
% both images
[f1, d1] = vl_sift(I1);
[f2, d2] = vl_sift(I2);
% find matches between the descriptors
[T, ~] = vl_ubcmatch(d1, d2);

% set max inlier count to zero and initialize RANSAC variables
max_count = 0;
tparams = zeros([6 1]);
P = 3;
threshold = 10;
% apply RANSAC, loop through the sampled matchpoints
for i=1:N
    % construct a permutation vector of the matching points
    p_matches = randperm(size(T, 2));
    % select N number of matches
    sel_matches = p_matches(1:P) ;
    [A,b]=construct_A( f1(1:2, T(1, sel_matches)), f2(1:2, T(2, sel_matches)));   
    % vector X contains m1, m2, m3, m4, t1, t2 parameters for the affine
    % transformation
    X = pinv(A) * b;
    % transformation matrix, need to be transposed otherwise we end up with
    % [m1 m3; m2 m4] but we need [m1 m2 t1; m3 m4 t2]
    M = cat(1, transpose(reshape(X, [3 2])), [0 0 1]);
    [I2_MP]=transform_matchpoints(M, T, f1);
    [inliers]=get_inliers(f2, T, I2_MP, threshold);
    % if these parameters capture more inliers then save them
    if size(inliers, 2) >= max_count
        tparams = M;
        % contains the inlier set of T
        best_inliers = inliers;
    end
    
end


sprintf('Total # of matches %d. Maximum # of inliers: %d', size(T, 2), size(best_inliers,2))

% only plot results if the number of inliers is at least 80% of the total
% match points detected by SIFT.
if plot_result && (size(best_inliers,2) > 0.8 * size(T, 2))
    % plot the randomly selected matches between both images
    % 
    % plot_matches(I1, I2, f1, f2, best_inliers)
    % p_matches = randperm(size(T, 2));
    % sel_matches = p_matches(1:50);
    % finally we transform image 1 with the best affine transformation
    % parameters we determined with RANSAC. We also use
    % nearest-neighbor interpolation to construct the result image.
    IC2 = affine_trans(I1, tparams);
    IC3 = matlab_affine_trans(I1, M);
       
    if size(best_inliers, 2) > 50
        best_inliers = best_inliers(:, 1:50);
    end
    plot_matches(I1, IC2, f1, f2, best_inliers, 'Original SIFT');
    % plot_matches(I1, IC2, f1, f2, best_inliers, 'Custom transform');
    % plot_matches(I1, IC3, f1, f2, best_inliers, 'MATLAB transform');
end

    function [A,b]=construct_A(p1, p2)
        % function constructs the A matrix and the vector b based on the
        % sampled points
        
        % construct least square "ingredients", matrix A and vector b
        % b is the transformed feature point in image 2 (x,y) coordinates
        b = p2(:);
        % construct the first two parts of the A matrix (the third is 2D
        % identity matrix)
        u1 = [ p1(:,1)' 1; 0 0 0 ];
        u1 = cat(2, u1, flipud(u1));
        u2 = [ p1(:,2)' 1; 0 0 0 ];
        u2 = cat(2, u2, flipud(u2));
        u3 = [ p1(:,3)' 1; 0 0 0 ];
        u3 = cat(2, u3, flipud(u3));
        % concatenate three parts along the column dimension
        A = cat(1, u1, u2, u3);
    end % construct_A

    function [I2_MP]=transform_matchpoints(M, T, f1)
        % performs an affine transformation on all match points from image
        % 1 to image 2.
        % M: transformation matrix
        % T: total set of match points
        % f1: sift feature points in image 1
        % 
        % returns the "new" coordinates of the match points in image 2 (2 x
        % K) matrix (where K is number of match points)
        
        % T(1,:) contains all indexes of the match points in image 1
        % I1_MP contains all match point coordinates of image 1 (2 x K)
        % matrix
        I1_MP = f1(1:2, T(1,:));
        % transform mathing points to homogeneous coordinates
        I1_MP = cat(1, I1_MP, ones(1, size(I1_MP,2)));
        I2_MP = M * I1_MP;
        % omit the third row, to get non-homogeneous coordinates
        I2_MP = I2_MP(1:2, :);
        
    end % transform_matchpoints

    function [inliers]=get_inliers(f2, T, I2_MP, threshold)
        % computes the Euclidian distance between "approximated" match
        % points in image 2 and the match points that were calculated based
        % on the siftmatch function
        % I2_MP: contains a 2 x K (where K is total # of match points)
        % matrix with the coordinates of the match points.
        %
        % returns the indexes of the inliers. indexes come from matches T
        % that holds f1 and f2 indexes.
        
        % get center points of "ideal" match points found by siftmatch
        centerp_i2 = f2(1:2, T(2,:));
        xy_distance = sqrt( (I2_MP(1,:) - centerp_i2(1,:)).^2 + (I2_MP(2,:) - centerp_i2(2,:)).^2 );
        inliers = T(:, xy_distance <= threshold );
        
    end % count_inliers

    function [I2_t]=matlab_affine_trans(im, M)
        % transform the original image based on the best parameters we
        % found by means of RANSAC and use MATLAB pre-delivered functions
        % for the transformation
        
        % make the affine matrix, we need to transpose our matrix because
        % MATLAB expects the input matrix to have zero's in the last column
        % on position (1,3) and (2,3)
        tform = affine2d(M');
        I2_t = imwarp(im, tform);
        
    end % final_transform

    function plot_matches(i1, i2, f1, f2, matches, add_to_title)
        % plots the detected descriptor matches in one figure
        
        % if two images have different sizes, determine "one fits all size"
        % and construct new images
        if (size(i1,1) ~= size(i2,1) || size(i1,2) ~= size(i2,2))
            [x_max, y_max]=detMaxImageSize(i1, i2);
            n_im1 = uint8(zeros(x_max, y_max, size(i1,3))); 
            n_im2 = uint8(zeros(x_max, y_max, size(i1,3)));
            % transfer both images to the new matrices respectively.
            n_im1(1:size(i1,1), 1:size(i1,2), 1:size(i1,3)) = i1;
            n_im2(1:size(i2,1), 1:size(i2,2), 1:size(i2,3)) = i2;
        else
           n_im1 = i1;
           n_im2 = i2;
        end
        
        figure() ; clf ; colormap gray;
        % concatenate the two images along the second dimension (image
        % width)
        imagesc(cat(2, n_im1, n_im2))
        xa = f1(1,matches(1,:)) ;
        % add width of image 1 to x-value of match point in image 2
        xb = f2(1,matches(2,:)) + size(n_im1,2) ;
        ya = f1(2,matches(1,:)) ;
        yb = f2(2,matches(2,:)) ;

        hold on ;
        h = line([xa ; xb], [ya ; yb]) ;
        set(h,'linewidth', 1, 'color', 'b') ;

        vl_plotframe(f1(:,matches(1,:))) ;
        f2(1,:) = f2(1,:) + size(n_im1,2) ;
        vl_plotframe(f2(:,matches(2,:))) ;
        axis image off ;
        f_title = ['sift matches between image 1 and 2 ', add_to_title];
        title(f_title);
           
    end % plot_matches

end % RANSAC