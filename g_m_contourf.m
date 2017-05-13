function pp = g_m_contourf(lon,lat,z,cvec,cmap)

% g_m_contourf Make contourf plot with own colormap on an m_map
%     PP = g_m_contourf(LON,LAT,Z,CVEC,CMAP) makes a contourf plot using
%     CVEC and CMAP.
%
%     INPUT   lon,lat  - position vectors
%             z        - contour matrix
%             cvec     - contour limit vector
%             cmap     - colormap (length must be one shorter than cvec)
%         
%     OUTPUT  pp       - handle vector for the single patches
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 11/25/2012

[con conhand] = m_contourf(lon,lat,z,cvec);
set(conhand,'linestyle','none')
hold on
pp       = get(conhand,'children');
thechild = get(pp,'CData');
cdat     = cell2mat(thechild);
for j = 1:length(cdat)
    xx = find(cvec>cdat(j),1,'first');
    if isnumeric(xx) 
      if xx > 1
      set(pp(j),'facecolor',cmap(xx-1,:))
      else
      set(pp(j),'facecolor','none')
      end
    end
end
