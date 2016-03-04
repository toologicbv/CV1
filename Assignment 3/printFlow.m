function printFlow(in_path, search_mask, out_path)
    % 
    sigma = 1.4;
    w_size = 15;
    threshold = 0.02;
    search_mask = [in_path, search_mask];
    
    files = dir(search_mask);
    % load first image and determine corner pixels to track
    inFilename = [in_path, files(1).name];
    i1 = im2double(imread(inFilename));
    img_1 = convertIfNeccessary(i1);
    [ H, r, c] = HarrisCornerDetector(inFilename, sigma, w_size, threshold, false);
    % show image 1, plot corner points and save image to file
    imshow(i1); hold on;
    plot(c, r, 'ro');
    outFileName = [out_path, files(1).name];
    saveas( gcf, outFileName, 'jpg' );
    % start looping through files, starting with second image
    for i=2:length(files)
        close all;
        inFilename = [in_path, files(i).name];     
        i2 = im2double(imread(inFilename));
        img_2 = convertIfNeccessary(i2);
        [new_r, new_c]=LucasKanadeTrackingPoints(img_1, img_2, r, c, w_size);
        imshow(i2); hold on;
        plot(new_c, new_r, 'ro');
        outFileName = [out_path, files(i).name];
        saveas( gcf, outFileName, 'jpg' );
        i1 = i2;
        r = new_r;
        c = new_c;
    end
    close all;
    
    function [im_out]=convertIfNeccessary(im)
        % if image has color channels convert to grayscale only
        % we are assuming RGB as into colorspace
        if size(im,3) ~= 1
            % proces works only for gray scale, bring back to grey scale if the
            % images is in RGB (or other format)
            im_out = rgb2gray(im);
        else
            im_out = im;
        end
    end
    
end % printFlow