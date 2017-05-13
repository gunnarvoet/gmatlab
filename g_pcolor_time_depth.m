function h = g_pcolor_time_depth(x,y,z)

% G_PCOLOR_TIME_DEPTH pcolor plot with time and depth axis
%
%   H = g_pcolor_time_depth(X,Y,Z) pcolor plot on the current axis with y
%   increasing downwards (as depth and pressure in the ocean) and x-axis is
%   set to time using tlabel
%
%   INPUT   x - x-vector, must be datenum as tlabel is used here 
%           y - depth vector (positive downwards)
%           z - data
%
%   OUTPUT  h - handle to pcolor plot
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 09/22/2015

h = pcolor(x,y,z);
shading flat;
set(gca,'ydir','reverse');
tlabel;
