function s = g_FroudeNumberSingleLayerFormulation(s,bp,it)

% g_FroudeNumberSingleLayerFormulation Calculate bulk Froude number from
%                                      profiles
%
%     S = g_LocalFroudeNumber(S,BP,IT) Calculate the bulk Froude number
%     as described in Girton et al. (2006) from CTD data and LADCP data. 
%
%     INPUT   s  - structure containing the profiles. each structure element
%                  has to be one profile 
%             bp - structure with only one background profile
%             it - isotherm that defines the lower layer
%
%     OUTPUT  s - structure with output data 
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 11/08/2012


bgrho = bp.sigma41;

for i = 1:length(s)
if isnumeric(s(i).station)
  
  x = find(s(i).theta1<it);
  D = length(x);
  V = sqrt(nanmean(s(i).u(x)).^2 + nanmean(s(i).v(x)).^2);

  if length(bgrho)>length(s(i).sigma41)
  rhodash = s(i).sigma41-bgrho(size(s(i).sigma41));
  else
  bgrhotemp = nan(size(s(i).sigma41));
  bgrhotemp(1:length(bgrho)) = bgrho;
  bgrhotemp(length(bgrho)+1:end) = bgrho(end);
  rhodash = s(i).sigma41-bgrhotemp;
  end

  RD = 9.81./(1046.*D).*nanmean(rhodash(x)).*D;
  s(i).RD = RD;
  s(i).D = D;
  s(i).mean_rhodash = nanmean(rhodash(x));
  
  if RD>0
  s(i).Fr = V./sqrt(RD.*D);
  else
  s(i).Fr = NaN;
  end

end
end