function G = Gauss1(sigma)
	N = 3; 
	X = -floor(N/2) : floor(N/2);
	h = exp(-(X.^2) / (2*sigma^2)); % only difference with Gauss.m,
									% only requires X^2 here.
 	G = h / (2*pi*sigma^2);
  	G = G / sum(G(:));
end
