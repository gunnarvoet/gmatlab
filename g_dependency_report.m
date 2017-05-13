function out = g_dependency_report(MFile)

% G_DEPENDENCY_REPORT List all dependencies function or script
%
%   out = g_dependency_report(MFile) list dependencies of function or
%                                    script.
%
%   INPUT   MFile - function or script name (string)
%       
%   OUTPUT  out - structure with path and file names of dependencies
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 09/21/2015

out = matlab.codetools.requiredFilesAndProducts(MFile);

fprintf(1,'\nThese are the dependencies for %s:\n',MFile);
for i = 1:length(out)
  fprintf(1,'%s\n',out{i});
end