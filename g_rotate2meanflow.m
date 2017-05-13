function [ru,rv] = g_rotate2meanflow(u,v,angle)
%
% [ru,rv] = g_rotate2meanflow(u,v,angle)
% 
% Rotate current components to the mean flow direction.
%
% Input: u:     u-component (x-direction)
%        v:     v-component (y-direction)
%        angle: Angle of the mean flow direction in degrees,
%               counted clockwise from north (0 to 360)
%
% Output: ru: Rotated u-component
%         rv: Rotated v-component
%
% Gunnar Voet
% gvoet@ucsd.edu
%
% last modification: 19.08.2009

angrad = deg2rad(angle);


ru = u*cos(angrad) - v*sin(angrad);
rv = u*sin(angrad) + v*cos(angrad);