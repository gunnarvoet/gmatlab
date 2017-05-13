function overlap = g_time_overlap(ta,tb)

% G_TIME_OVERLAP Calculate time overlap in days
%
%   overlap = g_time_overlap(TA,TB)
%
%   INPUT   ta - two element vector for first time span
%           tb - --------"--------- for second time span
%       
%   OUTPUT  overlap - overlap in days
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 09/04/2015

% Make sure both input vectors have two elements
if length(ta)~=2
  error('ta must be two elements (start and end time of time span');
elseif ~any(size(tb))
  error('tb must be a 2 element vector or 2xn or nx2 matrix');
end

% loop over tb if it is more than one timespan
if sum(size(tb))>3
  nb = max(size(tb));
  % make sure tb is in column format
  tb = g_vert(tb);
  LoopB = 1;
else
  nb = 1;
  LoopB = 0;
end

overlap = nan(nb,1);

for i = 1:nb
  tbi = tb(i,:);
  % collect start and end times
  tstart = [min(ta) min(tbi)];
  tend   = [max(ta) max(tbi)];
  
  overlap(i) = min(tend)-max(tstart);
end

overlap(overlap<0) = 0;