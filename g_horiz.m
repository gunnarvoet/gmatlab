function y = g_horiz(x)

% G_HORIZ Make or vector horizontal
%
%   Y = g_horiz(X) 
%
%   INPUT   x - vector or matrix 
%       
%   OUTPUT  y - vector or matrix longer in the horizontal than the
%               vertical, i.e. more columns than rows.
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 02/16/2014

[m,n] = size(x);
if m>n
  x = x';
end

y = x;