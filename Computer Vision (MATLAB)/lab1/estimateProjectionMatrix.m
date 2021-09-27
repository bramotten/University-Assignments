function projEst = estimateProjectionMatrix(xy, XYZ)

% Calculation of projection matrix.
x = XYZ(:, 1);
y = XYZ(:, 2);
z = XYZ(:, 3);
u = xy(:, 1);
v = xy(:, 2);
% Yep this is confusing, but now (u, v) are the pixels, 
% (x,y,z) the real coordinates at last.
o = ones(size(x));
zvec = zeros(size(x));
% Check out theory again for a bit more explanation.
Aoddrows = [x, y, z, o, zvec, zvec, zvec, zvec -u.*x, -u.*y, -u.*z, -u];
Aevenrows = [zvec, zvec, zvec, zvec, x, y, z, o, -v.*x, -v.*y, -v.*z, -v];
projMatrix = [Aoddrows; Aevenrows];

% The SVD bit.
[u, s, v] = svd(projMatrix);
Mvec = v(:, end);
projEst = reshape(Mvec, 4, 3)';



