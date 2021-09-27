function rotatedImage = rotatedImage(image, angle, method)
matrix = rot(angle);
maxwidth = size(image, 1);
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
for i=1:size(newpoints)
    x = newpoints(i,1)+midx;
    y = newpoints(i,2)+midy;
    if (x >= 1) && (x < maxwidth) && (y >= 1) && (y < maxwidth)
        rotimage(i) = pixelValue(image, x, y, method, 'constant');
    else
        rotimage(i) = 0;
    end
end
% Transform the list of points into a matrix with the correct size.
rotatedImage = reshape(rotimage, maxwidth, maxwidth);
end