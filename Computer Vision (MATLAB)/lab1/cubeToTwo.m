function twoD = cubeToTwo(cube, proj)
% Pseudo: for coordinate in 3D cube, convert to 2D,
%		  return cube on projected grid.
s = size(cube);
twoD = zeros(s(1), s(2), 3);
for i = 1:s(1)
	for j = 1:s(2)
		threeD = [cube(i, j, 1); cube(i, j, 2); cube(i, j, 3); 1];
		singleTwoD = threeToTwo(threeD, proj);
		twoD(i, j, 1) = singleTwoD(1);
		twoD(i, j, 2) = singleTwoD(2);
		twoD(i, j, 3) = singleTwoD(3);
	end
end