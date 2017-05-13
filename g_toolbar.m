function g_toolbar

% G_TOOLBAR Toggle toolbar on current figure
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 02/12/2015

% Get current toolbar status

cs = get(gcf,'toolbar');

if ~strcmp(cs,'none')
  set(gcf,'toolbar','none')
elseif ~strcmp(cs,'figure')
  set(gcf,'toolbar','figure')
end