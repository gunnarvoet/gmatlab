function out = g_etopo30s(lon,lat)

% Extract bathymetry from ETOPO 30s for a region defined by lon/lat
%
% INPUT   lon - vector with longitudes
%         lat -             latitudes
%
% OUTPUT  out - structured array with following variables
%            .lon      - longitudes of the grid
%            .lat      - latitudes
%            .topo     - depth at points ilon/ilat [m]
%
% Gunnar Voet, APL - UW - Seattle
% voet@apl.washington.edu
%
% Last modification: 09/11/2013


% Check for equal lengths of input position vectors
if length(lon)~=2 || length(lat) ~=2
    error('Longitude and Latitude must have two elements each!')
end

lon2 = lon;
if nanmin(lon2)<0
  lon2(lon2<0) = lon2(lon2<0)+360;
end

% Create subgrid from the big ETOPO database
tempfile = '/Users/gunnar/scratch/tempbathy.grd';
tempcoordinates = sprintf(' -R%03d/%03d/%03d/%03dr',floor(nanmin(lon2)),...
                                                floor(nanmin(lat)),...
                                                ceil(nanmax(lon2)),...
                                                ceil(nanmax(lat)));
cc1 = ['system(''gmt grdcut /Users/gunnar/Data/bathymetry/smith_sandwell/topo30.grd -G',...
      tempfile,tempcoordinates,''')'];
eval(cc1);

% Read subgrid and convert to double
cc2 = ['[plon,plat,ptopo] = grdread2(''',tempfile,''');'];
eval(cc2);

% Convert back to negative longitudes
if nanmin(lon)<0
  plon(plon>180) = plon(plon>180)-360;
end
ptopo = double(ptopo); %#ok<*NODEF>

% Remove subgrid file
cc3 = ['!rm ',tempfile];
eval(cc3);
% Remove gmt.history
system('rm gmt.history')

out.lon  = plon;
out.lat  = plat;
out.topo = ptopo;