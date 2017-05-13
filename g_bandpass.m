function sig_filt = g_bandpass(sig,Wn,order)
%
% sig_filt = g_bandpass(sig,Wn,order)
% 
% Bandpass filter for a time series. The mean is removed from the signal.
%
% Input: sig: Input time series
%        Wn:  Stop frequencies, e.g. for stop periods 200 and 36 hours,
%             Wn = [1/100 1/18] if the input time series values have a
%             spacing of one hour.
%        order: Filter order. 3 is a good choice in the DS study.
%
% Output: sig_filt: Filtered time series
%
% Gunnar Voet
% gvoet@ucsd.edu
%
% last modification: 20.08.2009


%% Create the filter parameters
[b,a] = butter(order,Wn);

%% Remove the mean from the signal

sz = size(sig);
if sz(1)>1
sig = sig';
end

sig_mean = nanmean(sig);
sig2 = sig-sig_mean;


%% Split the time series if NaN's are in it
x = isnan(sig2);      % Find the NaN's

if ~isempty(find(x, 1))

xd = diff(x);        % Find transitions between NaN and not NaN

x2 = find(xd);

if isempty(x2)
sig_filt = sig2;  % If all input values are NaN;
else

n = length(x2)+1;    % Number of pieces the time series is splitted into

c(1).split = sig2(1:x2(1)); % Split into pieces
if n>2
for i = 2:n-1
c(i).split = sig2(x2(i-1)+1:x2(i));
end
end
c(n).split = sig2(x2(end)+1:end);

for i = 1:n
c(i).t = ~isnan(c(i).split(1));   % Create a mask with 1 for pieces with
                                  % data and 0 for pieces with NaN
end

d = find([c.t]);

for i = 1:n
if c(i).t == 1
    c(i).f = filtfilt(b,a,c(i).split);
else
    c(i).f = c(i).split;
end
end

% Put the pieces together back again

sig_filt = [c.f];
end
else
sig_filt = filtfilt(b,a,sig2);
end

% EXAMPLE
% % 10 days, time every second
% t = 0:1/24/3600:6;
% 
% % some kind of diurnal tidal signal
% y = sin(t*(2*pi))+randn(size(t))/10;
% % and some signal at 17 hours interval
% y2 = sin( t / ( (17/24)/(2*pi) ) ) + randn(size(t))/10;
% 
% % subsample at 10 min interval
% t10min = t(1:60*10:end);
% y10min = y(1:60*10:end);
% y210min = y2(1:60*10:end);
% 
% % combine the two signals
% yy = y10min+y210min;
% 
% % bandpass filter the 10 minute version around 17 hours
% y210minf = g_bandpass(yy, [1/(19/2 * 6), 1/(15/2 * 6)], 1);
% 
% figure(1)
% clf
% plot(t10min,yy)
% hold on
% plot(t10min,y210min,'color',repmat(0.8,1,3))
% plot(t10min,y210minf,'k')