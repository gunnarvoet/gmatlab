function h = g_m_prect(x,y,m,cvec,cmap)

% g_m_prect pcolor-style plot for m_map
%
%     H = g_m_prect(LON,LAT,M,CVEC,CMAP) makes a pcolor-style plot on a
%     m_map that works better with printing to pdf than a normal pcolor
%     plot.
%
%     INPUT   lon  - vector with longitudes
%             lat  -   "         latitudes
%             m    - data matrix
%             cvec - vector with color values
%             cmap - colormap (one smaller than cvec)
%         
%     OUTPUT  h    - handles to all little rectangles
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 07/03/2012

% pcolor-style plot that works well with pdf plotting
% cmap must be one smaller than cvec
% leaves out data points at the end of the x and y vectors (should create
% vectors one larger than the matrix that embrace the grid fields.

% Convert value matrix into color index matrix
% Flip cvec to start with smallest value
if cvec(length(cvec))<cvec(1)
  if isrow(cvec)
    fliplr(cvec)
  else
    flipud(cvec)
  end
end

% Create matrix with indices for the color maps
ci = nan(size(m));
for i = 1:length(cvec)-1
    xx = m>=cvec(i) & m<cvec(i+1);
    ci(xx) = i;
end

% Draw rectangles
for ii = 1:length(x)-1
  for jj = 1:length(y)-1
    if ~isnan(ci(jj,ii))
    ppx = [x(ii) x(ii+1) x(ii+1) x(ii)];
    ppy = [y(jj) y(jj) y(jj+1) y(jj+1)];
    h(jj,ii) = m_patch(ppx,ppy,[0 0 0]);
    set(h(jj,ii),'facecolor',cmap(ci(jj,ii),:),...
                 'edgecolor',cmap(ci(jj,ii),:));
    end
  end
end