function [f,P] = g_sine_spec(data,samplefreq,K)

%   [f,P] = g_sine_spec(data,samplefreq,K) takes an input velocity 
%   vector 'data' (complex), sample frequency in samples per day, K 
%   multitapers (generally 10), and returns a sine multitaper 
%   spectrum P with frequency vector f.   
%   
%   when plotting, loglog(f,P,-f,P) to see both sides.

%   Adapted from MySineTaper

indg = find(~isnan(data));
data = data(indg);
N    = length(data);
nfft = N;
u    = real(data);
v    = imag(data);
u    = detrend(u,'constant');
v    = detrend(v,'constant');
rex  = complex(u,v);
A    = ones(N,K);

for k=1:K;
	A(:,k) = ((2/(N+1))^(1/2)*sin(((k)*pi*(1:N))/(N+1)))';
	A(:,k) = A(:,k).*rex;  %this gives us h*X in the formula.  
end

fta   = fft(A);
msftA = (1/samplefreq)*(abs(fta)).^2;
sumk  = sum(msftA,2)./K;  

dz    = 1/samplefreq;
dk    = (1/N)/dz;
%This is not quite right if N is odd...  fix.  mha 6/25/99
if rem(N,2)==0
  k = -N/2*dk:dk:N/2*dk-dk;
else
	kp = dk:dk:dk*floor(N/2);
	k  = [fliplr(-kp) 0 kp];
end

f   = k;
Pa  = sumk';
mid = ceil(length(k)/2);
P1  = Pa(mid:length(Pa));
P2  = Pa(2:mid);
P   = [P1 P2];
