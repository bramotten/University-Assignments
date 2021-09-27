function bestprojm = ransacProjectionMatrix(F1, F2, matches, iterations, threshDist, inlierRatio)

% Keeps track of the biggest set of inliers and it's count.
bestinliers = [];
maxinliers = 0;

% The amount of matches which we later have to loop over
max = size(matches, 2);

for i = 1:iterations
    % Picks 4 random matches from the set of matches
    ranmatch = randperm(max, 4);
    
    % Finds the matching points for both images and stores them in xy and
    % uv. Then, create a projection matrix using those.
    count = 0;
    xy = [];
    uv = [];
    for j = ranmatch
        count = count+1;
        inliers(:, count) = matches(:, j);
        xy(:, count) = F1(1:2, matches(1, j));
        uv(:, count) = F2(1:2, matches(2, j));
    end
    projm = estimateProjectionMatrix(xy', uv');
    
    % For all other matches, if the distance between the transformed point 
    % of the left image and the actual point of the right image is smaller
    % than the threshold, add it to the current set of inliers.
    for j = 1:max
        if not (ismember(j, ranmatch))
            Coords1 = projm * [F1(1:2, matches(1, j))', 1]';
            Coords1 = Coords1(1:2) / Coords1(3);
            Coords2 = F2(1:2, matches(2, j))';
            diff = sqrt((Coords1(1)-Coords2(1))^2 + (Coords1(2)-Coords2(2))^2);
            if (diff < threshDist)
                count = count + 1;
                inliers(:, count) = matches(:, j);
            end
        end
    end
    
    % If the found set of inliers is bigger than the current best and has
    % more inliers than the minimum requirement, make it the new best.
    if ((count > max * inlierRatio) && count > maxinliers)
        bestinliers = inliers;
        maxinliers = count;
    end
end

if (maxinliers > 0)
    % If there is a best set of inliers, use those to calculate the
    % projection matrix.
    count = 0;
    xy = [];
    uv = [];
    for i = 1:maxinliers
        count = count+1;
        xy(:, count) = F1(1:2, bestinliers(1, i));
        uv(:, count) = F2(1:2, bestinliers(2, i));
    end
    bestprojm = estimateProjectionMatrix(xy', uv');
else
    % If there is no best set of inliers, return 0.
    bestprojm = 0;
end
    

