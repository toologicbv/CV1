function [IT]=affine_trans(im, M)
    % performs an affine transformation on the input image based on the
    % matrix M
        
    % initialize output image
    IT = zeros(size(im));
        
    for x = 0:size(IT,1)-1
        for y = 0:size(IT,2)-1
            org = [x; y; 1];
            trans_org = [1; 1; 0] + (M * org);
            IT(x+1,y+1) = nearestNeighbor(im, trans_org);
        end
   end
   IT = uint8(IT);
        
end % affine_trans