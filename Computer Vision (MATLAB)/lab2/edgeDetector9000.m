function retImage = edgeDetector9000(image, sigma)
% Detects images, based on formulas book.

% Let's copy most of canny.m to start with
Fx = gD(image, sigma, 1, 0);
Fy = gD(image, sigma, 0, 1);
Fxx = gD(image, sigma, 2, 0);
Fyy = gD(image, sigma, 0, 2);
Fxy = gD(image, sigma, 1, 1);

[vertsize, horisize] = size(image);
retImage = zeros(vertsize, horisize);
for vi = 1:vertsize
	for hi = 1:horisize
		% Take formulas from book and calculate inefficiently.
		Fw = sqrt(Fx(vi, hi)^2 + Fy(vi, hi)^2);
		Fvv = 1/(Fx(vi, hi)^2 + Fy(vi, hi)^2) * ...
			  (Fx(vi, hi)^2 * Fyy(vi, hi) - ...
			  2 * Fx(vi, hi) * Fy(vi, hi) * Fxy(vi, hi) + ...
			  Fy(vi, hi)^2 * Fxx(vi, hi));
		retImage(vi, hi) = -Fvv * Fw^3;
	end
end

retImage = retImage * 9000; % it's not bright by default

