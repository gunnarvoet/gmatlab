function s = g_llstr(lonin,latin)

% g_llstr(x,y) Convert decimal longitude / latitude float to deg/min/sec string
%
%     g_llstr(x,y)
%
%     INPUT   x,y - input longitude and latitude
%
%     OUTPUT  s - output str with longitude and latitude
%
%     Gunnar Voet
%     gvoet@ucsd.edu
%
%     Created: 01/30/2015


lon = lonin;
lat = latin;

if lon>180
  lon = lon-360;
  lonmin = abs(lon-floor(lon))*60;
  lons = sprintf('%03d° %02.3f'' W',abs(floor(lon)),lonmin);
else
  lonmin = abs(lon-floor(lon))*60;
  lons = sprintf('%03d° %02.3f'' E',abs(floor(lon)),lonmin);
end

if lat>0
  latmin = abs(lat-floor(lat))*60;
  lats = sprintf('%03d° %02.3f'' N',abs(floor(lat)),latmin);
else
  latmin = abs(lat-floor(lat))*60;
  lats = sprintf('%03d° %02.3f'' S',abs(floor(lat)),latmin);
end


s = [lats,', ',lons];