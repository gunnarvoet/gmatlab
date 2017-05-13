function pp = g_scatter(x,y,s,z,cvec,cmap)

% g_scatter Scattter plot with own colormap
%     PP = g_scatter(X,Y,S,Z,CVEC,CMAP) makes a scatter plot using
%     CVEC and CMAP.
%
%     INPUT   x,y      - position vectors
%             s        - size of circles
%             z        - vector with values
%             cvec     - contour limit vector
%             cmap     - colormap (length must be one shorter than cvec)
%         
%     OUTPUT  pp       - handle vector for the single points
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 04/19/2013

for i = 1:length(x)
  if z(i) >= min(cvec) && z(i) <= max(cvec)
  [xi,~] = near(cvec,z(i),2);
%   if xi==length(cvec);
%     xi=xi-1;
%   end
  xi = min(xi);
  pp(i) = plot(x(i),y(i));
  set(pp(i),'linestyle','none',...
            'markerfacecolor',cmap(xi,:),...
            'markeredgecolor',cmap(xi,:),...
            'markersize',s,...
            'marker','o')
  else
  pp(i) = plot(NaN,NaN);
  end
end