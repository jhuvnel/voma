function [h]=plot3d_errorbars(x, y, z, ex, ey, ez, varargin)

% create the standard 3d scatterplot
hold off;
h=plot3(x, y, z, varargin{:});

% looks better with large points
set(h, 'MarkerSize', 25);
hold on

% now draw the vertical errorbar for each point
for i=1:length(x)
        xV = [x(i); x(i)];
        yV = [y(i); y(i)];
        zV = [z(i); z(i)];

        xMin = x(i) + ex(i);
        xMax = x(i) - ex(i);
        yMin = y(i) + ey(i);
        yMax = y(i) - ey(i);
        zMin = z(i) + ez(i);
        zMax = z(i) - ez(i);

        xB = [xMin, xMax];
        yB = [yMin, yMax];
        zB = [zMin, zMax];

        % draw error bars
        h=plot3(xV, yV, zB, '-k');
        set(h, 'LineWidth', 2);
        h=plot3(xB, yV, zV, '-k');
        set(h, 'LineWidth', 2);
        h=plot3(xV, yB, zV, '-k');
        set(h, 'LineWidth', 2);
end