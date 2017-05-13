function g_ctd_data2_to_ascii(FileName,OutName)

% G_CTD_DATA2_TO_ASCII Convert 24Hz ctd data to ascii file for wLADCP
%
%   g_ctd_data2_to_ascii(FILENAME) reads the .mat file with the structure
%                                  data2 and writes out an ascii file that
%                                  can be used with Andreas Thurnherr's 
%                                  software for vertical LADCP velocity
%
%   INPUT   FileName - input file path and name
%           OutName  - output file path and name
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 03/16/2016

load(FileName)

% check for modcount errors
dmc = diff(data2.modcount);
mmc = mod(dmc, 256);
% figure; plot(mmc); title('mod diff modcount')
fmc = find(mmc - 1); 
if ~isempty(fmc); 
  disp(['Warning: ' num2str(length(dmc(mmc > 1))) ' bad modcounts']); 
  disp(['Warning: ' num2str(sum(mmc(fmc))) ' missing scans']); 
end

scan = cumsum(mmc);
scan(end+1) = scan(end)+1;

% shouldn't do this
scan = 1:length(data2.t1);

lon = nanmean(data2.lon);
lat = nanmean(data2.lat);

% convert c from S/m to mS/cm^-1
A = [scan(:),data2.p(:),data2.t1(:),data2.c1(:).*10];

% write lat/lon to file

dlmwrite(OutName,[lat,lon],'delimiter',',','precision',10)
dlmwrite(OutName,A,'-append','delimiter',',','precision',10)
% save('-ascii',OutName,'A')