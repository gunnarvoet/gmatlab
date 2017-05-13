function pp = g_m_scatter(lon,lat,s,z,cvec,cmap,varargin)

% g_m_scatter Scattter plot with own colormap on an m_map
%     PP = g_m_scatter(LON,LAT,S,Z,CVEC,CMAP) makes a contourf plot using
%     CVEC and CMAP.
%
%     INPUT   lon,lat  - position vectors
%             s        - size of circles
%             z        - contour matrix
%             cvec     - contour limit vector
%             cmap     - colormap (length must be one shorter than cvec)
%             peg      - set data outside of range to range limit
%                        (optional)
%         
%     OUTPUT  pp       - handle vector for the single points
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 04/02/2013

if nargin == 7
  peg = varargin{1};
elseif nargin == 6
  peg = 0;
end

if peg
  cmap(cmap<min(cvec)) = min(cvec);
  cmap(cmap>max(cvec)) = max(cvec);
end

for i = 1:length(lon)
  if z(i) >= min(cvec) && z(i) <= max(cvec)
  [xi,~] = near(cvec,z(i),2);
  xi = min(xi);
  pp(i) = m_plot(lon(i),lat(i));
  set(pp(i),'linestyle','none',...
            'markerfacecolor',cmap(xi,:),...
            'markeredgecolor',cmap(xi,:),...
            'markeredgecolor','none',...
            'markersize',s,...
            'marker','o')
  else
  pp(i) = plot(NaN,NaN);
  end
end