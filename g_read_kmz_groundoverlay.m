function out = g_read_kmz_groundoverlay(kmz_file_name)


!rm -rf LUO7SqKWCV2JbcC
mkdir('LUO7SqKWCV2JbcC')
copyfile(kmz_file_name,'tmp.zip');
unzip('tmp.zip','LUO7SqKWCV2JbcC')

% Now the contents of the kmz file is in tmp
% There should be doc.html and a folder with image files









% Read information from kml file
fid = fopen('LUO7SqKWCV2JbcC/doc.kml');
tline = ' ' ;
while isempty(strfind(tline,'GroundOverlay'))
tline = fgetl(fid);
end
tline = fgetl(fid);

% Image file name
fstr = '<name>';
s1 = strfind(tline,fstr);
s2 = strfind(tline,[fstr(1),'/',fstr(2:end)]);
name = tline(s1+length(fstr):s2-1);

tline = fgetl(fid);
tline = fgetl(fid);

% Image path
fstr = '<href>';
s1 = strfind(tline,fstr);
s2 = strfind(tline,[fstr(1),'/',fstr(2:end)]);
filename = tline(s1+length(fstr):s2-1)

tline = fgetl(fid)
tline = fgetl(fid)
tline = fgetl(fid)
tline = fgetl(fid)

% North position
fstr = '<north>';
s1 = strfind(tline,fstr);
s2 = strfind(tline,[fstr(1),'/',fstr(2:end)]);
p.n = str2num(tline(s1+length(fstr):s2-1));
tline = fgetl(fid);
% South position
fstr = '<south>';
s1 = strfind(tline,fstr);
s2 = strfind(tline,[fstr(1),'/',fstr(2:end)]);
p.s = str2num(tline(s1+length(fstr):s2-1));
tline = fgetl(fid);
% East position
fstr = '<east>';
s1 = strfind(tline,fstr);
s2 = strfind(tline,[fstr(1),'/',fstr(2:end)]);
p.e = str2num(tline(s1+length(fstr):s2-1));
tline = fgetl(fid);
% West position
fstr = '<west>';
s1 = strfind(tline,fstr);
s2 = strfind(tline,[fstr(1),'/',fstr(2:end)]);
p.w = str2num(tline(s1+length(fstr):s2-1));
tline = fgetl(fid);
% Rotation
fstr = '<rotation>';
s1 = strfind(tline,fstr);
s2 = strfind(tline,[fstr(1),'/',fstr(2:end)]);
p.r = str2num(tline(s1+length(fstr):s2-1));

fclose(fid)

img = imread(['LUO7SqKWCV2JbcC/',filename]);


% p.n = 48.37420455338351;
% p.s = 47.41683406352354;
% p.e = -123.3650423805326;
% p.w = -125.5573428298526;
% p.r = -11.19000393139038;


imgs = size(img);
imgs = imgs(1:2);
latv = linspace(p.n,p.s,imgs(1));
lonv = linspace(p.w,p.e,imgs(2));



%% Plot image (not rotated yet)
figure(1)
clf
imagesc(lonv,latv,img);
set(gca,'ydir','normal')

%% Calculate corner points of rotated image
a = (p.e + p.w)./2;
b = (p.n + p.s)./2;
squish = cos(deg2rad(b));
x = squish * (p.e - p.w) ./ 2;
y = (p.n - p.s) ./ 2;


p.ne = [a + (x * cos(deg2rad(p.r)) - y * sin(deg2rad(p.r))) /squish,...
        b + x * sin(deg2rad(p.r)) + y *cos(deg2rad(p.r))];
p.nw = [a - (x * cos(deg2rad(p.r)) + y * sin(deg2rad(p.r))) /squish,...
        b - x * sin(deg2rad(p.r)) + y *cos(deg2rad(p.r))];
p.sw = [a - (x * cos(deg2rad(p.r)) - y * sin(deg2rad(p.r))) /squish,...
        b - x * sin(deg2rad(p.r)) - y *cos(deg2rad(p.r))];
p.se = [a + (x * cos(deg2rad(p.r)) + y * sin(deg2rad(p.r))) /squish,...
        b + x * sin(deg2rad(p.r)) - y *cos(deg2rad(p.r))];
      
%% Rotate image
rimg = imrotate(img,p.r);

% now create new lon and lat ranges from the corner points...
rlons = [p.ne(1) p.nw(1) p.sw(1) p.se(1)];
rlats = [p.ne(2) p.nw(2) p.sw(2) p.se(2)];

rlons = range(rlons);
rlats = range(rlats);

rimgs = size(rimg);
rimgs = rimgs(1:2);

rlon = linspace(rlons(1),rlons(2),rimgs(2));
rlat = linspace(rlats(2),rlats(1),rimgs(1));

figure(3)
clf
imagesc(rlon,rlat,rimg)
set(gca,'ydir','normal')
hold on
plot(p.ne(1),p.ne(2),'r*')
plot(p.se(1),p.se(2),'r*')
plot(p.nw(1),p.nw(2),'r*')
plot(p.sw(1),p.sw(2),'r*')
      
%% Create matrix for each point in image

% [lonm,latm] = meshgrid(lonv,latv);

% Plot rotated points


out.img = rimg;
out.lon = rlon;
out.lat = rlat;
out.oimg = img;

% Remove tmp folder
!rm -rf LUO7SqKWCV2JbcC

end