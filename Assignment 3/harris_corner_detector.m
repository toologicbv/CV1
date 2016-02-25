function [cIx, cIy] = harris_corner_detector( image_path, sigma)

kernel_lenght = (6 * sigma) + 1;
G = fspecial('gaussian',[1 kernel_lenght],sigma);
n =  5;

im = imread(image_path);
im = im2double(im);
im = rgb2gray(im);

Ix = gaussianDer(im, G, sigma);
Iy = gaussianDer(im, G', sigma);

    function imout=rescale_image(im_in)
        im_min = min(im_in(:));
        im_max = max(im_in(:));
        imout = (im_in + abs(im_min)) ./ (im_max + abs(im_min));
    end

Ix = rescale_image(Ix);
Iy = rescale_image(Iy);


subplot(2,2,1), imshow(Ix);
title(['Horizontal edges']);
subplot(2,2,2), imshow(Iy);
title(['Vertical edges']);
subplot(2,2,3), imshow(image_path)
title(['Original images']);


    function [corners, c, r]=get_corners(H, n, threshold)
        
        r = []; c = [];
        half =  (n-1)/2;
        modified_H = padarray(H, [half half]);
        corners = zeros(size(H,1), size(H,2));
        % construct utility vectors in range 1 to n
        x = (1:n);
        y = (1:n);
        
        for i = half:size(H,1)
            for j = half:size(H,2)
               value = H(i,j);
               w = modified_H((x + i - half),(y + j - half));
               max_value = max(w(:));
               if value == max_value && value >= threshold
                    corners(i,j) = value;
                    r = [r, i];
                    c = [c, j];   
               else
                   corners(i,j) = 0; 
               end
            end 
        end
    end 

cIx = Ix * 255;
cIy = Iy * 255;

A = cIx.^2;
C = cIy.^2;
B = cIx .* cIy; 

H = (A .* C - B.^2) - (0.04 .* (A + C).^2);
h_max = max(H(:))
h_min = min(H(:))
%[corners, r, c]=get_corners(H,5); 


end

