function [video]=createOpticalFlow(in_path, search_mask, out_path)
    % This function creates an optical flow video from a series of input
    % images.
    % The function first determines the corner points in the first images
    % and then tries to track these points over the several images.
    % input parameters:
    % (1) in_path: the absolute path to the input directory that contains
    % the images.
    % (2) search_mask: e.g. "*.jpeg"
    % (3) out_path: the output path of the images. we save the individual
    % images that contain the optical flow to a separate directory
    % output parameters:
    % video: video created by means of MATLAB function imvideo
    %
    % Example invocation:
    % video=printFlow('S:/Workspace/CV_III/im_in/', '*.jpeg', 'S:/Workspace/CV_III/im_out/')
    
    % initialize the parameters
    sigma = 1.4;
    w_size = 15;
    threshold = 3.5;
    % concatenate input patch with search mask
    search_mask = [in_path, search_mask];
    
    % get input images
    files = dir(search_mask);
    % load first image and determine corner pixels to track
    inFilename = [in_path, files(1).name];
    i1 = im2double(imread(inFilename));
    img_1 = convertIfNeccessary(i1);
    % initialize variable that holds the image frames for the final video
    m_frames = zeros(size(img_1,1), size(img_1,2), 3, length(files));
    % get corner points
    [ H, r, c] = HarrisCornerDetectorv2(inFilename, sigma, w_size, threshold, false);
    % plot image but don't visualize, plot corner points and save image to file
    fig = figure('visible','off');
    imshow(i1); hold on;
    plot(c, r, 'ro');
    outFileName = [out_path, files(1).name];
    % save the result
    saveas( gcf, outFileName, 'jpg' );
    % capture the frames for the video
    frame = getframe(fig);
    v_frames(:,:,:,1) = double(frame.cdata) / 255;
    
    % start looping through files, starting with second image
    for i=2:length(files)
        % concatenate input patch and filename
        inFilename = [in_path, files(i).name];     
        i2 = im2double(imread(inFilename));
        % if image is not in grayscale convert from RGB to grayscale
        img_2 = convertIfNeccessary(i2);
        % compute the new coordinates of the points to track
        % the function returns the new coordinates (so not the
        % displacement vectors)
        [new_r, new_c]=LucasKanadeTrackingPoints(img_1, img_2, r, c, w_size);
        % plot image (don't visualize) and corner points, save to output
        % directory and get the frames for the video
        fig = figure('visible','off');
        imshow(i2); hold on;
        plot(new_c, new_r, 'ro');
        outFileName = [out_path, files(i).name];
        saveas( gcf, outFileName, 'jpg' );
        % get the frame for the video
        frame = getframe(fig);
        v_frames(:,:,:,i) = double(frame.cdata) / 255;
        % store the "last" image as the nwe "first" one for the comparison
        img_1 = img_2;
        r = new_r;
        c = new_c;
    end

    video = immovie(v_frames);
    % implay(video);
    
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