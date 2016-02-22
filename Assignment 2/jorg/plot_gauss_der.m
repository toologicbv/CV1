sigma = 1.96;
x = linspace(-5, 5, 1000);
Gd = -(x ./ sigma^2) .* 1/(sqrt(2*pi)*sigma) .* exp(-(x.^2 /(2*sigma^2)));
plot(x, Gd)
xL = xlim;
yL = ylim;
line([0 0], yL);  %x-axis
line(xL, [0 0]);  %y-axis