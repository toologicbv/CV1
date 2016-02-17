function G=gaussian(sigma)
    % implementation of a 1D-Gaussian filter
    % input parameters:
    % (1) standard deviation sigma
    % returns
    % G: the 1D G-filter
    range_size = 5;
    min_range = -range_size/2;
    max_range = range_size/2;
    x = linspace(min_range, max_range, range_size);
    G = 1/(sqrt(2*pi)*sigma) .* exp(-(x.^2/(2*sigma^2)));

end % gaussian