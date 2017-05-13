function ctd = g_thorpe_overturns_ferron_style(ctd)

% ctd = tn305_thorpe_overturns(ctd) Calculate epsilon and k_rho from overturns
%
%     CTD = tn305_thorpe_overturns(CTD) calculates Thorpe length scales and
%     turbulent dissipation from overturns using different methods:
%
%     ma: Matthew's overturn toolbox
%     gl: Glenn's algorithm
%     sm: Simple method (10m average, no overturn detection)
%     fm: Ferron et al. (1998)
%
%     INPUT   ctd - Structure with ctd data. 
%         
%     OUTPUT  ctd - Structure with ctd data, profiles of Thorpe length
%                   scale and turbulent dissipation added.
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 01/16/2014

% Own method
ctd.fm  = own_thorpe(ctd,'t');
ctd.fmd = own_thorpe_dense(ctd,'d');

end


%% Here come the subfunctions, one for each method

%% Glenn's method following Ferron et al. (1998)
function outown = own_thorpe(ctd,dvar)

zo = ctd.z;

% Exclude any nan's in potential temperature, salinity and potential
% density
x  = find(~isnan(ctd.sg) & ~isnan(ctd.s) & ~isnan(ctd.th));
t  = ctd.t(x);
th = ctd.th(x);
s  = ctd.s(x);
p  = ctd.p(x);
sg = ctd.sg(x);
Z  = ctd.z(x);
cn2 = ctd.n2(x);

% Sort density or temperature?
if strcmp(dvar,'d')
[Ds,Is] = sort(sg); % is there a difference between using sigma_4
                           % and sigma_0?
elseif strcmp(dvar,'t')
% Create an intermediate temperature profile
tnoise = 0.001;
T0 = 28;
tht = T0-th(1);
n = tht./tnoise;
n = round(n);
thi(1) = T0+n*tnoise;
for i = 2:length(th)
  tht = th(i)-thi(i-1);
  n = tht./tnoise;
  n = round(n);
  thi(i) = thi(i-1)+n*tnoise;
end
thi = thi(:);
[Ds,Is] = sort(thi,1,'descend');
end

TH      = Z(Is) - Z;
cumTH   = cumsum(TH);
aa      = find(cumTH <2);
b       = consec_blocks(aa,2); % this actually searches for the blocks
                               % between the overturns

% Sort temperature and salinity for calculating the buoyancy frequency
Ts   = t(Is);
Ss   = s(Is);

% Loop through detected overturns
% and calculate Thorpe Scales, N2 and dT/dz over the overturn
THsc = nan(size(Z));
N2   = nan(size(Z));
CN2  = nan(size(Z));
DTDZ = nan(size(Z));

outown.idx = zeros(length(zo),1);

for jdo = 1:size(b,1)-1
  
  idx = b(jdo,2):b(jdo+1,1);
  outown.idx(x(idx)) = 1;
  % RMS of all displacements in overturn
  sc  = sqrt(mean(TH(idx).^2));
  ctdn2 = nanmean(cn2(idx));
  % Buoyancy frequency calculated over the overturn from sorted profiles
  n2  = sw_bfrq([Ss(idx(1)) Ss(idx(end))],[Ts(idx(1)) Ts(idx(end))], ...
                [p(idx(1)) p(idx(end))],...
                ctd.lat);
  % Vertical temperature gradient
  ext = 5; % Extend outside the overturn
  if idx(1)>1+ext
    tidx1 = idx(1)-ext;
  else
    tidx1 = idx(1);
  end
  deepest_value = find(~isnan(th),1,'last');
  if idx(end)<deepest_value-ext
    tidx2 = idx(end)+ext;
  else
    tidx2 = idx(end);
  end
  dtdz = (th(tidx1)-th(tidx2))./(Z(tidx1)-Z(tidx2));
  
  
  THsc(idx) = sc; % Fill depth range of the overturn with the Thorpe scale
  N2(idx)   = n2; % Fill depth range of the overturn with N^2
  CN2(idx)  = ctdn2; % Fill depth range of the overturn with average 10m N^2
  DTDZ(idx) = dtdz; % Fill depth range of the overturn with dt/dz
  
  clear sc n2 ctdn2 dtdz
end

% Calculate epsilon
THepsilon        = 0.9*THsc.^2.*sqrt(N2).^3;
THepsilon(N2<=0) = nan;
THk              = 0.2.*THepsilon./N2;

% Calculate the vertical heat flux
THQ = 1028.*4217.*THk.*DTDZ;

% Put data into output array
outown.z    = zo;
outown.eps  = nan(length(zo),1);
outown.k    = nan(length(zo),1);
outown.n2   = nan(length(zo),1);
outown.Lt   = zeros(length(zo),1);
outown.dtdz = nan(length(zo),1);
outown.Q    = nan(length(zo),1);
% outown.thi        = nan(length(zo),1);

