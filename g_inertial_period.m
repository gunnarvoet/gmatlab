function Ti = g_inertial_period(phi)

% G_INERTIAL_PERIOD Calculate inertial period
%
%   Ti = g_inertial_period(PHI)
%
%   INPUT   phi - Latitude in degrees
%       
%   OUTPUT  Ti  - Inertial period [days]
%
%   Gunnar Voet, Scripps / UCSD
%   gvoet@ucsd.edu
%
%   Created: 07/31/2014

Omega = 7.292e-5;
f     = 2*Omega*sin(deg2rad(phi));
Ti    = 2*pi/f;
Ti    = Ti./3600./24;

fprintf(1,'\nInertial period at %1.2f° is %1.2f days\n',phi,Ti);