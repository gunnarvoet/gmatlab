function h = g_density_contours(d,f,pref)

% h = G_DENSITY_CONTOURS(d)
%
%   H = g_density_contours(D) plots density contours on the current plot
%
%   INPUT   d - range of density contours to plot
%           f - figure # (optional, default current figure)
%           pref - reference pressure for density (default 0)
%       
%   OUTPUT  h - handle to contours
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 09/15/2015
%   Updated: 10/23/2015

if nargin<3
  pref = 0;
end

xlim = get(gca,'xlim');
ylim = get(gca,'ylim');
ca = caxis;

x = floor(min(xlim)):0.01:ceil(max(xlim));
y = floor(min(ylim)):0.01:ceil(max(ylim));

[X,Y] = meshgrid(x,y);
Z = sw_pden(X,Y,zeros(size(X)),pref)-1000;

if exist('f','var')
  figure(f)
end

hold on
[c,h] = contour(X,Y,Z,d);
set(h,'color',gr(.5));
clabel(c,h,'labelspacing',300)

set(gca,'xlim',xlim,'ylim',ylim)
caxis(ca);