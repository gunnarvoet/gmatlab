function y = g_vert(x)

% G_VERT Make matrix or vector vertical
%
%   Y = g_vert(X) 
%
%   INPUT   x - vector or matrix 
%       
%   OUTPUT  y - vector or matrix longer in the vertical than the
%               horizontal, i.e. more rows than columns.
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 02/16/2014

[m,n] = size(x);
if n>m
  x = x';
end

y = x;