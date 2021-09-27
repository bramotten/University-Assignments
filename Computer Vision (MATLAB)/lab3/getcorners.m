function [corners] = getcorners(lines)
	corners = [];
	index = 1;
	% Loop through all possible combinations of lines.
	for i = 1:length(lines)
		for j = i+1:length(lines)
			newpoint = cross(lines(i, :), lines(j, :));

			% If the weight value is 0 or near 0, these lines don't intersect.
			if round(newpoint(3)) ~= 0
				corners(index, :) = newpoint / newpoint(3);
				index = index + 1;
			end
		end
	end
	% Removing the weight value, since we normalized it to 1 and serves no
	% further purpose here.
	corners = corners(:, 1:2);
end
