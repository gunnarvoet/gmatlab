function out = g_bathy_section_rudnick(lon,lat,res)

% Extract bathymetry along sections defined by lon/lat coordinates
% This version uses Rudnick's bathy data.
%
% INPUT   lon - vector with longitudes
%         lat -             latitudes
%         res - resolution in kilometers
%
% OUTPUT  out - structured array with following variables
%            .ilon      - longitudes along section interpolated to res 
%            .ilat      - latitudes
%            .idist     - distance between points defined by ilon/ilat [km]
%            .itopo     - depth at points ilon/ilat [m]
%            .olon      - input longitudes
%            .olat      -       latitudes
%            .odist     - distance between input points
%            .otopo     - depth at input points
%            .res       - input resolution res
%
% Gunnar Voet
% gvoet@ucsd.edu
%
% Updated: 06/14/2015

% Check for equal lengths of input position vectors
if length(lon)~=length(lat)
    error('Longitude and Latitude must be of the same size!')
end

% if nargin<3
load(['/Users/gunnar/Projects/samoan_passage/bathymetry/',...
    'samoan_passage_bathymetry_200m_greater_region.mat']);
plon = bathy2.lon;
plat = bathy2.lat;
ptopo = -bathy2.mbrud;
clear bathy2
% else
% plon = varargin{3};
% plat = varargin{4};
% ptopo = varargin{5};
% end

% if nargin<6
% res = 1;
% else
% res = varargin{6};
% end

% Interpolated points
ilat = [];
ilon = [];

% Original points
odist = 0;
olat = lat;
olon = lon;

if length(lat)>1
% Create evenly spaced points between lon and lat
for i = 1:length(lon)-1
    
    dist = sw_dist(lat(i:i+1),lon(i:i+1),'km');
    n = dist/res;
    
    dlon = lon(i+1)-lon(i);
    if dlon~=0
    deltalon = dlon/n;
    lons = lon(i):deltalon:lon(i+1);
    else
    lons = repmat(lon(i),1,ceil(n));
    end
    ilon = [ilon lons];
    
    dlat = lat(i+1)-lat(i);
    if dlat~=0
    deltalat = dlat/n;
    lats = lat(i):deltalat:lat(i+1);
    else
    lats = repmat(lat(i),1,ceil(n));
    end
    ilat = [ilat lats];
    
    if i == length(lon)-1
        ilon = [ilon olon(end)];
        ilat = [ilat olat(end)];
    end
    
    odist = [odist odist(end)+dist];
    
    clear lons lats deltalat deltalon dlon dlat n dist
end

itopo = interp2(plon,plat,ptopo,ilon,ilat);
idist = [0 cumsum(sw_dist(ilat,ilon,'km'))];

out.ilon = ilon;
out.ilat = ilat;
out.idist = idist;
out.itopo = itopo;
end

otopo = interp2(plon,plat,ptopo,olon,olat);

out.olon = olon;
out.olat = olat;
out.odist = odist;
out.otopo = otopo;

out.res = res;

