function out = g_strucvar2matrix(d,f)

% g_strucvar2matrix Put all vectors of one subvariable into one matrix
%
%     INPUT   d - data structure
%             f - field to be used
%         
%     OUTPUT  out.f - matrix with all data from field f
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 05/09/2013

if ~ischar(f)
  error('field must be string')
end

if ~isfield(d,f)
  error([f,' must be a subvariable of input structure'])
end

% Find maximum length
for i = 1:length(d)
  li(i) = length(d(i).(f));
end
mli = nanmax(li);

out = nan(mli,length(d));
for i = 1:length(d)
  out(1:length(d(i).(f)),i) = d(i).(f);
end