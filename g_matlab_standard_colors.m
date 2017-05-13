function col = g_matlab_standard_colors(varargin)

% G_MATLAB_STANDARD_COLORS Get Matlab's new standard colors
%
%   COL = g_matlab_standard_colors(n)
%
%   INPUT   n - number of colors (default and max is 7)
%       
%   OUTPUT  col - color matrix
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 05/26/2015

if nargin==0
  n = 7;
else
  n = varargin{1};
end

C = [0         0.4470    0.7410
     0.8500    0.3250    0.0980
     0.9290    0.6940    0.1250
     0.4940    0.1840    0.5560
     0.4660    0.6740    0.1880
     0.3010    0.7450    0.9330
     0.6350    0.0780    0.1840];

col = C(1:n,:);