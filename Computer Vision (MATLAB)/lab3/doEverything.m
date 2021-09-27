function [] = doEverything(imName, Thresh, thresh, epsilon, order)
	% This is just a copy-paste-replace from .mlx stuff.
	image = rgb2gray(im2double(imread(imName))); 
	nrho = 360; ntheta = 400;
	h = myHough(image, Thresh, nrho, ntheta);
	Lines = myHoughlines(image, h, thresh);
	Edges = edge(image, 'Canny', Thresh);
	[x, y] = find(Edges);
	Points = [y, x];

	imshow(image);
	hold on;
	lines = [];
	i = 1;
	for oldL = Lines'
		points = points_of_line(Points, oldL, epsilon);
		if length(points) > 2
			l = line_through_points(points);
			lines(i, :) = l;
			i = i + 1;
			x1 = 1;
			x2 = size(image, 2);
			y1 = (x1 * l(1) + l(3))/-l(2);
			y2 = (x2 * l(1) + l(3))/-l(2);
			line([x1, x2], [y1, y2]);
		end
	end
	hold off;
	figure
	corners = getcorners(lines);

	topleft = corners(order(1), :);
	topright = corners(order(2), :);
	bottomright = corners(order(3), :);
	bottomleft = corners(order(4), :);
	corners = [topleft; topright; bottomright; bottomleft];
	corners = [corners(:, 2), corners(:, 1)];
	projection = myProjection(image, corners, 300, 500, 'linear');
	imshow(projection);
end

