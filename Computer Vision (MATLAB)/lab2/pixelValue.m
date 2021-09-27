function color = pixelValue (image, x, y, method, border_method)
% color = pixel value at real coordinates
if nargin < 5
	border_method = 'constant';
end
s = size(image);
% Only have to do special stuff within borders.
if x <= s(1) && y <= s(2) && x >= 1 && y >= 1
	switch (method)
		case 'nearest'
			color = image(floor(x + .5), floor(y + .5));
			return;
		case 'linear'
			% Check out theory part for a kind of derivation, in a sense
			% the average of the four surrounding known points (whole
			% integers). 
			lowX = floor(x); lowY = floor(y);
			a = x - lowX;
			b = y - lowY;
			color = (1-b)*((1-a)*image(lowX, lowY)+  ...
						   a*image(lowX + 1, lowY))+ ...
					b*((1-a)* image(lowX, lowY + 1)+ ...
					   a*image(lowX+1, lowY+1));
	end 
else
	switch(border_method)
		case 'constant'
			color = 0;
			return;
		case 'nearest'
			% Increase small values to closest defined point
			if x < 1
				nearestX = 1;
			else
				nearestX = floor(x + .5); % and make everything an int
			end
			if y < 1
				nearestY = 1;
			else
				nearestY = floor(y + .5);
			end
			% Reduce max values to closest defined point
			nearestX = min(nearestX, s(1));
			nearestY = min(nearestY, s(2));
			color = image(nearestX, nearestY);
			return;
		case 'periodic'
			% Periodic means using x' = 1 if x = 1 and x = s(1) + 1 etc.
			if x > s(1)
				x = mod(x, s(1));
			end
			if y > s(2)
				y = mod(y, s(2));
			end
			if x < 1
				x = 1;
			end
			if y < 1
				y = 1;
			end
			x = floor(x + .5); % again, we want ints
			y = floor(y + .5);
			color = image(x, y);
			return;
	end
end
end
