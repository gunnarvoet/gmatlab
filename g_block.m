function g_block(x,y,m,cvec,cmap)

% g_block pcolor-style plot fast, for epsilon from overturns
%
%     g_block(X,Y,M,CVEC,CMAP) makes a pcolor-style plot that works
%     better with printing to pdf than a normal pcolor plot.
%
%     INPUT   x  - vector with x
%             y  -   "         y
%             m    - data matrix
%             cvec - vector with color values
%             cmap - colormap (one smaller than cvec)
%         
%     OUTPUT  [pp - handles to all little rectangles]
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 01/26/2014

% TODO: Have an option for including outliers or not. Right now they are
% moved to the limits of cvec...



% pcolor-style plot that works well with pdf plotting
% cmap must be one smaller than cvec
% leaves out data points at the end of the x and y vectors (should create
% vectors one larger than the matrix that embrace the grid fields.


% Flip cvec to start with smallest value
if cvec(length(cvec))<cvec(1)
  if isrow(cvec)
    fliplr(cvec)
  else
    flipud(cvec)
  end
end


% Find all blocks
for i = 1:length(x)
  
mtmp = m(:,i);
xx = find(~isnan(mtmp));

if ~isempty(xx)
mtmp = mtmp(xx);

[n,na,nb] = blocknum(mtmp);


% Find value index for each block
for j = 1:length(na)
v(j) = mtmp(na(j));
end


% Assign color index to each block
for j = 1:length(na)
ctmp = find(cvec<=v(j),1,'last');
if isempty(ctmp)
  ctmp = 1;   % move small values to min cvec
end
if ctmp==length(cvec)
  ctmp = ctmp-1;
end
c(j) = ctmp;
end

% New x-vector
dx = diff(x);


newx(1) = dx(1)/2;
for ii = 2:length(dx)
newx(ii) = newx(ii-1)+dx(ii-1)/2+dx(ii)/2;
end
newx(end) = newx(end)-dx(end)/2;
newx = [0 newx];

if x(1)~=0
  newx = newx+x(1);
end


% Plot block
for j = 1:length(na)
px = [newx(i) newx(i+1) newx(i+1) newx(i)];
py = y(xx([na(j) na(j) nb(j) nb(j)]));
pp = patch(px,py,'k');
set(pp,'facecolor',cmap(c(j),:),...
            'edgecolor','none',...
            'linestyle','none');
end
end

end


% 
% % Convert value matrix into color index matrix
% % Flip cvec to start with smallest value
% if cvec(length(cvec))<cvec(1)
%   if isrow(cvec)
%     fliplr(cvec)
%   else
%     flipud(cvec)
%   end
% end
% 
% % Create matrix with indices for the color maps
% ci = nan(size(m));
% for i = 1:length(cvec)-1
%     xx = m>=cvec(i) & m<cvec(i+1);
%     ci(xx) = i;
% end
% 
% % Draw rectangles
% for ii = 1:length(x)-1
%   for jj = 1:length(y)-1
%     if ~isnan(ci(jj,ii))
%     ppx = [x(ii) x(ii+1) x(ii+1) x(ii)];
%     ppy = [y(jj) y(jj) y(jj+1) y(jj+1)];
%     h(jj,ii) = patch(ppx,ppy,'k');
%     set(h(jj,ii),'facecolor',cmap(ci(jj,ii),:),...
%                  'edgecolor',cmap(ci(jj,ii),:));
%     end
%   end
% end