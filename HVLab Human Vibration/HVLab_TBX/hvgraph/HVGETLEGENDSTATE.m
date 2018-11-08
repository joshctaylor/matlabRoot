% function to check the legend state, and turn it off if required with a
% flag indicating that it should be turned on again
%
% function [reapplylegend]=HVGETLEGENDSTATE(figure_handle)
% 
% TPG 15/6/2004

function [reapplylegend]=HVGETLEGENDSTATE(figure_handle)

% check legendstate
handlelist=allchild(figure_handle);
menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
legendstate=get(findobj(menulist,'Tag','legendtoggle'),'checked');
if legendstate(1:2)=='on';
    reapplylegend=1;
    HVGRAPHMENU(5,figure_handle);
else
    reapplylegend=0;
end
drawnow