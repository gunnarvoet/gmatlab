function g_opentoline(fileName, lineNumber, columnNumber)

% G_OPENTOLINE Open to specified line in function file in Sublime.
%            GV: This file is a hack from the original Matlab file.
%            Remove this file from path to get the old functionality back.
%
%   OPENTOLINE(FILENAME, LINENUMBER, COLUMN)
%   LINENUMBER the line to scroll to in the Editor. The absolute value of
%   this argument will be used.
%   COLUMN argument is optional.  If it is not present, the whole line 
%   will be selected.


%% complete the path if it is not absolute
% javaFile = java.io.File(fileName);
% if ~javaFile.isAbsolute
    %resolve the filename if a partial path is provided.
    fileName = char(com.mathworks.util.FileUtils.absolutePathname(fileName));
% end
lineNumber = abs(lineNumber); % dbstack uses negative numbers for "after"

%% open the editor
if nargin == 2
    %just go to a particular line, will silently fail if fileName does not exist
    
%     matlab.desktop.editor.openAndGoToLine(fileName, lineNumber);
    system(sprintf('st %s:%d',fileName,lineNumber))
    
elseif nargin == 3
    system(sprintf('st %s:%d:%d',fileName,lineNumber,columnNumber))
end

