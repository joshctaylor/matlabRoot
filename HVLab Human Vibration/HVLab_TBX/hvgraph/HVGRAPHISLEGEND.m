% function used by HVGRAPH related code to check if an axis is a legend
%
% islegend=HVGRAPHISLEGEND(axis_handle);
%
% TPG 17/6/2004

function [islegend]=HVGRAPHISLEGEND(axis_handle);

% check for a legend:
    axistype=get(axis_handle,'tag');
    if length(axistype>2)
        if axistype(1:3)=='leg';
            islegend=1;
        else
            islegend=0;
        end
    else
        islegend=0;
    end