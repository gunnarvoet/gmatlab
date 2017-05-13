function g_newscript(filename)

% G_NEWSCRIPT(FILENAME)    Create a new script with a header on the current
%                          path. Pass filename as string without the .m

current_dir = pwd;
dd = datestr(now,23);

fid = fopen([current_dir,'/',filename,'.m'],'a');
fprintf(fid,'%% \n');
fprintf(fid,'%%\n');
fprintf(fid,'%% Gunnar Voet\n');
fprintf(fid,'%% gvoet@ucsd.edu\n');
fprintf(fid,'%%\n');
fprintf(fid,['%% Last modification ',dd,'\n']);
fclose(fid);

edit([filename,'.m']);