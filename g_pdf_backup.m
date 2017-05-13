function g_pdf(filename,CurrentMFilename)

% g_pdf Print figure to pdf file
%     g_pdf(S) Print figure to pdf file with filename S.
%
%     INPUT   s - Filename (string) without file extension
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 04/03/2013

print('-depsc',[filename,'.eps'])
% fixPSlinestyle([filename,'.eps'],[filename,'.eps']);
system(['pstopdf ',filename,'.eps']);
system(['rm ',filename,'.eps']);

% Output text for inclusion of the file into latex document

% Figure and path name
CurrentPath = pwd;
if ~strcmp(CurrentPath(end),filesep)
  CurrentPath = [CurrentPath,filesep];
end
FullFigureName = [CurrentPath,filename,'.pdf'];

dispstr = sprintf('\n');
disp(dispstr)
disp('\begin{figure}[htbp]')


disp('\centering')

% File
dispstr = ['\includegraphics[width=1.0\textwidth]{',FullFigureName,'}'];
disp(dispstr)

disp('\caption{ }')

% Label - This filename excluding any folder.
x = strfind(filename,filesep);
if ~isempty(x)
  x = x(end);
  filename = filename(x+1:end);
end
dispstr = ['\label{fig:',filename,'}'];
disp(dispstr)

disp('\end{figure}')

dispstr = ['% Created with ',...
           CurrentMFilename,...
           ' ',...
           datestr(now,'mm/dd/yy HH:MM')];
disp(dispstr)

dispstr = sprintf('\n');
disp(dispstr)


end

