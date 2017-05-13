function [plon,plat,ptopo] = g_ss30min(region)
%[LON,LAT,TOPO] = G_SS30MIN Extract bathymetry data for south pacific region.
%
%   [LON,LAT,TOPO] = G_SS3MIN(REGION), where REGION is a four element
%   vector, extracts bathymetry data from a .mat-file with two tiles from
%   the 30-minute Smith&Sandwell bathymetry dataset.

%   REGION: west east south north

%   Data for the following region can be extracted:
%              Latitude          Longitude     
%         Minimum  Maximum   Minimum  Maximum 
%         ----------------   ---------------- 
%           -60       40       -180    -140 

%   G.Voet 03-23-2012


% Set path to the .mat-file
f = ['/Users/gunnar/Data/bathymetry/smith_sandwell/',...
     'ss30minw180w140s60n40.mat'];

load(f)
topo2 = double(topo);
 
[~,jlon] = find(lon>=region(1) & lon<=region(2));
[~,jlat] = find(lat>=region(3) & lat<=region(4));

ptopo = topo2(jlat,jlon);
plat = lat(jlat);
plon = lon(jlon);