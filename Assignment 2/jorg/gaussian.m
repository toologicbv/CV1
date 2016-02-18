function G=gaussian(sigma, kernel_length)
    % implementation of a 1D-Gaussian filter
    % input parameters:
    % (1) sigma: standard deviation sigma
    % (2) kernel_length: length of the kernel
    % returns
    % G: the 1D G-filter
    
    min_range = -kernel_length/2.;
    max_range = kernel_length/2.;
    x = linspace(min_range, max_range, kernel_length);
    G = 1/(sqrt(2*pi)*sigma) .* exp(-(x.^2 /(2*sigma^2)));
    % normalize filter
    G = G ./ sum(G);
    
end % gaussian