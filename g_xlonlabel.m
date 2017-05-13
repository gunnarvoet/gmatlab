function g_xlonlabel(ax)

% g_xlonlabel(x) Convert xticklabel to longitude
%
%     g_xlonlabel(AX)
%
%     INPUT   ax - axes to be changed
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 05/26/2013

xl = mat2strs(get(ax,'xticklabel'));
for i = 1:length(xl)
  xln = str2num(xl{i});
  if xln>180
    xln = xln-360;
    xl{i} = [num2str(abs(xln)),'°W'];
  else
    xl{i} = [num2str(xln),'°E'];
  end
end
set(ax,'xticklabel',xl)
xlabel('Longitude')