% subfunction used by HVGRAPH tools to set all linestyles on a graph. 
%
% function [] = HVGRAPHAUTOMARKERS(figure_handle,axis_handle,switchflag);
% switchflag=0 off, =1 on. 
% TPG 24/6/2004

function [] = HVGRAPHAUTOMARKERS(figure_handle,axis_handle,switchflag);

% get the line handles
linelist=HVGETOBTYPE(axis_handle,'line');   

if linelist(1)~=-1;
    % reverse order:
    linelist=fliplr(linelist);
    
    % counter
    markercounter=1;
    
    markerstring='ox+*sdv^<>ph';
    
    % loop through the markers
    for r=1:length(linelist);
        
        switch switchflag
            
            case 0
                 % set the marker
                set(linelist(r),'marker','none')
                
            case 1
                % set the marker
                set(linelist(r),'marker',markerstring(markercounter))
                
                % increment the counter
                markercounter=markercounter+1;
                if markercounter==13
                    markercounter=1;
                end
                
        end % switch switchflag
        
    end % for r=1:length(linelist);
end % if linelist(1)~=-1;


