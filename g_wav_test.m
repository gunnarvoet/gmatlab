function    [wave,period,scale,coi] = g_wav_test(datain)
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

clf

[wave,period,scale,coi] = wavelet(datain,24,1,.05);

time=[1/24:1/24:length(datain)/24];

cov_datain = cov(datain);

imagesc(time,log(period),log(abs(wave).^2));
set(gca,'YDir','normal');
hold on;
plot([1/24:1/24:length(coi)/24],log(coi),'k','LineWidth',1);
xlabel('time [days]');
ylabel('pseudo-period computed from scale [hours]');
hcbar=colorbar;