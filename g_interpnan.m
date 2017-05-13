function y = g_interpnan(x)

% g_interpnan Interpolate linearly over NaN's in a time series
%
%     Y = g_interpnan(X)
%
%     INPUT   x - time series 
%         
%     OUTPUT  y - time series with NaN's interpolated
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 07/08/2013

% Check if no NaN in beginning or end
if isnan(x(1)) || isnan(x(end))
  error('Remove NaN in beginning and end')
end

y = x;

% Find blocks of NaN
xn = isnan(x);
xnd = diff(xn);
x1 = find(xnd==1);
x2 = find(xnd==-1);
% these have to be the same length!

for i = 1:length(x1)
  if x2(i)-x1(i) > 1 % More than one NaN
  y(x1(i)+1:x2(i)) = interp1([x1(i) x2(i)+1],...
                             [x(x1(i)) x(x2(i)+1)],...
                             [x1(i)+1:x2(i)],'linear');
  else
  y(x2(i)) = interp1([x1(i) x2(i)+1],...
                     [x(x1(i)) x(x2(i)+1)],...
                     x2(i));
  end
end
