function g_pdfpcolor(filename,CurrentMFilename)

%G_PDF(FILENAME) Print figure as pdf via eps
%   input filename as a string, without file extension

print('-depsc','-painters',[filename,'.eps'])
% fixPSlinestyle([filename,'.eps'],[filename,'.eps']);
system(['pstopdf ',filename,'.eps']);

system(['rm ',filename,'.eps']);


% output text for inclusion of the file into latex document for taking
% notes
CurrentPath = pwd;
if ~strcmp(CurrentPath(end),filesep)
  CurrentPath = [CurrentPath,filesep];
end
FullFigureName = [CurrentPath,filename,'.pdf'];

dispstr = sprintf('\n');
disp(dispstr)
disp('\begin{figure}[t]')
dispstr = ['\includegraphics[width=1.0\textwidth]{',FullFigureName,'}'];
disp(dispstr)
dispstr = ['\caption{ \footnotesize{Created with ',...
           CurrentMFilename,'}}'];
disp(dispstr)
dispstr = ['\label{fig:',filename,'}'];
disp(dispstr)
disp('\end{figure}')
dispstr = sprintf('\n');
disp(dispstr)

end

