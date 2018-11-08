% subfunction used by HVGRAPH to apply axis ranges to all axes
%
% function [] = HVGRAPHAPPLYTOALL(figure_handle,axis_handle,switchflag);
% switchflag: 1=x only, 2=y only, 3= both. 
% TPG 24/6/2004

function [] = HVGRAPHAPPLYTOALL(figure_handle,axis_handle,switchflag);

% check legendstate
reapplylegend=HVGETLEGENDSTATE(get(axis_handle,'parent'));


% get the current axis styles
xscale=get(axis_handle,'xscale');
yscale=get(axis_handle,'yscale');

% press the appropriate figure axis button
if and(xscale(1:2)=='li',yscale(1:2)=='li')
    HVGRAPHMENU(20,figure_handle)
elseif and(xscale(1:2)=='lo',yscale(1:2)=='li')
    HVGRAPHMENU(21,figure_handle)
elseif and(xscale(1:2)=='li',yscale(1:2)=='lo')
    HVGRAPHMENU(22,figure_handle)
elseif and(xscale(1:2)=='lo',yscale(1:2)=='lo')
    HVGRAPHMENU(23,figure_handle)
end

% get the current range values and ticks
rng(:,1)=get(axis_handle,'xlim')';
rng(:,2)=get(axis_handle,'ylim')';

% open the rescale window
limitpopuph=hgload('hvrescaleGUI');

% position it
set(limitpopuph,'units','pixels');
mpos=get(figure_handle,'position');
ppos=get(limitpopuph,'position');
newpos(1)=mpos(1)+mpos(3)./2-ppos(3)./2;
newpos(2)=mpos(2)+mpos(4)./2-ppos(4)./2;
set(limitpopuph,'position',[newpos,ppos(3:4)]);

% store the parent figure handle
userdata.handle=figure_handle;
set(limitpopuph,'UserData',userdata);

% set the values to the new values
handlist=allchild(limitpopuph);
switch switchflag
    case 1
        set(findobj(handlist,'Tag','xmin'),'string',num2str(rng(1,1)));
        set(findobj(handlist,'Tag','xmax'),'string',num2str(rng(2,1)));
    case 2
        set(findobj(handlist,'Tag','ymin'),'string',num2str(rng(1,2)));
        set(findobj(handlist,'Tag','ymax'),'string',num2str(rng(2,2)));
    case 3
        set(findobj(handlist,'Tag','xmin'),'string',num2str(rng(1,1)));
        set(findobj(handlist,'Tag','xmax'),'string',num2str(rng(2,1)));
        set(findobj(handlist,'Tag','ymin'),'string',num2str(rng(1,2)));
        set(findobj(handlist,'Tag','ymax'),'string',num2str(rng(2,2)));
end

% hit the OK button
HVGRAPHMENU (3)

% turn the legends back on if required
if reapplylegend==1;
    HVGRAPHMENU(5,figure_handle);
end
% restyle if necessary
HVGRAPHSTYLE(figure_handle)
