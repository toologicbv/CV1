function imgc=convertColorspace(IM, cspace)
    % we assume that img is in RGB colorspace
    
    if strcmp(cspace, 'rgb')
        IM = im2double(IM); % cast the image to doubles 
        % new matrix to save the result image
        imgc = zeros(size(IM,1), size(IM,2), size(IM,3)); % make a new matrix to save the transformed channels for the new collor space
        n = (IM(:,:,1) + IM(:,:,2) + IM(:,:,3));
        imgc(:,:,1) = IM(:,:,1) ./ n;
        imgc(:,:,2) = IM(:,:,2) ./ n;
        imgc(:,:,3) = IM(:,:,3) ./ n;
        
    elseif strcmp(cspace, 'opp')
        IM = im2double(IM);
        % new matrix to save the result image 
        imgc = zeros(size(IM,1), size(IM,2), size(IM,3));
        imgc(:,:,1) = (IM(:,:,1) - IM(:,:,2)) / sqrt(2);
        imgc(:,:,2) = (IM(:,:,1) + IM(:,:,2) - (2 .* IM(:,:,3))) / sqrt(6);
        imgc(:,:,3) = (IM(:,:,1) + IM(:,:,2) + IM(:,:,3)) / sqrt(3);  
        
    end
end