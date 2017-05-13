function out = g_nginput

% G_NGINPUT
%
%   OUT = g_nginput Use ginput on a timeseries and copy the x-coordinate
%                   to the clipboard
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 05/12/2014

% Get input data
[x,y] = ginput;

% Write to output variable
out.x = round(x)';
out.y = y';

% Create strings
xout = sprintf('%1.0f ',out.x);
s = sprintf('%s',xout);

% Copy output string to clibpoard
clipboard('copy',s)