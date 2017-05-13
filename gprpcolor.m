function gprpcolor(filename)
%GPR(FILENAME) Print figure as pdf via eps
%   input filename as a string, without file extension
%   and view it in Apples Preview


% get the name of the calling function
[ST,I] = dbstack;
CurrentMFileName = ST(end).file;

% print to pdf, pass the name of the calling function for latex code
g_pdfpcolor(filename,CurrentMFileName)

g_prvw(filename)
end

