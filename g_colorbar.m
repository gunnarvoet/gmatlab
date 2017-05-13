function ax = g_colorbar(pos,cvec,cmap,dir,varargin)

% G_COLORBAR Create new axis with a colorbar
%     [AX] = g_colorbar(POS,CVEC,CMAP,DIR) creates new axes at POS with
%     the elements x0, y0, w, h and draws a colorbar according to CVEC and
%     CMAP in the direction of DIR.
%
%     INPUT   pos - 4-element vector with axes position
%             cvec - contour limit vector
%             cmap - colormap (length must be one shorter than cvec)
%             dir  - either 'h' for horizontal or 'v' for vertical
%
%     OPTIONAL tr  - set this to 1 if you want color triangles for
%                    values outside of cvec. the colormap must be one
%                    longer than cvec in this case!
%
%     OUTPUT  ax - handle to the axis. apply any changes to these axis...
%
%     Gunnar Voet, APL - UW - Seattle
%     voet@apl.washington.edu
%
%     11/07/2012 Created
%     05/18/2013 Added the option to have triangles for values outside of
%                cvec


% Add option for changing the axis color by creating axis
%                below the actualcolorbar


% % % % Set standard options
% % % AxColor = [0 0 0];
% % % TickDir = 'in';
% % % Triangle = 0;


ver = g_matlab_version;


% Set the triangle size as fraction of the main axis
TriangleSize = 0.1;

% check if triangle option is given
if nargin <= 4
  tr = 0;
elseif nargin == 5
  tr = varargin{1};
end

axlim = [cvec(1) cvec(end)];

if ver<8.4
  
  if tr
    % Check for longer cmap
    if length(cmap(:,1))-length(cvec) ~=1
      error('cmap must be one element more than cvec when using triangles!')
    end
    % Shorten the main axis to have space for two triangle axes
    if strcmp(dir,'h')
      axw = pos(3);
      naxw = axw-axw.*TriangleSize;
      pos(1) = pos(1)+axw.*(0.5*TriangleSize);
      pos(3) = naxw;
    elseif strcmp(dir,'v')
      axw = pos(4);
      naxw = axw-axw.*TriangleSize;
      pos(2) = pos(2)+axw.*(0.5*TriangleSize);
      pos(4) = naxw;
    end
    % Take start and end colors out of the cmap
    ctr1 = cmap(1,:);
    ctr2 = cmap(end,:);
    cmap2 = cmap(2:end-1,:);
    clear cmap
    cmap = cmap2;
  end
  
  % Create main colorbar axis
  ax(1) = axes('position',pos);
  
  
  % HORIZONTAL COLORBAR
  if strcmp(dir,'h')
    
    [concol concolhand] = contourf(cvec',[0 1],[cvec; cvec],cvec,...
      'linecolor','none');
    
    pp       = get(concolhand,'children');
    thechildcol = get(pp,'CData');
    cdat     = cell2mat(thechildcol);
    
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
    
    if tr
      ax(2) = axes('position',[pos(1)-axw.*(0.5.*TriangleSize) pos(2) axw.*(0.5.*TriangleSize) pos(4)]);
      hp1 = patch([1 0 1],...
        [0 0.5 1],'k');
      set(hp1,'facecolor',ctr1,'edgecolor','k','linewidth',0.5);
      set(ax(2),'visible','off','layer','bottom')
      
      ax(3) = axes('position',[pos(1)+pos(3) pos(2) axw.*(0.5.*TriangleSize) pos(4)]);
      hp2 = patch([0 1 0],...
        [0 0.5 1],'k');
      set(hp2,'facecolor',ctr2,'edgecolor','k','linewidth',0.5);
      set(ax(3),'visible','off','layer','bottom')
      
    end
    
    set(ax(1),'yticklabel',[],...
      'ytick',[],...
      'xaxislocation','top')
    
    
    % VERTICAL COLORBAR
  elseif strcmp(dir,'v')
    
    [concol concolhand] = contourf([0 1],cvec,[cvec', cvec'],cvec,...
      'linecolor','none');
    
    pp       = get(concolhand,'children');
    thechildcol = get(pp,'CData');
    cdat     = cell2mat(thechildcol);
    
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
    
    if tr
      ax(2) = axes('position',[pos(1) pos(2)-axw.*(0.5.*TriangleSize) pos(3) axw.*(0.5.*TriangleSize)]);
      hp1 = patch([0 0.5 1],...
        [1 0 1],'k');
      set(hp1,'facecolor',ctr1,'edgecolor','k','linewidth',0.5);
      set(ax(2),'visible','off','layer','bottom')
      
      ax(3) = axes('position',[pos(1) pos(2)+pos(4) pos(3) axw.*(0.5.*TriangleSize)]);
      hp2 = patch([0 0.5 1],...
        [0 1 0],'k');
      set(hp2,'facecolor',ctr2,'edgecolor','k','linewidth',0.5);
      set(ax(3),'visible','off','layer','bottom')
      
    end
    
    set(ax(1),'ylim',axlim,...
      'xticklabel',[],'xtick',[],'yaxislocation','right')
    
  end
  
  axes(ax(1))
  
  
  
  
