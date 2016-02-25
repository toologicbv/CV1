function [] = harris_corner_detector( image_path, sgima )

kernel_lenght = (6 * sigma) + 1;
G = fspecial('guassian',[1 kernel_lenght],sigma);


im = imread(image_path);
im = im2double(im);
im = gb2grey(im);



Ix = gaussuasnDer(im, G, sigma);
Iy = gaussuasnDer(im, G', sigma)

A = Ix.^2;
C = Iy.^2;
B = Ix .* Iy; 

H = (A.*C - B .^2) - 0.04 (A .+ B).^2
imshow(H);
end

