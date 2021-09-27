function time = timingtest(image, angle, method, iterations)
% Do a given amount of rotations, and return the average time it takes.
tic
for i=1:iterations
    rotatedImage(image, angle, method);
end
time = toc / iterations;
end
    