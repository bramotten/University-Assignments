function projection = myProjection(image, points, m, n, method)
uv = [1, 1, m, m; 1, n, n, 1]'; % going clockwise like the parallelogram
% And this is an [xVec, yVec] thing, pretty confusing when the x denotes
% the vertical thing, a row. 
projMatrix = createProjectionMatrix(points, uv);
[u, s, v] = svd(projMatrix);
Mvec = v(:, end);
M = [Mvec(1),Mvec(2),Mvec(3);...
	 Mvec(4),Mvec(5),Mvec(6);...
	 Mvec(7),Mvec(8),Mvec(9)];

seq = 1:1:m*n;
x = (seq-1)*(1/m) + 1;
y = rem((seq-1), m)+1;
z = repmat(1, 1, m*n);
points = transpose((M \ vertcat(y, x, z)));

for i=1:size(points)
    X = points(i,:) / points(i, 3);
    projection(i) = pixelValue(image, X(1), X(2), method);
end
projection = reshape(projection, m, n);
end