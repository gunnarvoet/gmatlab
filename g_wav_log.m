function    [wave,period,scale,coi,hcbar,signif,fft_theor,over_matrix] = g_wav_log(datain,fig)
%
%   [WAVE,PERIOD,SCALE,COI] = G_WAV(DATAIN,FIGURE)
%
% Nutzt die Funktion wavelet.m aus der
% Toolbox von Torrence und Compo.
%
% DATAIN ist die zu untersuchende Zeitreihe.
% Mit fig kann der figure-Index angegeben werden.
% fig = 0 oeffnet figure(1)
% Ohne das Argument figure wird das zur Zeit
% aktive figure-Fenster verwendet.


addpath /users/ifmnfs3a/voet/auswertung_2002/wavelet_mit_Torrence_compo_toolbox/wavelet/

[wave,period,scale,coi] = wavelet(datain,1,1,.05,2,225,'MORLET');

time=[1/24:1/24:length(datain)/24];

var_datain = var(datain);
if nargin == 2
    if  fig > 0
        eval(['figure(' int2str(fig) ')']);
    else 
    end
elseif nargin == 1
    figure(1);
    clf;
end
imagesc(time,log2(period),log2(((abs(wave).^2))*(1/var_datain) +1));
set(gca,'YDir','normal','YTick',[1,2,3,4,5,6,7,8,9,10,11,12,13],'YTickLabel',[2,4,8,16,32,64,128,256,512,1024,2^11,2^12,2^13]);
hold on;
plot([1/24:1/24:length(coi)/24],log2(coi),'k','LineWidth',3);
hold off;
xlabel('time [days]');
ylabel('pseudo-period computed from scale [hours]');
hcbar=colorbar('horizontal');
werte1=get(hcbar,'XTickLabel');
werte2=str2num(werte1);
werte=2.^werte2;
set(hcbar,'XTickLabel',werte);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Berechnung des 95% Konfidenzintervalls

% lag-1 autocorrelation:
lag = arburg(datain,1);
lag2 = lag(2);
lag3 = abs(lag2);

[signif,fft_theor] = wave_signif(datain,1,scale,1,lag3,0.95,length(datain));

% neue matrix berechnen um im bild die bereiche zu kennzeichnen, die vertrauenswert sind.
einsen=ones(length(wave(:,1)),length(wave(1,:)));
sig_matrix=zeros(length(wave(:,1)),length(wave(1,:)));
for i=1:length(datain);
    sig_matrix(:,i)=signif';
end

% matrix erzeugen mit 1.5 bei werten groesser als confidence, 0 sonst

over_matrix=abs(wave).^2-sig_matrix;

for i=1:length(wave(1,:));
    for j=1:length(wave(:,1));
        if over_matrix(j,i) > 15;
            over_matrix(j,i)=1.5;
        else over_matrix(j,i)=0;
        end
    end
end
hold on;
contour(time,log2(period),over_matrix,[1 1],'k');