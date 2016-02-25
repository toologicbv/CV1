function [] = harris_corner_detector( image_path, sigma)

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


    function corners = get_corners(H, n)
        modified_H = padarray(H,(n-1)/2);
        corners = zeros(size(H,1), size(H,2));
        half =  (n-1)/2;
        x = [1,n];
        y = [1,n];
        treshhold = 0.1;
        for i = half:size(H,1) - half
            for j = half:size(H,2) - half
               value = H(i,j);
               tmp = modified_H((x + i - half),(y + i - half));
               max_value = max(tmp(:));
               if value == max_value && value >= treshhold
                    corners(i,j) = value;
               else
                   corners(i,j) = 0; 
               end
            end 
        end 
    end 

A = Ix.^2;
C = Iy.^2;
B = Ix .* Iy; 

H = (A .* C - B .^2) - (0.04 .* (A + B).^2);
h_max = max(H(:))
h_min = min(H(:))
%get_corners(H,5); 



end

