function out = g_objmap_no_segments(x, y, z, xgrid, ygrid, opts)

% G_OBJMAP_NO_SEGMENTS Objective mapping after Roemmich (1983). Adapted
% from Sabine Mecking's code. This function does not split the input data
% into segments so be careful with large datasets!
%
% out = g_objmap_no_segments(x, y, z, xgrid, ygrid, opts)
%
% INPUT
%
% x      -- array of x values (must be organized by station)
% y      -- array of y values
% z      -- array of z values
% xgrid  -- array of xgrid values
% ygrid  -- array of ygrid values
%
% arguments below will default if not passed:
%
% opts.efold   -- large scale field decay length
% opts.efold2  -- small scale field decay length
% opts.evar    -- large scale field variance (relative to 1)
% opts.evar2   -- small scale field variance (relative to 1)
% opts.xysc    -- scaling: y = x*xysc
%
% OUTPUT
%
% out - structured array with following variables
%    .grid -- estimated field
%    .x    -- xgrid vector
%    .y    -- ygrid vector
%    .errors -- error estimate
%    .smoothgrid -- large scale field estimate
%    .finegrid   -- small scale field estimate
%
%  Roemmich D., Optimal Estimation Of Hydrographic Station Data and Derived
%  Fields,Journal of Physical Oceanography, 13, 1544-1549, Aug 1983
%
% Gunnar Voet
% gvoet@ucsd.edu
%
% 07/18/2013 Created
% 12/04/2014 Changed Description
% 12/21/2014 Changed verbose output

% TODO: error estimate

% Set defaults
vout    = 1; % print info to screen
efold   = 40;
efold2  = 2;
evar    = 0.1;
evar2   = 0.1;
epower  = 2;     % This is set to 2 in Roemmich (1983)
epower2 = 1;
xysc    = 1; % Scale factor between x and y

if (nargin < 6)
   opts = [];
end

if isfield(opts, 'verbose'), vout    = opts.verbose; end
if isfield(opts, 'efold'),   efold   = opts.efold; end
if isfield(opts, 'efold2'),  efold2  = opts.efold2; end
if isfield(opts, 'evar'),    evar    = opts.evar; end
if isfield(opts, 'evar2'),   evar2   = opts.evar2; end
if isfield(opts, 'epower'),  epower  = opts.epower; end
if isfield(opts, 'epower2'), epower2 = opts.epower2; end
if isfield(opts, 'xysc'),    xysc    = opts.xysc; end

% Put original grid vectors into output structure
out.x = xgrid;
out.y = ygrid;

% Ensure all input data are row vectors
x = x(:)'; y = y(:)'; z = z(:)';
xgrid = xgrid(:)'; ygrid = ygrid(:)';


% Apply scale factor
% If you want it like in Roemmich (1983)
% 1000m ~~ 100km
% then xysc must be 0.1
% y = y.*xysc;
% ygrid = ygrid.*xysc;
% % ah, this doesn't help here... need it in the distance calcs
% % could probably be here, too


% Create blank grids
Grid        = nan(length(ygrid),length(xgrid));
Errors      = Grid;
Smooth_Grid = Grid;
Fine_Grid   = Grid;

N = length(x);

%% Create covariance matrix
Acov = zeros(N,N);
for i = 1: N
  dist = sqrt((x(i) - x).^2 + ((y(i) - y).*xysc).^2);
  Acov(i,:) = exp(-(dist/efold).^epower);
  Acov(i,i) = Acov(i,i) + evar;
end

%% Calculate spatially weighted mean and subtract it from the data
if vout
  fprintf(vout, '\n')
  fprintf(vout, '-----------------------------------------------------\n')
  fprintf(vout, 'Calculating spatially weighted mean: ');
end
W = Acov\z';
Wsum = sum(W);
Asum = sum(Acov\ones(N, 1));
Mean = Wsum/Asum;

if vout
  fprintf(vout, 'Wsum = %f\n', Wsum);
  fprintf(vout, '                                     Asum = %f\n', Asum);
  fprintf(vout, '                                     Mean = %f\n', Mean);
end

z = z - Mean;

%% Get large scale (smooth) field weights
if vout
  fprintf(vout, 'Determining large-scale field weights\n');
end
W = (Acov\z');

% Subtract smooth field from data
C = zeros(1,N);
for i = 1:N
  dist = sqrt((x(i) - x).^2 + ((y(i) - y).*xysc).^2);
  C = exp(-(dist/efold).^epower);
  z(i) = z(i) - C*W;
end

%% Get small scale field weights
for i = 1: N
  dist = sqrt((x(i) - x).^2 + ((y(i) - y).*xysc).^2);
  Acov(i,:) = exp(-(dist/efold2).^epower2);
  Acov(i,i) = Acov(i,i) + evar2;
end
if vout       
  fprintf(vout, 'Determining small-scale field weights\n');
end
W2 = (Acov\z');

if vout
  fprintf(vout, 'Evaluating grid...\n');
  fprintf(vout, 'Done!\n');
  fprintf(vout, '-----------------------------------------------------\n')
  fprintf(vout, '\n')
end
       
%% Evaluate at xgrid, ygrid
ydist = zeros(length(ygrid), length(y));
for j = 1: length(ygrid)
  ydist(j,:) = ((ygrid(j) - y).*xysc).^2;
end

C2 = zeros(1,N);
for i = 1:length(xgrid)
xdist = (xgrid(i) - x).^2;
for j = 1: length(ygrid)
  dist = sqrt(xdist + ydist(j,:));
  if (epower == 1)
    C = exp(-(dist/efold));
  else
    C = exp(-(dist/efold).^epower);
  end

  if (epower2 == 1)
    C2 = exp(-(dist/efold2));
  else
    C2 = exp(-(dist/efold2).^epower2);
  end

  Grid(j,i)        = Mean + C*W + C2*W2;
  Smooth_Grid(j,i) = Mean + C*W;
  Fine_Grid(j,i)   = C2*W2;
end
end
 
 
%% Calculate the error

CE = zeros(1,N);
for i = 1:N
  dist = sqrt((x(i) - x).^2 + ((y(i) - y).*xysc).^2);
  C = exp(-(dist/efold).^epower);
end



%% Assign output variables
out.grid       = Grid;
out.smoothgrid = Smooth_Grid;
out.finegrid   = Fine_Grid;
out.errors     = [];

end % function