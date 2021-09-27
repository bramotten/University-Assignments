function projEst = estimateProjectionMatrix(xy, uv)

% Calculation of projection matrix.
x = xy(:, 1);
y = xy(:, 2);
u = uv(:, 1);
v = uv(:, 2);
o = ones(size(x));
z = zeros(size(x));
Aoddrows = [x, y, o, z, z, z, -u.*x, -u.*y, -u];
Aevenrows = [z, z, z, x, y, o, -v.*x, -v.*y, -v];
projMatrix = [Aoddrows; Aevenrows];

% Uses the SVD trick to get the estimated projection matrix.
[u, s, v] = svd(projMatrix);
Mvec = v(:, end);
projEst = reshape(Mvec, 3, 3)';



