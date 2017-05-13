function pp = g_contour(x,y,z,cvec,cmap)

% g_contourf Make contour plot with own colormap
%     PP = g_contour(X,Y,Z,CVEC,CMAP) makes a contour plot using CVEC and
%     CMAP.
%
%     INPUT   x,y  - position along the axes
%             z    - contour matrix
%             cvec - contour limit vector
%             cmap - colormap (length must be one shorter than cvec)
%         
%     OUTPUT  pp   - handle vector for the single patches
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 11/07/2012

[con conhand] = contourf(x,y,z,cvec);
set(conhand,'linestyle','-')
hold on
pp       = get(conhand,'children');
thechild = get(pp,'CData');
cdat     = cell2mat(thechild);
for j = 1:length(cdat)
    xx = find(cvec>cdat(j),1,'first');
    if isnumeric(xx) 
      if xx > 1
      set(pp(j),'edgecolor',cmap(xx-1,:),'facecolor','none')
      else
      set(pp(j),'edgecolor','none','facecolor','none')
      end
    end
end
