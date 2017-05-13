function a = g_cutstruct(a,ii)
% function a=cutstruct(a,ii)
%
% reduce array size in structure


% get length of all fields
if isstruct(a)
  fnames = fieldnames(a);
  for n=1:size(fnames,1)
    dummy = getfield(a,fnames{n});
    [ly,lx]=size(dummy);
    fieldlength(n) = max([ly,lx]);
  end
else
  error('first argument must be a structure')
end

% create index vector with ones and zeros if not given yet
if max(ii)>1
  newii = zeros(1,max(fieldlength));
  newii(ii) = 1;
  ii = newii;
end

lz = length(ii);
iok = find(ii==1);

% cut structure
if isstruct(a)
  fnames = fieldnames(a);
  for n=1:size(fnames,1)
    dummy = getfield(a,fnames{n});
    [ly,lx]=size(dummy);
    if ly==lz
      a=setfield(a,fnames{n},dummy(iok,:));
    elseif lx==lz
      a=setfield(a,fnames{n},dummy(:,iok));
    end
  end
else
  error('first argument must be a structure')
end
