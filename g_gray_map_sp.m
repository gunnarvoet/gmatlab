function g_gray_map_sp

% g_gray_map Plot a gray basemap of the Samoan Passage region
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 12/24/2012

% Load bathymetry
spf = spfolders;
load(spf.bathy.low)

% Set region limits
latlim = [-10.4 -7.25];
lonlim = [-170.75 -168.25];

% Create colormap
cvec = -6000:250:-2000;
cmap = flipud(cbrewer('seq','Greys',length(cvec)+2-1));
cmap = cmap(1+2:end,:);

% Map projection
m_proj('mercator','longitudes',lonlim,'latitudes',latlim);

hold on

% Contourf bathymetry
pp = g_m_contourf(bathy2.lon,bathy2.lat,-bathy2.merged,cvec,cmap);
% Contour 4500m isobath
% [c2,h2]=m_contour(bathy2.lon,bathy2.lat,-bathy2.merged,[-4500 -4500]);
% set(h2,'color','k','linestyle','-')

% Axis settings
m_grid('box','fancy','linewi',1,'tickdir','in','fontsize',9);