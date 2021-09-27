function rotatedImage = rotatedImage(image, angle, method)
matrix = rot(angle); 
% Finds the new location of the corner points, to indentify the new size.
cornerpoints = [0, 0, 1; 0, size(image,2), 1; size(image, 1), 0, 1;...
	            size(image, 1), size(image, 2), 1];
newcornerpoints = cornerpoints*matrix;
maxvalue = round(max(max(newcornerpoints)));
minvalue = round(min(min(newcornerpoints)));
if (maxvalue > -minvalue)
    maxwidth = maxvalue;
else
    maxwidth = -minvalue;
end
matrix = transpose(matrix);
% Calculates the size of the border around the picture.
xcorrection = (maxwidth - size(image, 1)) / 2;
ycorrection = (maxwidth - size(image, 2)) / 2;
% Calculates the center coordinates of the picture
midx = size(image,1)/2;
midy = size(image,2)/2;
% Creates a list of all coordinate pairs of the new matrix in the form
% [x, y, 1].
seq = 1:1:maxwidth*maxwidth;
x = (seq-1)*(1/maxwidth)+1-midx-xcorrection;
y = rem((seq-1), maxwidth)+1-midy-ycorrection;
z = repmat(1, 1, maxwidth*maxwidth);
points = transpose(vertcat(y, x, z));
% Finds for each set of coordinates the corresponding coordinate of the
% older matrix, and takes it color value if it has one.
newpoints = points*matrix;
s = size(newpoints);
for i=1:s
    x = newpoints(i,1)+midx;
    y = newpoints(i,2)+midy;
	rotimage(i) = pixelValue(image, x, y, method, 'constant');
end
% Transform the list of points into a matrix with the correct size.
rotatedImage = reshape(rotimage, maxwidth, maxwidth);
end