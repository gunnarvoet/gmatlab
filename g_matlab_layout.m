function g_matlab_layout(a)

% apply window layout settings
% a = 1: big screen
% a = 0: small screen

% from here:
% http://undocumentedmatlab.com/blog/setting-the-matlab-desktop-layout-programmatically

% to save the layout:
% desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
% desktop.saveLayout('BigScreen')

desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
if a==1
  desktop.restoreLayout('BigScreen');
else
  desktop.restoreLayout('SmallScreen');
end