function [pixel]=nearestNeighbor(im, index)

    if index(1) < 1 || index(1) > size(im,1) || index(2) < 1 || index(2) > size(im,2)
        pixel = 0;
        return 
    end

    coor = floor(index(1:2) + 0.5);
    pixel = im(coor(1), coor(2)); 
        
end % nearestNeighbor
