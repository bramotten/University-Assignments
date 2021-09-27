function difference =  compare(image, method)
% Rotates the image 180*, then back. Hard-coded to that value
% because of the border thing implemented in rotatedImage.m
rotated = rotatedImage(image, pi, method);
rotated = rotatedImage(rotated, -pi, method);
imshow(rotated);

% Calculates the difference between the two matrices, and creates a
% singular value out of the quadratic difference.
difference = image - rotated;
difference = sum(sum(difference.*difference));
end