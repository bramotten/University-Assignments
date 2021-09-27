function plotParallelogram(x1, y1, x2, y2, x3, y3)
		hold on;
		plot([x1, x2, x3, x3-x2+x1, x1], [y1, y2, y3, y1-y2+y3, y1], ...
			 'y', 'LineWidth', 2);
        text(x1, y1, '1', 'Color', [0, 1, 0], 'FontSize', 18);
		text(x2, y2, '2', 'Color', [0, 1, 0], 'FontSize', 18);
		text(x3, y3, '3', 'Color', [0, 1, 0], 'FontSize', 18);
