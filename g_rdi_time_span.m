function [tstart,tend] = g_rdi_time_span(rdi_file)

% G_RDI_TIME_SPAN(rdi_file) extracts start and end time from a raw RDI file
%
%   Uses listEns from Andreas Thurnherr's ADCP tools written in perl...
%
%   [TSTART,TEND] = g_rdi_time_span(RDI_FILE) 
%
%   INPUT   rdi_file - path and name of RDI file
%       
%   OUTPUT  tstart - start time
%           tend   - end time
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 07/11/2016



% Get ensemble info using Andreas' file
[status,cmdout] = system(sprintf('listEns %s > tmp',rdi_file));

% Get first ensemble info line
[status,cmdout] = system('head -n 3 tmp > tmp2');
[status,cmdout] = system('tail -n 1 tmp2 > tmpstart');

% Get last ensemble info line
[status,cmdout] = system('tail -n 1 tmp > tmpend');

% Get start time
fid = fopen('tmpstart');
C = textscan(fid,'%n %s %s %s %f %f %f %f %n %s %s');
fclose(fid);
strstart = strcat(C{2},{' '},C{3});
tstart = datenum(strstart);

% Get end time
fid = fopen('tmpend');
C = textscan(fid,'%n %s %s %s %f %f %f %f %n %s %s');
fclose(fid);
strend = strcat(C{2},{' '},C{3});
tend = datenum(strend);

% Remove tmp files
!rm tmp
!rm tmp2
!rm tmpend
!rm tmpstart