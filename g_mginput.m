function out = g_mginput

% G_MGINPUT
%
%   OUT = g_mginput Use ginput on an m_map, automatically convert to
%   longitude and latitude and copy the output to the clipboard
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 11/22/2013

% Get input data
[x,y] = ginput;

% Convert to lon and lat
[nlon,nlat] = m_xy2ll(x,y);

% Write to output variable
out.lon = nlon';
out.lat = nlat';

% Create strings
slon = ['[', sprintf('%1.4f ',nlon),']'];
slat = ['[', sprintf('%1.4f ',nlat),']'];
s = sprintf('%s\n%s',slon,slat);

% Copy output string to clibpoard
clipboard('copy',s)