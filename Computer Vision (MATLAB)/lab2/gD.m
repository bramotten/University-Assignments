function gD = gD(f, sigma, xorder, yorder)
% gD = Gaussian derivative of f, xorder and yorder <= 2.

% First just the regular term
gD = imfilter(f, Gauss(sigma), 'conv');
N = 3; % != the same as Gauss.m and such
x = (-floor(N/2) : floor(N/2))';
y = x;
gauSig = Gauss1(sigma);

% Now we can do specified operations on gD as well
% because of the seperability. Handles normalization as well.

if xorder >= 1
	% Here's the first x derivative.
	specialFilter = (-x / sigma^2) * gauSig;
	% Which we transpose because MATLAB has this nice x-axis being
	% vertical thing going on. 
	gD = imfilter(gD, specialFilter', 'conv');
    if xorder == 2
        % And the second one
        specialFilter = (x.^2 / sigma^4 - 1 / sigma^2) * gauSig;
        gD = imfilter(gD, specialFilter', 'conv');
    end
end

if yorder >= 1
	% Only real diff vs. dx is the lack of transpose coming up.
	% Use x because Gauss1 returns a row vec anyway.
	specialFilter = (-y / sigma^2) * Gauss1(sigma);
	gD = imfilter(gD, specialFilter, 'conv');
    if yorder == 2
        specialFilter = (y.^2 / sigma^4 - 1 / sigma^2) * gauSig;
		gD = imfilter(gD, specialFilter, 'conv');
    end
end

end