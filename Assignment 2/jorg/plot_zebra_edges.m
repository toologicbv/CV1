% plot zebra edges with different sigma's
% load the zebra image
i_org = imread('zebra.png');
% sigma's used to test the effect of different sigma's
sigmas = [0.9 1.5 2 3 4 5.5];
imOut = {};
% for loop to calculate the gaussian derivative filter for the different
% sigma's
for i=1:numel(sigmas)
    [imOut{i} , Gd] = gaussianDer2('zebra.png', 11, sigmas(i));
end

% plot images with differt sigma's
figure
for i=1:numel(imOut)
    topic = ['sigma = ', num2str(sigmas(i))];
    im = im2bw(imOut{i}, 0.01);
    subplot(3, 3, i);
    imshow(im);
    title(topic);
end
        