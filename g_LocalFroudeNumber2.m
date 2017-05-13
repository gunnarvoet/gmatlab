function s = g_LocalFroudeNumber2(s,ll,ul)

% g_LocalFroudeNumber Calculate local Froude number from profiles
%     RES = g_LocalFroudeNumber(S,LL,UL) Calculate the local Froude number
%     as described in Baringer & Price (1997) from CTD data and LADCP data
%
%     This is a modified version from g_LocalFroudeNumber. The density
%     difference is still calculated between lower and upper layer, but the
%     velocity is only taken from the lower layer. See James email with
%     notes on this from 2013/05/15:
%
% One thing that just occurred to me is that maybe we really should be
% computing F using the *absolute* (not difference) velocity of the lower
% layer along with the density difference across the interface (say, rho
% below 0.8 C minus avg rho between 0.8 and 1.0C). This is closer to the
% ratio between flow speed and wave speed that we are after (for diagnosing
% the potential for arrested waves). Can you try making this small change
% (i.e., turn v1-v2 in your 2-layer formula into just v1, but keep
% everything else the same)? It probably won't change the picture too much,
% but might make the value slightly higher or lower in places. I like the
% set of interface choices (0.75-0.9C) and the different choices for the
% upper layer.
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
% deltaVsq = (meanubottomlayer-meanuupperlayer).^2;
deltaVsq = (meanubottomlayer).^2;

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


