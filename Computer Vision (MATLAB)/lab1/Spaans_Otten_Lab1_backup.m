%% Beeldverwerken lab 1 - Patrick Spaans & Bram Otten
%% Exercise 2

% Check out pixelValue.m.
% Check out profile.m.
a = im2double(rgb2gray(imread('autumn.tif')));
plot(profile(a, 100, 100, 120, 120, 100, 'linear'));
hold on;
plot(profile(a, 100, 100, 120, 120, 200, 'linear'), 'b');
plot(profile(a, 100, 100, 120, 120, 200, 'nearest'), 'r');
hold off;
%%
% pixelValue defaults to the 'constant' border method above.
clf
hold on;
plot(profile(a, 1, 1, 400, 600, 500, 'linear', 'constant'), 'y');
plot(profile(a, 1, 1, 400, 600, 500, 'linear', 'nearest'), 'r');
plot(profile(a, 1, 1, 400, 600, 500, 'linear', 'periodic'), 'b');
hold off;
% This looks allright: the blue line looks like a somewhat skewed
% periodic function and the red line is eventually constant at
s = size(a); a(s(1), s(2)) % the right-bottom corner of the image
%% Exercise 3
%%
% Check out rotatedImage.m
image = im2double(imread('cameraman.tif'));
imshow(image);
piSixRotatedImage = rotatedImage(image, -pi/6, 'linear'); % - for counter-clockwise
imshow(piSixRotatedImage); 
%%
% Processing time comparision
% Check out timingtest.m
linearTime = timingtest(image, pi/6, 'linear', 10)
nearestTime = timingtest(image, pi/6, 'nearest', 10)
% Comparing pixel difference
% Check out compare.m
linearDiff = compare(image, 'linear')
nearestDiff = compare(image, 'nearest')
% The distance is calculated by removing the rotated image
% matrix from the original, which leaves a
% matrix containing the differences between them. By multiplying
% this matrix with itself, we get a
% quadratic difference matrix. Then, by taking the sum of the
% entire matrix (which is taking the sum of
% the sums of the rows), we get the difference value.

% Both double rotated images look worse than the original, since
% around the border of the picture, black
% lines can be seen, but the images themself look pretty much
% indentical, so it is pretty unexpected that
% the linear picture has an almost twice as low difference.

% The black border does make a difference, since abstracting
% the original value with black creates a bigger
% difference in distance than abstracting a similar color.
%% Exercise 4
%%
% Check out myAffine.m
b = imread('cameraman.tif');
sb = size(b);
M = sb(1);
N = sb(2);
clf;
imshow(b);
% Figure out new grid points with Pythagoras' theorem:
x1 = N / 2 - sqrt((M/2)^2 + (N/2)^2);
y1 = sb(2) / 2;
x2 = sb(1) / 2;
y2 = M / 2 - sqrt((M/2)^2 + (N/2)^2);
x3 = sb(1) - (N / 2 - sqrt((M/2)^2 + (N/2)^2));
y3 = sb(2) / 2;
plotParallelogram(x1, y1, x2, y2, x3, y3);
clf;
bRot = myAffine(b, x1, y1, x2, y2, x3, y3, M, N, 'linear');
imshow(bRot);
%% Exercise 5
%%
% Check out createProjectionMatrix.m
createProjectionMatrix([1,2;3,4], [5,6;7,8])
% So compared to D (x,y) and (u,v) now have opposite meanings,
% and we have all odd rows followed by all even rows. Doesn't matter because
% we only need its null space, which remains the same.

