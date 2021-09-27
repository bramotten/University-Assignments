% plots a number of zigzag-lines (on top of an existing figure)
% the zigzag-lines need to be given as an n-by-k-by-2 matrix, where
% n is the number of zigzag-lines,
% k is the number of points in each zigzag-line connected by the plot
%   (note that with k points you can draw a closed (k-1)-gon)
% pFaces(:,:,1) and pFaces(:,:,2) are the x- and y- coordinates of these
%   points, respectively
function subPlotFaces(pFaces)
    hold on;
    for i = 1:size(pFaces, 1)
        % plot each face
        plot(pFaces(i,:,1), pFaces(i,:,2), '.-', ...
			 'MarkerSize', 5, 'Color', 'b', 'LineWidth', 2)
    end
    hold off;
