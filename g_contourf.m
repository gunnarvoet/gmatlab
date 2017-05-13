function pp = g_contourf(x,y,z,cvec,cmap)

% g_contourf Make contourf plot with own colormap
%     PP = g_contourf(X,Y,Z,CVEC,CMAP) makes a contourf plot using CVEC and
%     CMAP.
%
%     INPUT   x,y  - position along the axes
%             z    - contour matrix
%             cvec - contour limit vector
%             cmap - colormap (length must be one shorter than cvec)
%         
%     OUTPUT  pp   - handle vector for the single patches
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     Last modification: 11/07/2012
%     09/2015


% Find Matlab version number
[ver,~] = version;
pp = strfind(ver,'.');
ver = str2num(ver(1:pp(2)-1));
clear pp

if ver<8.4 % old Matlab graphics system
[~, conhand] = contourf(x,y,z,cvec);
set(conhand,'linestyle','none')
hold on
pp       = get(conhand,'children');
thechild = get(pp,'CData');
cdat     = cell2mat(thechild);
for j = 1:length(cdat)
    xx = find(cvec>cdat(j),1,'first');
    if isnumeric(xx) 
      if xx > 1
      set(pp(j),'facecolor',cmap(xx-1,:))
      else
      set(pp(j),'facecolor','none')
      end
    end
end





else % new Matlab graphics system

% convert cmap to 0:255
cmap = uint8(cmap.*255);
  
[~, conhand] = contourf(x,y,z,cvec);
conhand.LineStyle = 'none';
drawnow
hFills = conhand.FacePrims;

% this should be the same as cvec
levels = conhand.LevelList;
if length(levels)~=length(cvec)
  error('levels~=cvec')
end


minz = nanmin(nanmin(z));
maxz = nanmax(nanmax(z));
cz1 = find(levels<minz,1,'last');
FirstPatchOutside = 0;
if isempty(cz1)
  cz1 = 1;
  FirstPatchOutside = 1;
end




cz2 = find(levels>maxz,1,'first');
extra_hFill = 0;
LastPatchOutside = 0;
if isempty(cz2)
  LastPatchOutside = 1;
  cz2 = find(levels<maxz,1,'last');
  extra_hFill = 1;
end



% need to use conhand.ContourMatrix to identify between which levels the
% contours are
cm = conhand.ContourMatrix;

fl(1) = cm(1,1);
nftmp = 1 + 1 + cm(2,1);
counter = 1;
while nftmp<length(cm(1,:))
  counter = counter+1;
  fl(counter) = cm(1,nftmp);
  nftmp = nftmp+1+cm(2,nftmp);
end
fl2 = unique(fl);

% if length(hFills)==length(fl2)+1
%   idxstart = 1;
% elseif length(hFills)==length(fl2)
%   idxstart = 2;
% else
%   error('fix me!')
% end

% if cz1==1
%   idxstart = 1;
% else
%   idxstart = cz1;
% end

% for idx = 1:numel(fl2)-1
% 
% % hFills(idx).ColorType = 'truecoloralpha';   % default = 'truecolor'
% % hFills(idx).ColorType = 'truecolor';   % default = 'truecolor'
% 
% if idx==1
%   x1 = find(levels==fl2(1));
%   xc = x1;
% elseif idx<=numel(fl2)
%   x1 = find(levels==fl2(idx));
%   xc = x1;
% % elseif idx==numel(fl2)+1
% %   x1 = find(levels==fl2(idx-1));
% %   xc = x1+1;
% end
% 
% % if the color limits are wide enough, all bins will be colored. if they
% % are not, the lower bin will not be colored, but I'm pretty sure the upper
% % one will. thus, compare numel(hFills) to levels and decide from there.
% % then, if the upper one is colored, set it to white.
% 
% 
%   hFills(idx).ColorData(1:3) = cmap(xc,:)';
% 
% end

for idx = 1:numel(hFills)

% hFills(idx).ColorType = 'truecoloralpha';   % default = 'truecolor'
% hFills(idx).ColorType = 'truecolor';   % default = 'truecolor'


% 
% elseif idx<=numel(hFills)
%   x1 = find(levels==fl2(idx));
%   xc = x1;
% end
  

if FirstPatchOutside
  if idx==1
    if cz1==1
      xc = 1;
    else
      xc = cz1;
    end
  elseif idx<numel(hFills)
  x1 = find(levels==fl2(idx));
  xc = x1-1;
  elseif idx == numel(hFills)
    if LastPatchOutside
      xc = numel(levels)-1;
    else
      x1 = find(levels==fl2(idx));
      xc = x1-1;
    end
  end
    

  
elseif ~FirstPatchOutside
  if idx==1
    if cz1==1
      xc = 1;
    else
      xc = cz1;
    end
  elseif idx<numel(hFills)
    x1 = find(levels==fl2(idx));
    xc = x1-1;
  elseif idx == numel(hFills)
    if LastPatchOutside
      xc = numel(levels)-1;
    else
      x1 = find(levels==fl2(idx-1));
      xc = x1;
    end
  end
  
end
  
  

  
  
%   x1 = find(levels==fl2(1));
%   xc = x1;
% elseif idx<=numel(fl2)
%   x1 = find(levels==fl2(idx));
%   xc = x1;
% % elseif idx==numel(fl2)+1
% %   x1 = find(levels==fl2(idx-1));
% %   xc = x1+1;
% end

% if the color limits are wide enough, all bins will be colored. if they
% are not, the lower bin will not be colored, but I'm pretty sure the upper
% one will. thus, compare numel(hFills) to levels and decide from there.
% then, if the upper one is colored, set it to white.


  hFills(idx).ColorData(1:3) = cmap(xc,:)';

end




if extra_hFill
  hFills(end).ColorData(1:3) = uint8([255 255 255]);
end

pp = conhand;

end