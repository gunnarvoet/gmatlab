function g_adcp_plot(Vel,fig,varargin)

if nargin>2
  YLIM = varargin{1};
else
  YLIM = [];
end

if nargin>3
  clev = varargin{2};
else
  clev = -0.1:0.01:0.1;
end


clim = g_range(clev);

figure(fig)
clf
ax(1) = subaxis(2,1,1);
% [~,hh] = contourf(Vel.dtnum,Vel.z,Vel.u,clev);
% set(hh,'linestyle','none')
pcolor(Vel.dtnum,Vel.z,Vel.u)
shading flat
hold on
plot(Vel.dtnum,Vel.xducer_depth,'k')
colormap(jodyredblue)
caxis([clim])
colorbar

ax(2) = subaxis(2,1,2);
% [~,hh] = contourf(Vel.dtnum,Vel.z,Vel.v,clev);
% set(hh,'linestyle','none')
pcolor(Vel.dtnum,Vel.z,Vel.v)
shading flat
hold on
plot(Vel.dtnum,Vel.xducer_depth,'k')
colormap(jodyredblue)
caxis([clim])
colorbar

linkaxes(ax)

set(ax,'ydir','reverse')

% set to max pressure but do not include any spikes or overshooting
maxp = ceil(prctile(Vel.xducer_depth,99.95)./10).*10;

for i = 1:length(Vel.z)
  hasdata(i) = ~isempty(find(~isnan(Vel.u(i,:))));
end

minp = floor(prctile(Vel.xducer_depth,0.05)./10).*10;
if isempty(YLIM)
  set(ax,'ylim',[minp maxp])
else
  set(ax,'ylim',YLIM)
end

set(ax,'xlim',[min(Vel.dtnum) max(Vel.dtnum)])

axes(ax(1))
title(sprintf('%s %s',Vel.info.MooringID,Vel.info.snADCP))

tlabel('Reference','none')
axes(ax(2))
tlabel

set(ax,'xgrid','on','ygrid','on')

% set(fig,'PaperSize',[30 30],'PaperPosition',[0 0 15 7])
g_fpp(15,7)
