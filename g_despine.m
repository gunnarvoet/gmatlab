function [ax,nax] = g_despine(ax,offset)

% G_DESPINE Move x and y axis away from origin
%
%   nax = g_depsine(AX)
%
%   INPUT   ax - axis to despine (optional, default gca)
%           offset - offset (fraction of longer axis, optional,
%                            default 0.01)
%
%   OUTPUT  ax - handle to plot axis
%           nax - handle to spine axis (nax(1:2)) and grid axis (nax(3))
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/22/2015

if nargin==0
  ax = gca;
end

if nargin<2
  offset = 0.01;
end

fig = gcf;

set(ax,'visible','off')

XLim = ax.XLim;
YLim = ax.YLim;
XDir = ax.XDir;
YDir = ax.YDir;
XTick = ax.XTick;
YTick = ax.YTick;

Pos = ax.Position;
FPos = fig.PaperPosition;
fxyratio = (FPos(3)-FPos(1))/(FPos(4)-FPos(2));

XLabel = ax.XLabel.String;
YLabel = ax.YLabel.String;

FontSize = ax.FontSize;

% calculate offset as offset*x or *y, depending on which is larger
xp = Pos(3);
yp = Pos(4);
if xp > yp
xoffset = offset*xp;
yoffset = offset*xp*fxyratio;
else
yoffset = offset*yp;
xoffset = offset*xp/fxyratio;
end

nax(1) = axes('position',[Pos(1)-xoffset Pos(2) 0.00001 Pos(4)],...
              'ylim',YLim,'TickDir','out','ydir',YDir);
nax(2) = axes('position',[Pos(1) Pos(2)-yoffset Pos(3) 0.00001],...
              'xlim',XLim,'TickDir','out','xdir',XDir);
            
nax(3) = axes('position',Pos,'visible','off','xlim',XLim,'ylim',YLim,...
              'xdir',XDir,'ydir',YDir);
hold on
for i = 1:length(XTick)
  plot(repmat(XTick(i),1,2),YLim,'color',gr(.8),'linewidth',0.5)
end
for i = 1:length(YTick)
  plot(XLim,repmat(YTick(i),1,2),'color',gr(.8),'linewidth',0.5)
end
uistack(nax(3),'bottom')

nax(1).YLabel.String = YLabel;
nax(2).XLabel.String = XLabel;

for i = 1:2
  nax(i).FontSize = FontSize;
  nax(i).TickLength = [0 0];
end