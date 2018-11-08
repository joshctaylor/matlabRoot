% subfunction used by HVGRAPH tools to set all linewidths on an axis

% function [] = HVGRAPHSETALLLINEWIDTH(axis_handle,linewidth);
% TPG 24/6/2004

function [] = HVGRAPHSETALLLINEWIDTH(axis_handle,linewidth);

% get the line handles
linelist=HVGETOBTYPE(axis_handle,'line');   

if linelist(1)~=-1;
    
    % loop through the linestyles
    for r=1:length(linelist);
        
        set(linelist(r),'linewidth',linewidth)
        
    end % for r=1:length(linelist);
end % if linelist(1)~=-1;



