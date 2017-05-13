function S = g_structstr2charmat(s,var)

% S = g_structstr2charmat(s) Convert strings in a structure to a matrix
% with characters
%
%     Y = g_(X) longer description if needed
%
%     INPUT   s - structure
%             var - structure variable (str)
%         
%     OUTPUT  S - character matrix
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 07/03/2013

for i = 1:length(s)
nl(i) = length(s(i).(var));
end
maxl = max(nl);

S = repmat(blanks(maxl),length(s),1);

for i = 1:length(s)
strtemp = s(i).(var);
S(i,1:length(strtemp)) = strtemp;
clear strtemp
end