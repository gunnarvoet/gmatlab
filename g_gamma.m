function [SA, CT, gamma] = g_gamma(t, s, p, lon, lat)

% G_ Short description
%
%   Y = g_(X) longer description if needed
%
%   INPUT   x - describe 
%       
%   OUTPUT  y - 
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 2017-04-23



% Step 1. calculate Absolute Salinity, SA = gsw_SA_from_SP(SP, p, long, lat)
% Step 2. calculate Conservative Temperature, ? = gsw_CT_from_t(SA, t, p).

SA = gsw_SA_from_SP(s, p, lon, lat);
CT = gsw_CT_from_t(SA, t, p);

