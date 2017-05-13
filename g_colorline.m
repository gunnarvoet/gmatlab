function h = g_colorline(x, y, c, cvec, cmap)



hold on


% Assign colormap indices to c2
c2 = zeros(size(c));
for i = 1:length(cvec)-1
  xi = find(c>=cvec(i) & c<=cvec(i+1));
  if isnumeric(xi)
  c2(xi) = i;
  end
end

xi = find(c2~=0);
nx = x(xi);
ny = y(xi);
nc2 = c2(xi);

dnc2 = diff(nc2);
[n,a,b] = blocknum(dnc2(:));
for j = 1:length(a)
    if j==1
    plot(nx(a(j):b(j)),ny(a(j):b(j)),'color',cmap(nc2(a(j)),:))
    elseif nc2(a(j))==max(nc2)
    plot(nx(a(j):b(j)),ny(a(j):b(j)),'color',cmap(nc2(a(j)),:))
    else
    plot(nx(a(j)-1:b(j)),ny(a(j)-1:b(j)),'color',cmap(nc2(a(j)),:))
    end
end