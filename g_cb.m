function g_cb(x)

% G_CB(x)
%
%   Copy data from vector x to clipboard as a string 
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 01/28/2014


% Create strings
str = ['[', sprintf('%1.3f ',x),']'];
% s = sprintf('%s\n%s');


% Copy output string to clibpoard
clipboard('copy',str)