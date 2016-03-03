function [new_r, new_c]=LucasKanadeTrackingPoints(img_1, img_2, r, c, window_size)
% function that computes optical flow vectors for an array of corner points
% (detected by Harris-Detector).
% input parameters:
% (1 + 2) images one and two
% (3 + 4) coordinates of corner points
% (5) window size of patch. NOTE: we're assuming an odd window size
% r: vector of row indices
% c: vector of column indices
% returns: 
% (1) new_r: row indices after displacement
% (2) new_c: colum indices after displacement

% compute total number of pixels in patch
num_pixels = window_size^2;
% compute image derivatives w.r.t. x, y and t
[Ix, Iy, It]=computeIntensityDerivs(img_1, img_2);
% Ignore corner points that are to close to corner
half_w_size = floor( (window_size - 1) / 2);
indexes = find( r <= (size(img_2, 1) - half_w_size) & r > half_w_size & ...
    c <= (size(img_2, 2) -  half_w_size) & c > half_w_size );
r = r(indexes);
c = c(indexes);

% first build patch window around corner point
% then compute approximated displacement vector for corner point
new_r = zeros(1, length(indexes));
new_c = zeros(1, length(indexes));
for i=1:length(indexes)
    % compute the patch offsets w.r.t the corner point
    r_min = r(i) - half_w_size;
    r_max = r(i) + half_w_size;
    c_min = c(i) - half_w_size;
    c_max = c(i) + half_w_size;
    % construct the building blocks of A matrix and b
    Ix_block = reshape(Ix(r_min:r_max, c_min:c_max), num_pixels, 1);
    Iy_block = reshape(Iy(r_min:r_max, c_min:c_max), num_pixels, 1);
    It_block = reshape(It(r_min:r_max, c_min:c_max), num_pixels, 1);
    A = [Ix_block, Iy_block];
    b =  -1 .* It_block;
    V = pinv(A) * b;
    % compute the new coordinates of the corner points
    new_r(i) = r(i) + V(1);
    new_c(i) = c(i) + V(2);
end

end % LucasKanadeTrackingPoints



