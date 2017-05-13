function xout = g_split_up_dn(p,eps,deltax,sanity_check)

% G_SPLIT_UP_DN Split a time series at its maxima, minima or both
%
%   XI = g_split_up_dn(X)
%
%   INPUT   x - Input vector
%           eps - minimum delta y at points close to zero
%           deltax - minimum distance between extrema in index points 
%       
%   OUTPUT  xout - Indices of split points
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 06/09/2016
%
% TODO: Modify for maxima and minima only

if nargin<4
  sanity_check=0;
end

% low-pass filter p
lp = g_lowpass(p,1/deltax,3);

dlp = diff(lp);
dlp(end) = 0;
ddlp = diff(dlp);
ddlp(end+1) = 0;

% find diff lp close to zero
[dz] = find(abs(dlp)<eps);

% Difference between points close to zero
ddz = diff(dz);
ddz(end+1) = 0;

% At least deltax minutes between extrema
xdz = find(ddz>deltax);
% Now I have one point in each stretch
xdzi = dz(xdz);

% Now see if these points are minima in their neighborhood
count = 0;
dtp = deltax; % +/- around the point

for i = 1:length(xdzi)
  xi = xdzi(i);
  xii = xi-dtp:xi+dtp;
  
  % Remove outliers in the index vector
  xx = find(xii<1|xii>length(p));
  if ~isempty(xx)
  xii(xx) = [];
  end
  
  ptmp = p(xii);

  [pmin pmini] = nanmin(ptmp);
  [pmax pmaxi] = nanmax(ptmp);

  % local minimum
  if ptmp(1)>p(xi)+eps && ptmp(end)>p(xi)+eps
    count = count+1;
    splitpoint(count) = xii(pmini);
  % local maximum as well
  elseif ptmp(1)<p(xi)-eps && ptmp(end)<p(xi)-eps
    count = count+1;
    splitpoint(count) = xii(pmaxi);
  end

end


if ~exist('splitpoint','var')
  xout = [];

else
figure(1)
clf
plot(p)
set(gca,'ydir','reverse')
hold on
plot(lp,'k.')
% plot(xdzi,p(xdzi),'g*')
plot(splitpoint,p(splitpoint),'r*')

% Translate back to full depth time series
split_out = splitpoint;
splits = split_out;
splits_p = p(split_out);
% split_filestart = Vel.mtime(1);
% split_fileend   = Vel.mtime(end-2); % sometimes last time stamp is zero
% splits = [split_filestart, splits, split_fileend];
% splits_p = [0 splits_p 0];

% splitfile = fullfile(pp.procdir,'ladcp_mat',sprintf('yoyo_%03d_splits.mat',ladcp_castnr));

% % Only save points if no existing splitfile lives there. Otherwise load.
% if exist(splitfile,'file')==2  && LoadExistingSplitfile
%   fprintf(' Loading existing splitfile\n')
%   load(splitfile)
%   allok = 1;
% else
%   save(splitfile,'splits','ptime','splits_p','split_filestart','split_fileend')
%   allok = 0;
% end

if sanity_check
  allok = 0;
while allok==0
commandwindow
xin = input('\n are these split points ok [1] or not ok [2]?\n','s');
fprintf('\n')
if isempty(xin)
  xin = 1;
else
  xin = str2num(xin);
end
if xin==1
  fprintf(' accepting split points\n\n');
  allok = 1;
else
  fprintf(' You have the following options:\n')
  xin2 = input(['\n [1] add point manually\n',...
                ' [2] remove point manually\n',...
                ' [3] change point\n',...
                ' [any other key] quit\n'],'s');
  fprintf('\n')
  if str2num(xin2)==1    % Add point
    fprintf('Click to add a split point\n')
    [x,y] = ginput(1);
    splits_old = splits;
    splits = [splits(:);round(x)];
    [splits, si] = sort(splits);
    splits_p_new = p(round(x));
    splits_p = [splits_p(:);splits_p_new];
    splits_p = splits_p(si);
    figure(1)
    clf
    plot(p)
    set(gca,'ydir','reverse')
    hold on
    plot(splits,splits_p,'k*')
    plot(x,splits_p_new,'r*')
    zoom on


  elseif str2num(xin2)==2    % Remove point
    fprintf('Click to remove one or more split points\n')
    [x,y] = ginput(1);
    splits_old = splits;
    xi = near(splits,x);
    xp = splits_p(xi);
    splits(xi) = [];
    splits_p(xi) = [];
    figure(1)
    clf
    plot(p)
    set(gca,'ydir','reverse')
    hold on
    plot(splits,splits_p,'k*')
    htmp = plot(x,xp,'r*');
    zoom on

    fprintf(' Removed red split point\n')
    pause(0.5)
    set(htmp,'visible','off')


  elseif str2num(xin2)==3    % Change point
    fprintf(' For now remove and add in two steps...')

  else
    error('You are in trouble now!')
  end

end
end % while allok == 0
end % sanity check

xout = splits;

end

end % function