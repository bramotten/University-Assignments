function l = line_through_points(points)
	% returns:
	%	l	- homogeneous representation of square fit.
	
	% Compute centroid	
	one_vec(1:size(points,1)) = 1;
	centr = (one_vec * points) / size(points,1);
	newPoints = points - centr(one_vec, :);
	
	% Make covariance matrix
	covPoints = (newPoints.' * newPoints) / (size(points,1) - 1);
	
	% Compute eigenstuff (which, yes, can be done Leo's way)
	[V, ~] = eig(covPoints);
	
	% Get eigenvector of maximum eigenvalue
	eVec = V(:,end);
    
    % Find two points and calculate the line between them, which is the
    % homogeneous representation of the square fit.
    x1 = centr(1);
    y1 = centr(2);
    x2 = centr(1) + eVec(1);
    y2 = centr(2) + eVec(2);
    l = cross([x1, y1, 1], [x2, y2, 1]);
end

