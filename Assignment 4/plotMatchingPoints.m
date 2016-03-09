
function plotMatchingPoints(N, f1, f2, matches, img_path1, img_path2)
% plots a subset (N) of keypoint matches between image 1 and 2
%
% input parameters:
% N: number of matching keypoints to be plotted
% f1 and f2: SIFT feature point coordinates of keypoints
% d1 and d2: SIFT desriptors of keypoint matches
% matches: 2xK vector of indexes of match points. Indexes refers to columns
% in f1/f2 d1/d2
% img1_path and img2_path: absolute patch of images

    % load images
    I1 = imread(img_path1) ;
    I2 = imread(img_path2) ;

    % if necessary convert ot grayscale
    if size(I1,3) > 1
        I1 = single(rgb2gray(I1));
        I2 = single(rgb2gray(I2));
    else
        I1 = single(I1);
        I2 = single(I2);
    end
    
    % sample N matching keypoints from all matches
    p_matches = randperm(size(matches, 2));
    t_indexes = p_matches(1:N);
    % plots the detected descriptor matches in one figure

    % if two images have different sizes, determine "one fits all size"
    % and construct new images
    if (size(I1,1) ~= size(I2,1) || size(I1,2) ~= size(I2,2))
        [x_max, y_max]=detMaxImageSize(I1, i2);
        n_im1 = uint8(zeros(x_max, y_max, size(I1,3))); 
        n_im2 = uint8(zeros(x_max, y_max, size(I1,3)));
        % transfer both images to the new matrices respectively.
        n_im1(1:size(I1,1), 1:size(I1,2), 1:size(I1,3)) = i1;
        n_im2(1:size(I2,1), 1:size(I2,2), 1:size(I2,3)) = i2;
    else
       n_im1 = I1;
       n_im2 = I2;
    end

    figure() ; clf ; colormap gray;
    % concatenate the two images along the second dimension (image
    % width)
    imagesc(cat(2, n_im1, n_im2))
    xa = f1(1,matches(1,t_indexes)) ;
    % add width of image 1 to x-value of match point in image 2
    xb = f2(1,matches(2,t_indexes)) + size(n_im1,2) ;
    ya = f1(2,matches(1,t_indexes)) ;
    yb = f2(2,matches(2,t_indexes)) ;

    hold on ;
    h = line([xa ; xb], [ya ; yb]) ;
    set(h,'linewidth', 1, 'color', 'b') ;

    vl_plotframe(f1(:,matches(1,t_indexes))) ;
    % add width of image 1 to x-value of match points in image 2
    f2(1,matches(2,t_indexes)) = f2(1,matches(2,t_indexes)) + size(n_im1,2) ;
    vl_plotframe(f2(:,matches(2,t_indexes))) ;
    axis image off ;
    f_title = 'Keypoint matchings using SIFT';
    title(f_title);

end % plotMatchingPoints