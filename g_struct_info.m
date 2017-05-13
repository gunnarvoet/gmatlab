function info = g_struct_info

% G_STRUCT_INFO Add basic information to data structure
%
%   INFO = g_struct_info
%       
%   OUTPUT  info    - Data structure with basic information:
%            .mfile - Name of calling function / mfile
%            .time  - Time when data structure was created
%
%   Use like this: s.info = g_struct_info;
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Last modification: 08/19/2013




% get the name of the calling function
[ST,I] = dbstack('-completenames');
if length(ST)==1
CurrentMFileName = ST(end).file;
else
CurrentMFileName = ST(2).file;
end

% print to pdf, pass the name of the calling function for latex code
info.mfile = CurrentMFileName;
info.time  = ['Created ',datestr(now)];