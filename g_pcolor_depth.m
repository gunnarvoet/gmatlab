function h = g_pcolor_depth(x,y,z)

% G_PCOLOR_DEPTH pcolor plot with depth axis
%
%   H = g_pcolor_depth(X,Y,Z) pcolor plot on the current axis with y
%   increasing downwards (as depth and pressure in the ocean)
%
%   INPUT   x - x-vector
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
end