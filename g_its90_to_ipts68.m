function t68 = g_its90_to_ipts68(t90)

% g_its90_to_ipts68 Convert temperature from ITS90 to IPTS68
%
%     T68 = g_its90_to_ipts68(T90)
%
%     INPUT   t90 - Temperature in ITS90
%         
%     OUTPUT  t68 - Temperature in IPTS68
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 06/28/2013

t68 = t90.*1.00024;