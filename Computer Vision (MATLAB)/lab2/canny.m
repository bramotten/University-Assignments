function e = canny(image, sigma, threshold)
% Returns edges of image in a new image e. Uses Guassian derivatives
% and so on as per the Canny method.

% Trust the previous Gaussian derivative function.
Fx = gD(image, sigma, 1, 0);
Fy = gD(image, sigma, 0, 1);
Fxx = gD(image, sigma, 2, 0);
Fyy = gD(image, sigma, 0, 2);
Fxy = gD(image, sigma, 1, 1);

% Now, in this Canny method, a point is an edge when:
% - Fw >> 0; (threshold)
% - Fww changes sign. 
% And the pixel value should in that case be 1, else 0.

% So let's loop through the image.
[vertsize, horisize] = size(image);
e = zeros(vertsize, horisize);
for vi = 1:vertsize
	for hi = 1:horisize
		% Check out book's 6.10 or theory for where these formulas are from
		Fwi = sqrt(Fx(vi, hi)^2 + Fy(vi, hi)^2);
		if (Fwi > threshold) % >> - is a little vague
			% But need the harder zero crossing of Fwwi now.
			% Once again, it's just a formula from the book.
			signCheck = FwwChangesSign(vi, hi, Fx, Fy, Fxx, Fyy, Fxy, ...
					          vertsize, horisize);
			if signCheck == 1
				e(vi,hi) = 1;
			end
		end
	end
end