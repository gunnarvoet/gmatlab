function h = g_histv(n,x)

% G_HISTV(N,X) Histogram plot with probability on the x-axis
%
%   H = g_histv(N,X) 
%
%   INPUT   n - probability per bin
%           x - bins
%
%           Create n and x with [n,x] = hist(y)
%       
%   OUTPUT  h - handles to the bars
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 01/29/2014


% [nh,xh] = hist(x,n);
nh = n;
xh = x;

for i = 1:length(xh)
  
  if i == 1
  px = [xh(i)-(xh(i+1)-xh(i))./2 xh(i)+(xh(i+1)-xh(i))./2];
  px = [px fliplr(px)];
  elseif i==length(xh)
  px = [xh(i)-(xh(i)-xh(i-1))./2 xh(i)+(xh(i)-xh(i-1))./2];
  px = [px fliplr(px)];
  else
  px = [xh(i)-(xh(i)-xh(i-1))./2 xh(i)+(xh(i+1)-xh(i))./2];
  px = [px fliplr(px)];
  end
  py = [0 0 nh(i) nh(i)];
  hold on
  h(i) = patch(py,px,'k');
  set(h(i),'facecolor',gr(.5))
end

