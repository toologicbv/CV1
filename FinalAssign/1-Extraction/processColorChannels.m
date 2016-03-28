function sift_c_out=processColorChannels(I1, cspace, sample_mode)
    % find features in separate color channels for RGB, rgb and opponent
    % color model
    % 
    % Computervision I / Final Assignment
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % Input parameters:
    % I1: original image
    % cspace: color model
    % sample_mode: 'point' or 'dense'
    %
    % Returns:
    % a matrix of concatenated SIFT features for the different color
    % channels of the image
    sift_c_out = [];

    if strcmp(cspace, 'RGB')
        % in case of RGB we don't need to convert
        imgc = I1;
        l_channels = 3;
    else
        % convert to target colorspace
        imgc = convertColorspace(I1, cspace); 
        if strcmp(cspace, 'rgb')
            % for rgb we only process r and g channels (because r+g = b)
            l_channels = 2;
        elseif strcmp(cspace, 'opp')
            % for opponent color space we only process O1 and O2 channels
            % because O3 is equal to intensity channel
            l_channels = 2;
        end
    end
    % loop through color channels
    for ch=1:l_channels
        % only pass a specific color channel to SIFT
        fd = compute_SIFT_desc(imgc(:,:,ch), sample_mode);
        sift_c_out = cat(1, sift_c_out, fd);
        % convert to opponent colorspace and then find features
    end
    
  
end % processColorChannels