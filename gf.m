function gf(varargin)

% GF(i) Open a new figure window
%
%   gf(i) Create new figure with number i. If no number is given, first non-
%   open figure integer will be used.
%
%   INPUT   i - Figure index number (optional)
%
%   Gunnar Voet, APL - UW - Seattle
%   voet@apl.washington.edu
%
%   Created: 06/09/2014


% List of currently open figures
figHandles = findobj('Type','figure');
if isempty(figHandles); figHandles = 0; end

if nargin==0  
  i = 0;
  a = 0;
  while a == 0
    i = i+1;
    if ~ismemb(i,figHandles)
      a = 1;
    end
  end
else
  i = varargin{1};
  if ismemb(i,figHandles)
    figure(i)
    fprintf('\nFigure %d already exists!\n\n',i)
    return
  end
end

figure(i)
clf
hold on
box off
grid off
zoom('on')
set(gcf,'toolbar','none')