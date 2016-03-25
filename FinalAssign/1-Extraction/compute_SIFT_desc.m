function sift_d=compute_SIFT_desc(I1, sample_mode)
    % binSize for dense sampling
    binSize = 8;
    % if necessary convert ot grayscale
    if size(I1,3) > 1
        I1 = single(rgb2gray(I1));
    else
        I1 = single(I1);
    end

    if strcmp(sample_mode, 'point')
        % sparse/point sampling
        [~, sift_d] = vl_sift(I1);
    elseif strcmp(sample_mode, 'dense')
        % dense sampling
        [~, sift_d] = vl_dsift(I1);
    elseif strcmp(sample_mode, 'all')
        % compute both, point & dense
        [~, d1] = vl_sift(I1);
        [~, d2] = vl_dsift(I1, 'size', binSize);
        sift_d = cat(2, d1, d2);  
    end
    % we need to return the transpose because d is 128 x K
    sift_d = transpose(sift_d);
        
    end  % compute_graySIFT_desc