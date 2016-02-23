% plot zebra edges with different sigma's

i_org = imread('zebra.png');
sigmas = [0.4, 0.9 1.5 2 4 5.5];
imOut = {};
for i=1:numel(sigmas)
    [imOut{i} , Gd] = gaussianDer2('zebra.png', 11, sigmas(i));
end

figure
for i=1:numel(imOut)
    topic = ['sigma = ', num2str(sigmas(i))];
    im = im2bw(imOut{i}, 0.01);
    subplot(3, 3, i);
    imshow(im);
    title(topic);
end
        