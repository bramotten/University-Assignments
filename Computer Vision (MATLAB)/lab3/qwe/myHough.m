function h = myHough(im, Thresh ,nrho ,ntheta )
    % HOUGH
    %
    % Function takes a grey scale image, constructs an edge map by applying
    % the Canny detector, and then constructs a Hough transform for finding
    % lines in the image .
    %
    % Usage : h = hough (im , Thresh , nrho , ntheta )
    %
    % arguments :
    % im - The grey scale image to be transformed
    % Thresh - A 2 -vector giving the upper and lower
    % hysteresis threshold values for edge ()
    % nrho - Number of quantised levels of rho to use
    % ntheta - Number of quantised levels of theta to use
    %
    % returns ;
    % h - The Hough transform

	[rows, cols] = size(im); % rows are y coordinates.
    rhomax = sqrt(rows^2 + cols^2);	% The maximum possible value of rho.
    drho = 2 * rhomax / (nrho - 1); % The increment in rho between succ
									% entries in the accumulator matrix.
                                    % Remember we go between + - rhomax.
    dtheta = pi / ntheta;           % The increment in th between entries.
    thetas = 0:dtheta:(pi-dtheta);  % Array of theta values across the
                                    % accumulator matrix .
									
	h = zeros(nrho, ntheta); % pre-allocate h.
	imEdges = edge(im, 'Canny', Thresh);

	for y = 1:rows
		for x = 1:cols
			if imEdges(y,x) > 0 % if an edge
				for theta = thetas
					rho = x * sin(theta) - y * cos(theta); % given formula.
					% To convert a value of rho or theta
					% to its appropriate index in the array use:
					rhoindex = round(rho / drho + nrho / 2);
					thetaindex = round(theta / dtheta + 1);
					h(rhoindex, thetaindex) = h(rhoindex, thetaindex) + 1;
				end
			end
		end
	end
	
	% Normalize h:
	h = h - min(h(:));
	h = h ./ max(h(:));
end
