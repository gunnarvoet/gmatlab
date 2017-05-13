function [c,h,cvec,cmap] = g_ezcf(x,y,z,cvec,cmap,peg)

% g_ezcf Make a pcolor-like plot with contourf
%     [C,H] = g_ezcf(X,Y,Z,CVEC,CMAP,PEG)
%
%     INPUT   X - 
%         
%     OUTPUT   
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 10/31/2012

%//////////////////////////////////////////////////////////////////////////
% adapted from function ezcf:
%function ax=ezcf(x,y,z,clim,ncolors);
%4/09 MHA
%Make a pcolor-like plot with contourf.
%//////////////////////////////////////////////////////////////////////////


if ~isrow(cvec)
  cvec = cvec';
end

clim = [cvec(1) cvec(end)];

if length(cmap(:,1))-length(cvec) == 1;
  peg = 4;
end

if peg == 1
  %'peg' values out of range
  z(z<clim(1)) = clim(1);
  z(z>clim(2)) = clim(2);
elseif peg == 2
  % extend colormap to mark out of range values grey
  cmap = [.2 .2 .2;cmap;.8 .8 .8];
  z(z<clim(1)) = clim(1)-abs(diff(cvec(1:2)));
  z(z>clim(2)) = clim(2)+abs(diff(cvec(end-1:end)));
  cvec = [clim(1)-abs(diff(cvec(1:2))),...
          cvec,...
          clim(2)+abs(diff(cvec(end-1:end)))];
elseif peg == 4
  % colormap was already extended!
  % now map values out of range to edge colors!
  z(z<clim(1)) = clim(1)-abs(diff(cvec(1:2)));
  z(z>clim(2)) = clim(2)+abs(diff(cvec(end-1:end)));
  cvec = [clim(1)-abs(diff(cvec(1:2))),...
          cvec,...
          clim(2)+abs(diff(cvec(end-1:end)))];
end

[c,h] = contourf(x,y,z,cvec);
set(h,'edgecolor','none');

ppcol       = get(h,'children');
thechildcol = get(ppcol,'CData');   
cdatcol     = cell2mat(thechildcol);
for j = 1:length(cdatcol)
    if cdatcol(j)<=max(cvec) && cdatcol(j)>=min(cvec)
      xx = find(cvec>=cdatcol(j),1,'first');
      if ~isempty(xx) && xx<length(cvec)
        set(ppcol(j),'facecolor',cmap(xx,:))
      elseif xx==length(cvec)
        set(ppcol(j),'facecolor',cmap(xx-1,:))
      end
    else
      set(ppcol(j),'facecolor','none','edgecolor','none')
    end
end