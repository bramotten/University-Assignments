function changesSign = FwwChangesSign(vi, hi, Fx, Fy, Fxx, Fyy, Fxy, ...
	                                  vertSize, horiSize)
% Checks in 3x3 neighbourhood whether there's opposite signs
% of both sides of the central pixel.
changesSign = false;

% So let's first get that 3x3 neighbourhood.
Fww3x3 = zeros(3,3);
for vj = -1:1
	for hj = -1:1
		% v and h will be the image coordinates.
		v = vi + vj; h = hi + hj;
		if v < 1 || v > vertSize || h < 1 || h > horiSize
			continue;
		end
		% vj+2 and hj+2 the 3x3 coordinates. (-1+2=1 etc.)
		Fww3x3(vj+2, hj+2) = 1/(Fx(v,h)^2+Fy(v,h)^2) * ...
						     (Fx(v,h)^2 * Fxx(v,h) + ...
						      2 * Fx(v,h) * Fy(v,h) * Fxy(v,h) ...
						      + Fy(v,h)^2 * Fyy(v,h));
	end
end

% And now detect changes of signs between sides of the center.
top = sum(Fww3x3(3,:));
bottom = sum(Fww3x3(1,:));
left = sum(Fww3x3(:,3));
right = sum(Fww3x3(:,1));

if top > 0 && bottom < 0
	changesSign = true;
end

if bottom > 0 && top < 0
	changesSign = true;
end

if left > 0 && right < 0
	changesSign = true;
end

if right > 0 && left < 0
	changesSign = true;
end

% Gets even worse here. Check for differences between opposing corners.
topLeft = Fww3x3(3,3);
topRight = Fww3x3(3,1);
bottomLeft = Fww3x3(1,3);
bottomRight = Fww3x3(1,1);

if topLeft > 0 && bottomRight < 0
	changesSign = true;
end

if bottomLeft > 0 && topRight < 0
	changesSign = true;
end

if topRight > 0 && bottomLeft < 0
	changesSign = true;
end

if bottomRight > 0 && topLeft < 0
	changesSign = true;
end

end

