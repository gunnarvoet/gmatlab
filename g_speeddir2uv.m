function [u,v] = g_speeddir2uv(speed,dir)

% [u,v] = g_speeddir2uv(speed,dir)
%
% Transformation from polar to cartesian coordinates
% Transforms speed and direction (given in degrees from north)
% to u and v components.
%
% Gunnar Voet
% gvoet@ucsd.edu
%
% last modification: 05.08.2008

dir_deg = dir;
dir_rad = deg2rad( dir_deg );

v = speed .* cos( dir_rad );
u = speed .* sin( dir_rad );