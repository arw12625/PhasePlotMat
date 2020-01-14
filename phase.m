% Interactive plotting of an 2-dimensional ode phase plot

% Specify ode with anonymous function handle
ode = @(t,y) [-y(1) + 2*y(1)^3 + y(2); -y(1) - y(2)];

% Forward time span
tspanf = [0,10];
% Backwards time span
tspanr = [10,0];
% Bounds for the phase plot
bounds = [-2,2;-2,2];

% Event function for restricting solutions within bounds
eventFcn = @(t,y) boundEventFcn(t,y,bounds);
opts = odeset('Events',eventFcn);

% Setup a figure for the phase plot
h_fig = figure(1);
hold on;
xlim(bounds(1,:));
ylim(bounds(2,:));
title('Phase Plot');
xlabel('X')
ylabel('Y')

% On the figure, points are manually selected with the mouse
% A left click plots the solution in phase space through the point
% A right click adds an arrow along the vector field at the point
% A middle click plots both
% Any other input (like pressing enter or escape) suspends adding to the figure.
% To resume plotting, do not close the figure and rerun the program.
cont = 1;
while cont
    [cx,cy,button] = ginput(1);
    y0 = [cx;cy];
    if button == 1 || button == 2 || button == 3
        if button == 2 || button == 3 % Middle or right click
            dir = ode(0,y0);
            dir = 0.05 * dir / norm(dir);
            drawArrow(y0,dir,bounds(1,:),bounds(2,:));
        end
        if button == 2 || button == 1 % Middle or left click
            [t,y] = ode45(ode,tspanf,y0(:));
            plot(y(:,1),y(:,2),'color','k')
            [t,y] = ode45(ode,tspanr,y0(:));
            plot(y(:,1),y(:,2),'color','k')
        end
    else
       cont = 0;
    end
end

% Function for drawing an arrowhead on current plot
% See  https://stackoverflow.com/questions/25729784/how-to-draw-an-arrow-in-matlab
function [h] = drawArrow(u,v,xlimits,ylimits)

xlim(xlimits)
ylim(ylimits)

h = annotation('arrow');
set(h,'parent', gca, ...
    'position', [ u(1),u(2),v(1),v(2),], ...
    'HeadLength', 10, 'HeadWidth', 10, 'HeadStyle', 'cback1', ...
    'linewidth',3,'color','k');
end

% Function representing conditions for ending solving the ode
function [pos, isterm, dir] = boundEventFcn(t,y,bounds)
    pos = min([y(1) - bounds(1,1),bounds(1,2) - y(1),y(2) - bounds(2,1),bounds(2,2) - y(2)]);
    isterm = 1;
    dir = -1;
end