else % ver >=8.4
  
  if tr
    % Check for longer cmap
    if length(cmap(:,1))-length(cvec) ~=1
      error('cmap must be one element more than cvec when using triangles!')
    end
    % Shorten the main axis to have space for two triangle axes
    if strcmp(dir,'h')
      axw = pos(3);
      naxw = axw-axw.*TriangleSize;
      pos(1) = pos(1)+axw.*(0.5*TriangleSize);
      pos(3) = naxw;
    elseif strcmp(dir,'v')
      axw = pos(4);
      naxw = axw-axw.*TriangleSize;
      pos(2) = pos(2)+axw.*(0.5*TriangleSize);
      pos(4) = naxw;
    end
    % Take start and end colors out of the cmap
    ctr1 = cmap(1,:);
    ctr2 = cmap(end,:);
    cmap2 = cmap(2:end-1,:);
    clear cmap
    cmap = cmap2;
  end
  
  % Create main colorbar axis
  ax(1) = axes('position',pos);
  
  
  % HORIZONTAL COLORBAR
  if strcmp(dir,'h')
    
    [concol concolhand] = contourf(cvec',[0 1],[cvec; cvec],cvec,...
      'linecolor','none');
    
    colormap(ax(1),cmap)
    
    if tr
      ax(2) = axes('position',[pos(1)-axw.*(0.5.*TriangleSize) pos(2) axw.*(0.5.*TriangleSize) pos(4)]);
      hp1 = patch([1 0 1],...
        [0 0.5 1],'k');
      set(hp1,'facecolor',ctr1,'edgecolor','k','linewidth',0.5);
      set(ax(2),'visible','off','layer','bottom')
      
      ax(3) = axes('position',[pos(1)+pos(3) pos(2) axw.*(0.5.*TriangleSize) pos(4)]);
      hp2 = patch([0 1 0],...
        [0 0.5 1],'k');
      set(hp2,'facecolor',ctr2,'edgecolor','k','linewidth',0.5);
      set(ax(3),'visible','off','layer','bottom')
      
    end
    
    set(ax(1),'yticklabel',[],...
      'ytick',[],...
      'xaxislocation','top')
    
    
    % VERTICAL COLORBAR
  elseif strcmp(dir,'v')
    
    [concol concolhand] = contourf([0 1],cvec,[cvec', cvec'],cvec,...
      'linecolor','none');
    
    colormap(ax(1),cmap)
    
    if tr
      ax(2) = axes('position',[pos(1) pos(2)-axw.*(0.5.*TriangleSize) pos(3) axw.*(0.5.*TriangleSize)]);
      hp1 = patch([0 0.5 1],...
        [1 0 1],'k');
      set(hp1,'facecolor',ctr1,'edgecolor','k','linewidth',0.5);
      set(ax(2),'visible','off','layer','bottom')
      
      ax(3) = axes('position',[pos(1) pos(2)+pos(4) pos(3) axw.*(0.5.*TriangleSize)]);
      hp2 = patch([0 0.5 1],...
        [0 1 0],'k');
      set(hp2,'facecolor',ctr2,'edgecolor','k','linewidth',0.5);
      set(ax(3),'visible','off','layer','bottom')
      
    end
    
    set(ax(1),'ylim',axlim,...
      'xticklabel',[],'xtick',[],'yaxislocation','right')
    
  end
  
  axes(ax(1))
  
end

end