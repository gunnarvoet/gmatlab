function g_combine_rdi_files(filelist,outfile)

% G_COMBINE_RDI_FILES Combine rdi files
%
%   g_combine_rdi_files(FILELIST,OUTFILE) Read several RDI files and
%   combine them into one new RDI file
%
%   INPUT   filelist - list of file names (cell array)
%           outfile - name of output file (string)
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 2017-04-19

nf = length(filelist);

in = struct;

for i = 1:nf
  fin = fopen(filelist{i},'r','ieee-le'); % open as a little endian
  [in(i).data, in(i).bct] = fread(fin, 'uchar');
  fclose(fin);
end

C = vertcat(in.data);
bct = sum([in.bct]);


% fin=fopen(RDIfile1,'r','ieee-le'); % open as a little endian
% [A,bct] = fread(fin, 'uchar');
% fclose(fin);
% fin=fopen(RDIfile2,'r','ieee-le'); % open as a little endian
% [B,bct2] = fread(fin, 'uchar');
% C = [A;B];
% fclose(fin);


fprintf('\n writing %s\n',outfile)

fid = fopen(outfile, 'wb');
wct = fwrite(fid,C,'uchar');
fclose(fid);

if ~wct==bct
  error('byte count is off')
end

