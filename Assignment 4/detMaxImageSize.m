function [x_max, y_max]=detMaxImageSize(im1, im2)
% 
    if (size(im1,1) > size(im2,1))
        x_max = size(im1,1);       
    else
        x_max = size(im2,1);
    end

    if (size(im1,2) > size(im2,2))
        y_max = size(im1,2);
    else
        y_max = size(im2,2);
    end


end % detmaxImageSize