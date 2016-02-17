function show_cspace_channels(image, cspace)
% input parameters:
% (1) image name
% (2) name of the color space (supported: RGB, rgb, opp, HSV)
    
    % check if the user gives a valid color space as input parameter
    assert( (strcmp(cspace,'RGB') || strcmp(cspace, 'rgb') || strcmp(cspace, 'opp') || ...
        strcmp(cspace, 'HSV') || strcmp(cspace, 'YCbCr')), ...
        'the following color spaces are supported: RGB, rgb, opp(onent), HSV');
    
    % load image
    IM = im2double(imread(image));
    
    % if-else statement to select the right color space
    if strcmp(cspace, 'RGB')
        % plot only original RGB values 
        nColor = 3; % amount of channels 
        plot_color_space_channels(IM, cspace, nColor, IM);
        
    elseif strcmp(cspace, 'rgb')
        % plot normalized rgb color space
        nColor = 3;
        IM = im2double(IM); % cast the image to doubles 
        % new matrix to save the result image
        i1 = zeros(size(IM,1), size(IM,2), size(IM,3)); % make a new matrix to save the transformed channels for the new collor space
        n = (IM(:,:,1) + IM(:,:,2) + IM(:,:,3));
        i1(:,:,1) = IM(:,:,1) ./ n;
        i1(:,:,2) = IM(:,:,2) ./ n;
        i1(:,:,3) = IM(:,:,3) ./ n;
        plot_color_space_channels(i1, cspace, nColor,IM);
        
    elseif strcmpi(cspace, 'opp')
        % plot opponent color space
        nColor = 3;
        IM = im2double(IM);
        % new matrix to save the result image 
        i1 = zeros(size(IM,1), size(IM,2), size(IM,3));
        i1(:,:,1) = (IM(:,:,1) - IM(:,:,2)) / sqrt(2);
        i1(:,:,2) = (IM(:,:,1) + IM(:,:,2) - (2 .* IM(:,:,3))) / sqrt(6);
        i1(:,:,3) = (IM(:,:,1) + IM(:,:,2) + IM(:,:,3)) / sqrt(3);  
        
        plot_color_space_channels(i1, cspace, nColor, IM);
        
    elseif strcmpi(cspace, 'HSV')
        % plot HSV color space
        nColor = 3;
        i2 = rgb2hsv(IM); % use default MATLAB function for this color space 
        plot_color_space_channels(i2, cspace, nColor, IM);
    
    end % evaluate colorspace model
    
    
    % function that plot 4 images, the full image and 1 for every processed
    % color channel
    function plot_color_space_channels(im, cspace, nColor, original_img)
        % give different title for the plot based on the color space input
        if strcmpi(cspace, 'HSV')
            plot1 = 'Hue'
            plot2 = 'Saturation'
            plot3 = 'Value'
        elseif strcmpi(cspace, 'opp')
            plot1 = 'Luminance component'
            plot2 = 'Red-Green channel'
            plot3 = 'blue-yellow channel'
        elseif strcmpi(cspace, 'RGB') || strcmpi(cspace, 'rgb') || strcmpi(cspace, 'opp')
            plot1 = 'Red'
            plot2 = 'Green'
            plot3 = 'Blue'
        end 
        
        subplot(2,2,1), imshow(im(:, :, 1))
        title(['Colorspace ', plot1 ,' channel ', cspace, ' /  channel ', num2str(1)]);
        subplot(2,2,2), imshow(im(:, :, 2))
        title(['Colorspace ', plot2 ,' channel ', cspace, ' /  channel ', num2str(2)]);
        subplot(2,2,3), imshow(im(:, :, 3))  
        title(['Colorspace ', plot3 ,' channel ', cspace, ' /  channel ', num2str(3)]);

        subplot(2,2,4), imshow(original_img)  
        title(['Original full images']);
    end % plot_color_space_channels
    
end % show_cspace_channels