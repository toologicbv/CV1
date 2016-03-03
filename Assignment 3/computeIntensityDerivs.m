function [I_x, I_y, I_t]=computeIntensityDerivs(im1, im2)
        % computes the intensity derivatives I(x+deltax, y+deltay,
        % t+deltat)
        % input parameters:
        % image 1 and 2
        % returns: the three derivatives
        
        % setup our derivative filters, we use backward filter
        ft_x = 1/4 * [-1 1; -1 1];
        ft_y = 1/4 * [-1 -1; 1 1];
        ft_t = 1/4 * [ 1  1; 1 1];
        ctype = 'same';
        
        % how to calculate the derivatives. Only for image 1 in both
        % directions?
        I_x = conv2(im1, ft_x, ctype); %+ conv2(im2, ft_x, ctype);
        I_y = conv2(im1, ft_y, ctype); %+ conv2(im2, ft_y, ctype);
        % I_t is just the intensity difference for each pixel between image
        % 1 and 2
        I_t = conv2(im1, ft_t, ctype) + conv2(im2, (-1 * ft_t), ctype);
        
    end % computeIntensityDerivs