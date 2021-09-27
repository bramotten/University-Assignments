function [pts] = points_of_line(points, line, epsilon)
	% points - an array containing all points
	% line - the homogeneous representation of the line
	% epsilon - the maximum distance
	% returns :
	% pts - an array of all points within epsilon of the line
	pts = [];
    i = 1;
	for point = points'
		% Trying to get the shortest distance from point to line
		dist = abs((line(1) * point(1) + line(2) * point(2) + line(3))/ ...
                   (sqrt(line(1)^2+line(2)^2)));
		if dist < epsilon
			pts(i, :) = point;
            i = i + 1;
		end
    end
end
