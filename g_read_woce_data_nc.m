function ctd = g_read_woce_data_nc(filename)

% Read WOCE hydrographic data
%
% Gunnar Voet, APL - UW - Seattle
% voet@apl.washington.edu
%
% Last modification: 04/03/2012

% Variables
% time
% pressure
% pressure_QC
% temperature
% temperature_QC
% salinity
% salinity_QC
% oxygen
% oxygen_QC
% latitude
% longitude
% woce_date
% woce_time
% station
% cast

% Pressure
wocetime = num2str(ncread(filename,'woce_time'));
if length(wocetime)<2
    wocetime = ['000',wocetime];
elseif length(wocetime)<3
    wocetime = ['00',wocetime];
elseif length(wocetime)<4
    wocetime = ['0',wocetime];
end
wocedate = num2str(ncread(filename,'woce_date'));

dates = [wocedate(1:4),'-',wocedate(5:6),'-',wocedate(7:8),...
         ' ',wocetime(1:2),':',wocetime(3:4),':00'];

ctd.time = datenum(dates);
ctd.times = dates;
ctd.lat = (ncread(filename,'latitude'));
ctd.lon = (ncread(filename,'longitude'));

ctd.station = num2str((ncread(filename,'station')));
ctd.cast = ncread(filename,'cast');

ctd.pressure = repmissval(ncread(filename,'pressure'))';
ctd.temperature = repmissval(ncread(filename,'temperature'))';
ctd.salinity = repmissval(ncread(filename,'salinity'))';
ctd.oxygen = repmissval(ncread(filename,'oxygen'))';

f = strfind(filename,filesep);
if ~isempty(f)
fname = filename(f+1:end);
else
fname = filename;
end
ctd.filename = fname;
ctd.cruisenumber = [];
ctd.cruisename = [];


% Function for replacement of missing value -999 with nan
function datanan = repmissval(data999)
x = data999==-999 | data999==-99;
datanan = data999;
datanan(x) = NaN;