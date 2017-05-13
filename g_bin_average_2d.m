function [xout,yout,zout,zvar,zn,fitout] = g_bin_average_2d(x,y,z,xgrid,ygrid,dtnum)

% G_BIN_AVERAGE_2D Bin-average a 2D field
%
%   [XOUT,YOUT,ZOUT,ZVAR,ZN,FITOUT] = g_bin_average_2d(x,y,z,xgrid,ygrid) takes the field z at
%   coordinates x and y and averages into xgrid and ygrid where xgrid and
%   ygrid give the bin edges. The bin centers are output in xout and yout.
%   The input field can either be a matrix or a vector.
%
%   INPUT   x,y,z - input field
%           xgrid, ygrid - output grid
%           dtnum - optional: supply the time vector for M2 tidal fits.
%       
%   OUTPUT  xout,yout,zout - output field
%           zvar - variance of the bin mean
%           zn - number of obs in bin mean
%           fitout - structure with tidal fit. empty if no input time
%                    vector supplied
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 06/07/2016

if nargin<6
  dtnum = 0;
end

xin = x;
yin = y;
zin = z;

if size(z)~=size(x)
  error('x and z need to be the same size');
elseif size(z)~=size(y)
  error('y and z need to be the same size');
end

% Reshape to 1D
[n,m] = size(z);
if n~=1 && m~=1
  z = reshape(zin,1,[]);
  x = reshape(xin,1,[]);
  y = reshape(yin,1,[]);
end

% remove nan's
zi = ~isnan(z);
z = z(zi);
x = x(zi);
y = y(zi);

zout = nan(length(ygrid)-1,length(xgrid)-1);
if dtnum~=0
  fitout.amp = zout;
  fitout.per = zout;
  fitout.phase = zout;
  fitout.offset = zout;
  fitout.resid = zout;
end



for i = 1:length(xgrid)-1
  for j = 1:length(ygrid)-1
    xi = x>=xgrid(i) & x<xgrid(i+1) & y>=ygrid(j) & y<ygrid(j+1);
    zout(j,i) = nanmean(z(xi));
    zvar(j,i) = nanvar(z(xi));
    zn(j,i) = sum(xi);
    
    if dtnum~=0
      if sum(xi)>3 && max(dtnum(xi))-min(dtnum(xi))>7/24
        [su,xpu,fitu,residu] = fit_sine(dtnum(xi),z(xi),'per',12.4/24,'doplot',0,'xref',datenum(2016,6,5,0,0,0));
        fitout.amp(j,i) = su(1);
        fitout.per(j,i) = su(4);
        fitout.phase(j,i) = su(3);
        fitout.offset(j,i) = su(2);
        fitout.resid(j,i) = residu;
      end
    else
      fitout = [];
    end
    
  end
end

xout = xgrid(1:end-1)+diff(xgrid)./2;
yout = ygrid(1:end-1)+diff(ygrid)./2;

[xout,yout] = meshgrid(xout,yout);