function [ind val] = g_find_vecneighbours(x,xvec)

% [index values] = g_find_neighbours(x,xvec)
% 
% Find the points in a vector that are located around x
%
% Input: x
%        xvector
%
% Output: ind: Index of the two neighbours
%         val: Values of the two neighbours
%
% Gunnar Voet
% gvoet@ucsd.edu
%
% last modification: 21.06.2007

a  = find(xvec<x);
b  = find(abs(xvec(a)-x) == min(abs(xvec(a)-x)));
x1 = a(b);

clear a b

a  = find(xvec>x);
b  = find(abs(xvec(a)-x) == min(abs(xvec(a)-x)));
x2 = a(b);

clear a b

ind = [x1 x2];

val = [xvec(x1) xvec(x2)];

if isempty(x1) || isempty(x2)
    error('Out of range');
end