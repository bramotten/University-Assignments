function line = profile(image, x0, y0, x1, y1, n, method, border_method)
% Profile of an image along straight line in n points
x = linspace(x0, x1, n); y = linspace(y0, y1, n);
if nargin < 8
	border_method = 'constant'; % default value
end
for i = 1:length(x)
    line(i) = pixelValue(image, x(i), y(i), method, border_method);
end
end