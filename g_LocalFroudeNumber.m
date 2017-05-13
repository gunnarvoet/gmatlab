function s = g_LocalFroudeNumber(s,ll,ul)

% g_LocalFroudeNumber Calculate local Froude number from profiles
%     RES = g_LocalFroudeNumber(S,LL,UL) Calculate the local Froude number
%     as described in Baringer & Price (1997) from CTD data and LADCP data
%
%     INPUT   s  - structure containing the profiles. each structure element
%                  has to be one profile 
%             ll - lower layer isotherm definition (one element)
%             ul - upper layer isotherm definition (two elements)
%
%     OUTPUT  res - structure with output data 
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 11/08/2012

LowerLayer = ll;
UpperLayer = ul;

g = 9.8;
rho0 = 1045.8;

for ii = 1:length(s)
if isnumeric(s(ii).station)

sigma4 =  s(ii).sigma41;
theta  =  s(ii).theta1;
z      = -s(ii).z;
u      =  s(ii).u;
v      =  s(ii).v;

xx = find(theta<LowerLayer);
xx2 = find(theta<max(UpperLayer) & theta>min(UpperLayer));

meanubottomlayer = sqrt(nanmean(u(xx)).^2+nanmean(v(xx)).^2);
meanuupperlayer = sqrt(nanmean(u(xx2)).^2+nanmean(v(xx2)).^2);
deltaVsq = (meanubottomlayer-meanuupperlayer).^2;

meanrhobottomlayer = nanmean(sigma4(xx));
meanrhoupperlayer = nanmean(sigma4(xx2));
deltarho = meanrhobottomlayer-meanrhoupperlayer;

H = length(xx);

s(ii).Fr = sqrt((rho0.*deltaVsq)./(g.*H.*deltarho));
s(ii).H = H;
s(ii).deltarho = deltarho;
s(ii).deltaV = sqrt(deltaVsq);
s(ii).xx = xx;
s(ii).xx2 = xx2;

end
end


