function [lines] = myHoughlines(im, h, thresh)
	% HOUGHLINES
	%
	% Function takes an image and its Hough transform , finds the
	% significant lines and draws them over the image
	%
	% Usage : houghlines (im , h, thresh )
	%
	% arguments :
	% im - The original image
	% h - Its Hough Transform
	% thresh - The threshold level to use in the Hough Transform
	% to decide whether an edge is significant

	% Reverse formulas from myHough.m
	[rows, cols] = size(im);
	rhomax = sqrt(rows^2 + cols^2);	
	[nrho, ntheta] = size(h);
	drho = 2 * rhomax / (nrho - 1);
	dtheta = pi / ntheta; 

	h = dilation(h, 3);

	threshedH = zeros(nrho, ntheta);

	% Check if tresh < h(.., ..)
	for y = 1:nrho
		for x = 1:ntheta
			if thresh < h(y, x)
				threshedH(y,x) = h(y,x);
			end
		end
	end

	[bwl, nregions] = bwlabel(threshedH, 4);

	imshow(im);
	hold on;

	for n = 1:nregions
		% Only consider one region
		mask = bwl == n;
		region = mask .* threshedH;
		[maxRow, y] = max(region);
		[~, x] = max(maxRow);
		y = y(x);
		% And reverse myHough.m's formulas again.
		theta = (x - 1) * dtheta;
		rho = drho * (y - nrho/2);
		[x1, y1, x2, y2] = thetarho2endpoints(theta, rho, rows, cols);
		line([x1, x2], [y1, y2]);
		% The line in homogenous coordinates.
		lines(n, :) = cross([x1, y1, 1], [x2, y2, 1]);
	end
	hold off;
end
