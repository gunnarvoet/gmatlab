function z = g_harmonic(y,f,T)
%
% Harmonic Analysis Function
%
% Enter Data in y, list of frequencies, and period T
% Examples: Y=sin(2*pi*10*(1:40)/500); 
%           Y=sin(2*pi*10*(1:40)/500)-0.5*cos(2*pi*3*(1:40)/500);
%           harm(Y,[5 10 15 20],.08)
%
N=length(y);
M=length(f);
alpha=f*T;

% Compute the matrices of trigonometric functions

% This just creates sine and cosine vectors with frequencies f
% and the length of the signal. -> frequency thus means cycles per whole
% signal length?
n=1:N;
C=cos(2*pi*alpha'*n/N);
S=sin(2*pi*alpha'*n/N);


c_row=ones(1,N)*C';
s_row=ones(1,N)*S';
D(1,1)=N;
D(1,2:M+1)=c_row;
D(1,M+2:2*M+1)=s_row;
D(2:M+1,1)=c_row';
D(M+2:2*M+1,1)=s_row';
D(2:M+1,2:M+1)=C*C';
D(M+2:2*M+1,2:M+1)=S*C';
D(2:M+1,M+2:2*M+1)=C*S';
D(M+2:2*M+1,M+2:2*M+1)=S*S';
yy(1,1)=sum(y);
yy(2:M+1)=y*C';
yy(M+2:2*M+1)=y*S';
z=D^(-1)*yy';