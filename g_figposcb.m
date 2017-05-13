function g_figposcb

% g_figposcb Get position of current figure and copy to clipboard
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 03/21/2013

p = get(gcf,'position');

s = ['set(gcf,''position'',[',num2str(p),'])'];

% disp(s)
clipboard('copy',s)