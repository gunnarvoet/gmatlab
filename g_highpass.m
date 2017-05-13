function [sig_out,b,a] = g_highpass(sig,Wn,order)

% G_HIGHPASS   Highpassfilter with a butterworth filter
%
%   [FILTERED_SIGNAL,B,A] = G_HIGHPASS(SIG,WN,ORDER)
%   Input:  SIG   - time series in
%           WN    - bandstop frequency, e.g. 1/50
%                   is a highpass with period 100h
%                   if the sampling frequency of the signal
%                   is one hour
%           ORDER - Order of the filter (integer)
%
%   Output: FILTERED_SIGNAL
%           B,A   - Butterworth filter parameters

[b,a] = butter(order,Wn,'high');
sig_mean = nanmean(sig);
sig_var = sig-sig_mean;
sig_var2 = filtfilt(b,a,sig_var);

sig_out = sig_var2 + sig_mean;