% Check out myProjection.m
image = im2double(imread('./flyers.png'));
image = rgb2gray(image);
figure; imshow(image);
points = [570, 824, 596, 345; 189, 171, 590, 556]';
% points = ginput(4) % go top-left and clockwise!
points_flipped = [points(:, 2), points(:, 1)];
projection = myProjection(image, points_flipped, 256, 192, 'linear');
imshow(projection);
%% Exercise 7
%%
% Check out estimateProjectionMatrix.m
load('calibrationpoints.mat'); % sets xy and XYZ.
est = estimateProjectionMatrix(xy, XYZ);
% Testing, looks like it works:
threeD = [XYZ(2, 1), XYZ(2, 2), XYZ(2, 3), 1]';
twoD = [xy(2,1), xy(2,2), 1]';
twoD, threeToTwo(threeD, est)
%% Exercise 8
%%
load('calibrationpoints.mat');
est = estimateProjectionMatrix(xy, XYZ);
cal = im2double(imread('./calibrationpoints.jpg')); clf; imshow(cal);
s = size(cal); % 480x640
% We need a cube at some 3D coordinate set, and it should
% be a cube in the 3D projection's direction.
% Check out cubeToTwo.m for that.
subPlotFaces(cubeToTwo(createCube(1, [0, 0, 0]), est));
subPlotFaces(cubeToTwo(createCube(1, [0, 7, 6]), est));
subPlotFaces(cubeToTwo(createCube(1, [5, 0, 3]), est));
% Looks a little better when you zoom in in a figure window.
%%
cal = im2double(imread('./view1.jpg')); clf; imshow(cal);
XYZNew = [0, 0, 0;...
    2, 0, 0; 0, 2, 0; 0, 0, 2;... % close by and counter clock-wise
    2, 0, 4; 0, 2, 4; % think!
    0, 4, 4; 4, 0, 4]; % ,,
%xyview1 = ginput(size(XYZNew,  1))
xyview1 = [283.9495, 487.0854; 319.4895, 475.5871; 245.2735, 477.6777; 282.9042, 436.9111;...
    318.4443, 378.3746; 244.2282, 379.4199; 208.6882, 375.2387; 346.6672, 371.0575];
oneMat = ones(size(XYZNew, 1)); oneVec = oneMat(:, 1);
xyview1InForm = [xyview1 oneVec];
estV1 = estimateProjectionMatrix(xyview1InForm, XYZNew);
subPlotFaces(cubeToTwo(createCube(1, [0, 0, 0]), estV1));
subPlotFaces(cubeToTwo(createCube(1, [0, 7, 6]), estV1));
subPlotFaces(cubeToTwo(createCube(1, [5, 0, 3]), estV1));
%%
cal = im2double(imread('./view2.jpg')); clf; imshow(cal);
%xyview2 = ginput(size(XYZNew,  1)) % 
xyview2 = [238.0000, 488.0000; 274.0000, 479.0000; 201.0000, 483.0000; 234.0000, 442.0000;...
          270.0000, 380.0000; 195.0000, 382.0000; 159.0000, 379.0000; 301.0000, 372.0000];
xyview2InForm = [xyview2 oneVec];
estV2 = estimateProjectionMatrix(xyview2InForm, XYZNew);
subPlotFaces(cubeToTwo(createCube(1, [0, 0, 0]), estV2));
subPlotFaces(cubeToTwo(createCube(1, [0, 7, 6]), estV2));
subPlotFaces(cubeToTwo(createCube(1, [5, 0, 3]), estV2));
%%
cal = im2double(imread('./view3.jpg')); clf; imshow(cal);
%xyview3 = ginput(size(XYZNew,  1))
xyview3 = [276.0000, 493.0000; 315.0000, 481.0000; 242.0000, 485.0000; 277.0000, 441.0000;...
          313.0000, 382.0000; 238.0000, 385.0000; 205.0000, 382.0000; 348.0000, 374.0000];
xyview3InForm = [xyview3 oneVec];
estV3 = estimateProjectionMatrix(xyview3InForm, XYZNew);
subPlotFaces(cubeToTwo(createCube(1, [0, 0, 0]), estV3));
subPlotFaces(cubeToTwo(createCube(1, [0, 7, 6]), estV3));
subPlotFaces(cubeToTwo(createCube(1, [5, 0, 3]), estV3));
%%
cal = im2double(imread('./view4.jpg')); clf; imshow(cal);
%xyview4 = ginput(size(XYZNew,  1)) % save these and comment this call out.
xyview4 = [217.0000, 500.0000; 260.0000, 488.0000; 186.0000, 491.0000; 215.0000, 450.0000;...
          255.0000, 388.0000; 180.0000, 392.0000; 152.0000, 387.0000; 295.0000, 379.0000];
xyview4InForm = [xyview4 oneVec];
estV4 = estimateProjectionMatrix(xyview4InForm, XYZNew);
subPlotFaces(cubeToTwo(createCube(1, [0, 0, 0]), estV4));
subPlotFaces(cubeToTwo(createCube(1, [0, 7, 6]), estV4));
subPlotFaces(cubeToTwo(createCube(1, [5, 0, 3]), estV4));