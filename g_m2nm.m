function distnm = g_m2nm(distm)

% G_M2NM Transform meter to nautical miles
%
%   DISTNM = g_m2nm(DISTM)
%
%   INPUT   distm - Distance in meters
%       
%   OUTPUT  distnm - Distance in nautical miles
%
%   Conversion factor from gsw_distance.m
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/14/2016

distnm = distm./1853.2488;