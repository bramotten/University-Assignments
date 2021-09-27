f1 = imread('nachtwacht1.jpg');
f2 = imread('nachtwacht2.jpg');

image1 = im2single(rgb2gray(imread('nachtwacht1.jpg')));
image2 = im2single(rgb2gray(imread('nachtwacht2.jpg')));

% Uses vl_feat to calculate the features and their descriptor sets, which
% are then used to find the matching keypoints.
[F1, D1] = vl_sift(image1);
[F2, D2] = vl_sift(image2);
matches = vl_ubcmatch(D1, D2);

% Uses ransac and the SVD trick to find the least squares solution,
% which allows more points.
iterations = 17;
threshDist = 1;
inlierRatio = 8/size(matches, 2);
projm = ransacProjectionMatrix(F1, F2, matches, iterations, threshDist, inlierRatio)

T = maketform('projective', projm');
[x y] = tformfwd(T,[1 size(f1,2)], [1 size(f1,1)]);


xdata = [min(1,x(1)) max(size(f2,2),x(2))];
ydata = [min(1,y(1)) max(size(f2,1),y(2))];
f12 = imtransform(f1,T,'Xdata',xdata,'YData',ydata);
f22 = imtransform(f2, maketform('affine', [1 0 0; 0 1 0; 0 0 1]), 'Xdata',xdata,'YData',ydata);
subplot(1,1,1);
imshow(max(f12,f22));
