function G = Gauss(sigma)
	N = 3;% easy to understand, fast.
	ind = -floor(N/2) : floor(N/2); % N==M means it's square.
	[X, Y] = meshgrid(ind, ind);
	h = exp(-(X.^2 + Y.^2) / (2*sigma^2));
 	G = h / (2*pi*sigma^2); % the 1/... business.
  	G = G / sum(G(:)); % normalize
end
