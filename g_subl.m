function g_subl(file)

% G_SUBL(FILE) Open file in Sublime Text Editor. File has to be on current path
%
%   g_subl(FILE)
%
%   INPUT   file - str with the file name
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 02/14/2014

cwd = pwd;

if isempty(strfind(file,filesep))
  file = [cwd,filesep,file];
end

if ~strcmp(file(end-1),'.') | ~strcmp(file(end-3),'.')
  file = [file,'.m'];
end

sysstr = ['open -a /Applications/Sublime\ Text.app/Contents/MacOS/Sublime\ Text ''',file,''' '];
% sysstr = sprintf('sublime %s',file);

% Changed the sublime command to the common zsh alias
% sysstr = sprintf('st %s',file);
system(sysstr);