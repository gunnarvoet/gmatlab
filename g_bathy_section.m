function out = g_bathy_section(lon,lat,res,ext)

% out = G_BATHY_SECTION(lon,lat,res,ext)
%
% Extract Samoan Passage bathymetry along sections defined by lon/lat
% coordinates.
%
% INPUT   lon - vector with longitudes
%         lat -             latitudes
%         res - resolution in kilometers (optional, default 1km)
%         ext - extension in kilometers (optional, default 0). will
%               extrapolate linearly using the first and last three points
%               of lon and lat. idist is 0 where odist is 0, so one of the
%               extensions has negative distances.
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

% Gunnar Voet
% gvoet@ucsd.edu
%
% Created 07/2012
% Updated 09/2015 Make resolution optional, default 1
% Updated 09/2015 Add option for extension of bathy on both sides of line


% Check for equal lengths of input position vectors
if length(lon)~=length(lat)
    error('Longitude and Latitude must be of the same size!')
end

if nargin<3
  res = 1;
  fprintf('\n g_bathy_section: Using default resolution of 1 km\n');
  ext = 0; % no extension
elseif nargin<4
  ext = 0;
end


% % Original points
% odist = 0;
% olat = lat;
% olon = lon;


% Extend lon and lat if ext>0
if ext
  
  % Fit start and end separately if more than 4 points are given. Otherwise
  % fit all together
  
  if length(lon)<5
  bfit = polyfit(lon,lat,1);
  if lon(1)<lon(end)
    elon = [lon(1)-1 lon(end)+1];
  else
    elon = [lon(1)+1 lon(end)-1];
  end
  blat = polyval(bfit,elon);
  nlon = [elon(1) lon elon(end)];
  nlat = [blat(1) lat blat(end)];
  
  else
  bfit1 = polyfit(lon(1:3),lat(1:3),1);
  bfit2 = polyfit(lon(end-2:end),lat(end-2:end),1);
  if lon(1)<lon(3)
    elon1 = [lon(1)-1 lon(1)];
  else
    elon1 = [lon(1)+1 lon(1)];
  end
  if lon(end-2)<lon(end)
    elon2 = [lon(end) lon(end)+1];
  else
    elon2 = [lon(end) lon(end)-1];
  end
  
  blat1 = polyval(bfit1,elon1);
  blat2 = polyval(bfit2,elon2);
  nlon = [elon1(1) lon elon2(2)];
  nlat = [blat1(1) lat blat2(2)];
    
  end
  
  
  lon = nlon;
  lat = nlat;
end


% Original points (but including extension if there is any)
odist = 0;
olat = lat;
olon = lon;


% Load bathymetry
spf = spfolders;      % Get SP paths
load(spf.bathy.high); % Load high resolution bathy
plon = bathy2.lon;
plat = bathy2.lat;
ptopo = -bathy2.merged;
clear bathy2


% Interpolated points
ilat = [];
ilon = [];

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
out.ext = ext;


% Extension specific
if ext
  % Remove offset in distance between the two bathymetries
  out.olon  = out.olon(2:end-1);
  out.olat  = out.olat(2:end-1);
  out.otopo = out.otopo(2:end-1);
  offset = out.odist(2)-out.odist(1);
  out.odist = out.odist(2:end-1)-offset; % set to zero at inital lon(1)
  out.idist = out.idist - offset;

  % Remove NaN-part of out.itopo
  x = find(~isnan(out.itopo));
  out.itopo = out.itopo(x);
  out.idist = out.idist(x);
  out.ilon  = out.ilon(x);
  out.ilat  = out.ilat(x);

  % Remove part outside the extension
  x = find(out.idist>=-ext &...
           out.idist<=out.odist(end)+ext);
  out.itopo = out.itopo(x);
  out.idist = out.idist(x);
  out.ilon  = out.ilon(x);
  out.ilat  = out.ilat(x);
end

