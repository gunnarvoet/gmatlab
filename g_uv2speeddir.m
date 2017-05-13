function [speed,dir] = g_uv2speeddir(u,v)

% [speed,dir] = g_uv2speeddir(u,v)
%
% Transformation from u and v velocity components to speed and direction.
% Direction is in degrees, counted clockwise from north.
%
% Gunnar Voet
% gvoet@ucsd.edu
%
% last modification: 18.08.2009


% Convert to complex number
z = complex(u,v);

% Speed is the absolute of the complex number
speed = abs(z);

% Angle from the complex number. The angle is counted from the x-axis.
% Above the x-axis the angle is 0 to pi, below the x-axis the angle is 0 to
% -pi.
angle1 = angle(z);

% Convert to angles counted from the y-axis, 0 to 360 in clockwise
% direction.

angle2 = nan(length(angle1),1);

% The negative angles:
x = find(angle1<=0);
angle2(x) = rad2deg(-angle1(x)+pi/2);
clear x

% Angles between 0 and pi/2
x = find(angle1>0 & angle1<=pi/2);
angle2(x) = rad2deg(-angle1(x)+pi/2);
clear x

% Angles between pi/2 and pi
x = find(angle1>pi/2);
angle2(x) = rad2deg(2*pi-(angle1(x)-pi/2));
clear x

dir = angle2;