% outown.thi(x)        = thi;
outown.eps(x)  = THepsilon;
outown.k(x)    = THk;
outown.n2(x)   = N2;
outown.Lt(x)   = THsc;
outown.dtdz(x) = DTDZ;
outown.Q(x)    = THQ;

end


%% Glenn's method following Ferron et al. (1998) - using density
function outown = own_thorpe_dense(ctd,dvar)

zo = ctd.z;

% Exclude any nan's in potential temperature, salinity and potential
% density
x  = find(~isnan(ctd.sg) & ~isnan(ctd.s) & ~isnan(ctd.th));
t  = ctd.t(x);
th = ctd.th(x);
s  = ctd.s(x);
p  = ctd.p(x);
sg = ctd.sg(x);
Z  = ctd.z(x);
cn2 = ctd.n2(x);

% Sort density or temperature?
if strcmp(dvar,'d')
% % % [Ds,Is] = sort(sg); % is there a difference between using sigma_4
% % %                            % and sigma_0?
% Create an intermediate density profile
dnoise = 0.001;
D0 = 40;
sgt = D0-sg(1);
n = sgt./dnoise;
n = round(n);
sgi(1) = D0+n*dnoise;
for i = 2:length(sg)
  sgt = sg(i)-sgi(i-1);
  n = sgt./dnoise;
  n = round(n);
  sgi(i) = sgi(i-1)+n*dnoise;
end
sgi = sgi(:);
[Ds,Is] = sort(sgi,1,'ascend');

elseif strcmp(dvar,'t')
% Create an intermediate temperature profile
tnoise = 0.001;
T0 = 28;
tht = T0-th(1);
n = tht./tnoise;
n = round(n);
thi(1) = T0+n*tnoise;
for i = 2:length(th)
  tht = th(i)-thi(i-1);
  n = tht./tnoise;
  n = round(n);
  thi(i) = thi(i-1)+n*tnoise;
end
thi = thi(:);
[Ds,Is] = sort(thi,1,'descend');
end

TH      = Z(Is) - Z;
cumTH   = cumsum(TH);
aa      = find(cumTH <2);
b       = consec_blocks(aa,2); % this actually searches for the blocks
                               % between the overturns

% Sort temperature and salinity for calculating the buoyancy frequency
Ts   = t(Is);
Ss   = s(Is);

% Loop through detected overturns
% and calculate Thorpe Scales, N2 and dT/dz over the overturn
THsc = nan(size(Z));
N2   = nan(size(Z));
CN2  = nan(size(Z));
DTDZ = nan(size(Z));

outown.idx = zeros(length(zo),1);

for jdo = 1:size(b,1)-1
  
  idx = b(jdo,2):b(jdo+1,1);
  outown.idx(x(idx)) = 1;
  % RMS of all displacements in overturn
  sc  = sqrt(mean(TH(idx).^2));
  ctdn2 = nanmean(cn2(idx));
  % Buoyancy frequency calculated over the overturn from sorted profiles
  n2  = sw_bfrq([Ss(idx(1)) Ss(idx(end))],[Ts(idx(1)) Ts(idx(end))], ...
                [p(idx(1)) p(idx(end))],...
                ctd.lat);
  % Vertical temperature gradient
  ext = 20; % Extend outside the overturn
  if idx(1)>1+ext
    tidx1 = idx(1)-ext;
  else
    tidx1 = idx(1);
  end
  deepest_value = find(~isnan(th),1,'last');
  if idx(end)<deepest_value-ext
    tidx2 = idx(end)+ext;
  else
    tidx2 = idx(end);
  end
  dtdz = (th(tidx1)-th(tidx2))./(Z(tidx1)-Z(tidx2));
  
  
  THsc(idx) = sc; % Fill depth range of the overturn with the Thorpe scale
  N2(idx)   = n2; % Fill depth range of the overturn with N^2
  CN2(idx)  = ctdn2; % Fill depth range of the overturn with average 10m N^2
  DTDZ(idx) = dtdz; % Fill depth range of the overturn with dt/dz
  
  clear sc n2 ctdn2 dtdz
end

% Calculate epsilon
THepsilon        = 0.9*THsc.^2.*sqrt(N2).^3;
THepsilon(N2<=0) = nan;
THk              = 0.2.*THepsilon./N2;

% Calculate the vertical heat flux
THQ = 1028.*4217.*THk.*DTDZ;

% Put data into output array
outown.z    = zo;
outown.eps  = nan(length(zo),1);
outown.k    = nan(length(zo),1);
outown.n2   = nan(length(zo),1);
outown.Lt   = zeros(length(zo),1);
outown.dtdz = nan(length(zo),1);
outown.Q    = nan(length(zo),1);
% outown.thi        = nan(length(zo),1);

% outown.thi(x)        = thi;
outown.eps(x)  = THepsilon;
outown.k(x)    = THk;
outown.n2(x)   = N2;
outown.Lt(x)   = THsc;
outown.dtdz(x) = DTDZ;
outown.Q(x)    = THQ;

end