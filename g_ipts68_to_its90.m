function t90 = g_ipts68_to_its90(t68)

% g_ipts68_to_its90 Convert temperature from IPTS68 to ITS90
%
%     T68 = g_ipts68_to_its90(T90)
%
%     INPUT   t68 - Temperature in IPTS68
%         
%     OUTPUT  t90 - Temperature in ITS90
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 06/28/2013

t90 = t68.*0.99976;