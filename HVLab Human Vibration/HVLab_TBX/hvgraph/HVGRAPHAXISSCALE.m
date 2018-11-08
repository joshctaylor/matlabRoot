% subfunction used by HVGRAPH tools to set the axis scaling on an axis and
% set all line xscale and yscale properties accordingly
%
% function [] = HVGRAPHAXISSCALE(axis_handle,xscale,yscale)
% scales may be 'log' or 'linear'. Ignores legend axes. 
% written TPG 24/6/2004

function [] = HVGRAPHAXISSCALE(axis_handle,xscale,yscale)

% check for a legend
islegend=HVGRAPHISLEGEND(axis_handle);
if islegend==0
    
    % set the axis scaling
    set(axis_handle,'xscale',xscale);
    set(axis_handle,'yscale',yscale);
    % loop through the lines to set the scaling flags
    linelist=HVGETOBTYPE(axis_handle,'line');
    % check three are lines to display
    if linelist(1)~=-1
        for r=1:length(linelist);
            linedata=get(linelist(r),'userdata');
            linedata.xscale=xscale;
            linedata.yscale=yscale;
            set(linelist(r),'userdata',linedata);
        end % for r
    end % if linelist(1)~=-1
    
end % if islegend==0


