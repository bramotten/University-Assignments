% script to demonstrate image mosaic
% by handpicking 4 matching points
% in the order topleft - topright - bottomright - bottomleft
f1 = imread('nachtwacht1.jpg');
f2 = imread('nachtwacht2.jpg');

[xy, xaya] = pickmatchingpoints(f1, f2, 4, 1);

% Uses the SVD trick to find the least squares solution, which allows more
% points.
projm = estimateProjectionMatrix(xy', xaya');
T = maketform('projective', projm');
[x y] = tformfwd(T,[1 size(f1,2)], [1 size(f1,1)]);


xdata = [min(1,x(1)) max(size(f2,2),x(2))];
ydata = [min(1,y(1)) max(size(f2,1),y(2))];
f12 = imtransform(f1,T,'Xdata',xdata,'YData',ydata);
f22 = imtransform(f2, maketform('affine', [1 0 0; 0 1 0; 0 0 1]), 'Xdata',xdata,'YData',ydata);
subplot(1,1,1);
imshow(max(f12,f22));