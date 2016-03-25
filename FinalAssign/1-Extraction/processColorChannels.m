function sift_c_out=processColorChannels(I1, cspaces, sample_mode)
    % find features in rgb image, first encode RGB to rgb
    % then find features
    % Computervision I / Final Assignment
    % Jörg Sander / 10881530
    % Maurits Bleeker / 10694439
    % 
    % loop through color spaces
    sift_c_out = [];

    for c=1:length(cspaces)

        if strcmp(cspaces{c}, 'RGB')
            % in case of RGB we don't need to convert
            imgc = I1;
        else
            % convert to target colorspace
            imgc = convertColorspace(I1, cspaces{c}); 
        end
        % loop through color channels
        for ch=1:size(imgc,3)
            fd = compute_SIFT_desc(I1, sample_mode);
            sift_c_out = cat(1, sift_c_out, fd);
            % convert to opponent colorspace and then find features
        end
    end
        
end % processColorChannels