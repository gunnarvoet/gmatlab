function h = g_setaxlim(xdata,ydata,varargin)

% g_setaxlim Set limits of x- and y-axis
%     H = g_setaxlim(XDATA,YDATA) Automatically set the limits of x and y
%     axis by giving vectors of data that are supposed to be seen
%     completely. The handle of the axis can optionally be given.
%
%     INPUT   xdata - Vector that is supposed to set the xlimit. This can
%                     either be a data vector or an artificial 2 element
%                     vector.
%             ydata - The same in y direction.
%             h     - Axis handle (optional).
%         
%     OUTPUT  h - Handle to axis
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 07/03/2012

if nargin<3
  h = gca;
else
  h = varargin{1};
end

if ~isempty(xdata)
lx = nanmax(xdata)-nanmin(xdata);
xlimit = [nanmin(xdata)-lx./10 nanmax(xdata)+lx./10];
set(h,'xlim',xlimit)
end

if ~isempty(ydata)
ly = nanmax(ydata)-nanmin(ydata);
ylimit = [nanmin(ydata)-ly./10 nanmax(ydata)+ly./10];
set(h,'ylim',ylimit)
end