function r = myAffine(image, x1, y1, x2, y2, x3, y3, M, N, method)
r = zeros(N, M);
image = im2double(image);
% D contains: (1,1) [left-top], (N,1) [right-top], (1, M) [right-bot]
D = [1,1,1,0,0,0;...
	 0,0,0,1,1,1;...
	 N,1,1,0,0,0;...
	 0,0,0,N,1,1;...
	 N,M,1,0,0,0;...
	 0,0,0,N,M,1];
% Da = [x1, y1, x2, y2, x3, y3]'
a = D \ [x1, y1, x2, y2, x3, y3]'; % = inv(D) * ...
A = [a(1), a(2), a(3); a(4), a(5), a(6); 0, 0, 1];

seq = 1:1:M*N;
x = floor((seq-1)*(1/M)) + 1;
y = rem((seq-1), M)+1
z = repmat(1, 1, M*N);
oldpoints = vertcat(y, x, z);
points = transpose(A * oldpoints);
oldpoints = transpose(oldpoints);

for i=1:size(points)
    r(oldpoints(i, 1), oldpoints(i, 2)) = pixelValue(image, points(i, 1), points(i, 2), method);
end