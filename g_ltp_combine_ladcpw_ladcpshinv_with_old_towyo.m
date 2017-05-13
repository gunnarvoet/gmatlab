function tm = g_ltp_combine_ladcpw_ladcpshinv_with_old_towyo(year,ladcp_castnr)

% Combine ladcpw and ladcp shear-inverse results with existing towyo data
% structures.
% Make sure to set base paths below
Path2012 = '/Users/gunnar/scratch/new_towyo_processing/';
Path2014 = '/Users/gunnar/scratch/towyo_processing_sp14/';

spf = spfolders;

% Get year right
if year==2012
  yr = 'sp12';
elseif year==2014
  yr = 'sp14';
elseif strcmp(year,'sp12')
  yr=year;
elseif strcmp(year,'sp14')
  yr=year;
end

% lookup list for 2014 towyos
if strcmp(yr,'sp14')
switch ladcp_castnr
  case 11
    ty = 'ty01';
  case 12
    ty = 'ty01';
  case 24
    ty = 'ty02';
  case 25
    ty = 'ty03';
  case 27
    ty = 'ty04';
  case 28
    ty = 'ty05';
  case 29
    ty = 'ty06';
  case 30
    ty = 'ty07';
  case 34
    ty = 'ty08';
  case 35
    ty = 'ty09';
  case 36
    ty = 'ty10';
  case 41
    ty = 'ty11';
  case 46
    ty = 'ty13';
  case 50
    ty = 'ty14';
  case 51
    ty = 'ty15';
  case 52
    ty = 'ty16';
  case 61
    ty = 'ty17';
  case 62
    ty = 'ty18';
  case 63
    ty = 'ty19';
  case 64
    ty = 'ty20';
end
end

% Load existing towyo structure
if strcmp(yr,'sp12')
load(spf.(yr).(sprintf('towyo%d',ladcp_castnr)))
BaseDir = Path2012;
elseif strcmp(yr,'sp14')
load(spf.(yr).towyo.(ty))
BaseDir = Path2014;
end


% % % % pp = ladcp_towyo_processing_parameters;

load(fullfile(BaseDir,'tylist.mat'),'tylist')

tyind = find(tylist==ladcp_castnr,1,'first');
tmp = 100+tyind*2;

% Load shearinv
load(fullfile(BaseDir,sprintf('proc_shinv/%03dshinv.mat',ladcp_castnr)))
t = shearinv;
clear shearinv


%% Load w
fn = {'dc_depth','dc_w','uc_depth','uc_w','profile_id'};
dul = dir(fullfile(BaseDir,sprintf('ladcpw/ty%03d/UL/*.wprof',tmp)));
for i = 1:length(dul)
  a = loadANTS(fullfile(BaseDir,sprintf('ladcpw/ty%03d/UL/%s',tmp,dul(i).name)));
  for j = 1:length(fn)
  tmpu(a.profile_id).(fn{j}) = a.(fn{j});
  end
end
ddl = dir(fullfile(BaseDir,sprintf('ladcpw/ty%03d/DL/*.wprof',tmp)));
for i = 1:length(ddl)
  a = loadANTS(fullfile(BaseDir,sprintf('ladcpw/ty%03d/DL/%s',tmp,ddl(i).name)));
  for j = 1:length(fn)
  tmpv(a.profile_id).(fn{j}) = a.(fn{j});
  end
end

fn2 = {'depth','hab','dc_w','uc_w','profile_id'};
dall = dir(fullfile(BaseDir,sprintf('ladcpw/ty%03d/ALL/*.wprof',tmp)));
for i = 1:length(dall)
  a = loadANTS(fullfile(BaseDir,sprintf('ladcpw/ty%03d/ALL/%s',tmp,dall(i).name)));
  for j = 1:length(fn2)
  tmpall(a.profile_id).(fn2{j}) = a.(fn2{j});
  end
end


%% Interpolate w to shear inverse structure
for i = 1:length(tmpu)
  xi = find(~isnan(tmpu(i).dc_depth));
  if ~isempty(xi)
  t(2*i-1).w_ul = interp1(tmpu(i).dc_depth(xi),tmpu(i).dc_w(xi),t(2*i-1).z);
  else
  t(2*i-1).w_ul = nan(size(t(2*i-1).z));
  end
  xi = find(~isnan(tmpu(i).uc_depth));
  if ~isempty(xi)
  t(2*i).w_ul = interp1(tmpu(i).uc_depth(xi),tmpu(i).uc_w(xi),t(2*i).z);
  else
  t(2*i).w_ul = nan(size(t(2*i-1).z));
  end
end
for i = 1:length(tmpv)
  xi = find(~isnan(tmpv(i).dc_depth));
  if ~isempty(xi)
  t(2*i-1).w_dl = interp1(tmpv(i).dc_depth(xi),tmpv(i).dc_w(xi),t(2*i-1).z);
  else
  t(2*i-1).w_dl = nan(size(t(2*i-1).z));
  end
  xi = find(~isnan(tmpv(i).uc_depth));
  if ~isempty(xi)
  t(2*i).w_dl = interp1(tmpv(i).uc_depth(xi),tmpv(i).uc_w(xi),t(2*i).z);
  else
  t(2*i).w_dl = nan(size(t(2*i-1).z));
  end
end
for i = 1:length(tmpall)
  xi = find(~isnan(tmpall(i).depth));
  if ~isempty(xi)
  t(2*i-1).w = interp1(tmpall(i).depth(xi),tmpall(i).dc_w(xi),t(2*i-1).z);
  else
  t(2*i-1).w = nan(size(t(2*i-1).z));
  end
  xi = find(~isnan(tmpall(i).depth));
  if ~isempty(xi)
  t(2*i).w = interp1(tmpall(i).depth(xi),tmpall(i).uc_w(xi),t(2*i).z);
  else
  t(2*i).w = nan(size(t(2*i-1).z));
  end
end











%% intepolate to existing towyo structure

zz = tm.z;

tm.w = nan(size(tm.u));
for i = 1:length(t)
  xi = find(~isnan(t(i).w));
  if ~isempty(xi)
  tm.w(:,i) = interp1(t(i).z(xi),t(i).w(xi),zz);
  end
end

tm.wdl = nan(size(tm.u));
for i = 1:length(t)
  xi = find(~isnan(t(i).w_dl));
  if ~isempty(xi)
  tm.wdl(:,i) = interp1(t(i).z(xi),t(i).w_dl(xi),zz);
  end
end

tm.wul = nan(size(tm.u));
for i = 1:length(t)
  xi = find(~isnan(t(i).w_ul));
  if ~isempty(xi)
  tm.wul(:,i) = interp1(t(i).z(xi),t(i).w_ul(xi),zz);
  end
end


tm.ush = nan(size(tm.u));
for i = 1:length(t)
  xi = find(~isnan(t(i).v));
  if ~isempty(xi)
  tm.ush(:,i) = interp1(t(i).z(xi),t(i).u(xi),zz);
  end
end

tm.vsh = nan(size(tm.v));
for i = 1:length(t)
  xi = find(~isnan(t(i).v));
  if ~isempty(xi)
  tm.vsh(:,i) = interp1(t(i).z(xi),t(i).v(xi),zz);
  end
end


