function h = g_hist(n,x)

% G_ Short description
%
%   Y = g_(X) longer description if needed
%
%   INPUT   x - describe 
%       
%   OUTPUT  y - 
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
  h(i) = patch(px,py,'k');
  set(h(i),'facecolor',gr(.5))
end

