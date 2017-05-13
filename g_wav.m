function    [wave,period,scale,coi] = g_wav(datain,fig)
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

cov_datain = cov(datain);
if nargin == 2
    if  fig > 0
        eval(['figure(' int2str(fig) ')']);
    else 
    end
elseif nargin == 1
    figure(1);
    clf;
end
imagesc(time,log2(period),log(abs(wave).^2)/cov_datain^2);
set(gca,'YDir','normal','YTick',[1,2,3,4,5,6,7,8,9,10,11,12,13],'YTickLabel',[2,4,8,16,32,64,128,256,512,1024,2^11,2^12,2^13]);
hold on;
plot([1/24:1/24:length(coi)/24],log2(coi),'k','LineWidth',3);
hold off;
xlabel('time [days]');
ylabel('pseudo-period computed from scale [hours]');
hcbar=colorbar