function out = g_fit_normal_distribution(x,varargin)

% G_FIT_NORMAL_DISTRIBUTION Fit a normal distribution to data
%
%   Y = g_(X) longer description if needed
%
%   INPUT   x - data
%       
%   OUTPUT  y - 
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 08/3/2014

CreatePlot = 0;
if nargin>1
  if ischar(varargin{1}) && strcmp(varargin{1},'plot')
    CreatePlot = 1;
  end
end

% Create x-axis for histogram and output of normal distribution fit
rx = [min(x) max(x)];
xx = rx(1):abs(diff(rx))/20:rx(2);



[nh,xh] = hist(x,xx);
nh2 = nh./sum(nh);

[muhat,sigmahat] = normfit(x);
fprintf('---------------------------\n')
fprintf('mean:                  %1.2f\n',muhat)
fprintf('2 standard deviations: %1.2f\n',2*sigmahat)
fprintf('---------------------------\n')
y = normpdf(xx,muhat,sigmahat);
y = y/sum(y);

out.mu = muhat;
out.sigma = sigmahat;
out.xx = xx;
out.yy = y;
out.nh = nh2;
out.xh = xh;
out.PlotInfoHist = 'h = g_hist(out.nh,out.xh);';
out.PlotInfoFit  = 'h = plot(out.xx,out.yy);';

if CreatePlot
  figure
  [nh,xh] = hist(x,xx);
  nh2 = nh./sum(nh);
  h = g_hist(nh2,xh);
  hold on
  hpn = plot(xx,y,'color','k','linewidth',1);
end