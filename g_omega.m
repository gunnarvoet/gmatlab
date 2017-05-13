function omega = g_omega

% G_OMEGA Return earth rotation rate omega [radian/s] using the gsw toolbox
%       
%   OUTPUT  omega - earth rotation rate in radian/s
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 01/22/2016

omega = gsw_f(90)/2;