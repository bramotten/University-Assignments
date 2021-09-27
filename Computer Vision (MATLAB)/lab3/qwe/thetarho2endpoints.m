function [x1, y1, x2, y2] = thetarho2endpoints(theta, rho, rows, cols)
    % Calculate the end points using the theta and rho values.
    x1 = 0;
    x2 = cols;
    y1 = (-rho)/cos(theta);
    y2 = (-rho + x2 * sin(theta))/cos(theta);
    
    % If the line between y1 and y2 is really vertical, we would rather
    % calculate the x values instead, since it would lead to problems.
    if abs(y1-y2) > rows
        y1 = 0;
        y2 = rows;
        x1 = rho/sin(theta);
        x2 = (y2*cos(theta) + rho)/sin(theta);
    end
end