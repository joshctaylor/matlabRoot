% subfunction used by HVGRAPH tools to set all linestyles on a graph. 
%
% function [] = HVGRAPHAUTOLINESTYLE(figure_handle,axis_handle,switchflag);
% switchflag=1 linestyle, switchflag=2 colour, switchflag=3 both, 4=no
% style, 5=no line
% TPG 24/6/2004

function [] = HVGRAPHAUTOLINESTYLE(figure_handle,axis_handle,switchflag);

% check for powerpoint format
            handlelist=allchild(figure_handle);
            menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
            pptstate=get(findobj(menulist,'Tag','ppt'),'checked');

% get the line handles
linelist=HVGETOBTYPE(axis_handle,'line');   

if linelist(1)~=-1;
    % reverse order:
    linelist=fliplr(linelist);
    
    % initialise the counters
    if switchflag==5
        linestylecounter=0;
    else
    linestylecounter=1;
end
    colourcounter=1;
    
    % loop through the linestyles
    for r=1:length(linelist);
        
        % cycle line style                   
        switch linestylecounter
            case 0
                 set(linelist(r),'linestyle','none')
            case 1
                set(linelist(r),'linestyle','-')
            case 2
                set(linelist(r),'linestyle','--')
            case 3
                set(linelist(r),'linestyle',':')
            case 4
                set(linelist(r),'linestyle','-.')
        end  % switch linestylecounter
        
        % use the automatic color sequence
        
        if pptstate(2)=='n';
            maxc=6;
        switch(colourcounter)
            case 1
                set(linelist(r),'color',[1,1,1]);
            case 2
                set(linelist(r),'color',[0,1,0]);
            case 3
                set(linelist(r),'color',[1,1,0]);
            case 4
                set(linelist(r),'color',[1,0,1]);
            case 5
                set(linelist(r),'color',[0,1,1]);
        end % switch(colorcounter)
    else % if pptstate(2)=='n';
        maxc=8;
                switch(colourcounter)
            case 1
                set(linelist(r),'color',[0,0,0]);
            case 2
                set(linelist(r),'color',[1,0,0]);
            case 3
                set(linelist(r),'color',[0,1,0]);
            case 4
                set(linelist(r),'color',[0,0,1]);
            case 5
                set(linelist(r),'color',[1,1,0]);
            case 6
                set(linelist(r),'color',[1,0,1]);
            case 7
                set(linelist(r),'color',[0,1,1]);
        end % switch(colorcounter)
        
    end % if pptstate(2)=='n';
        
        % increment counters
        switch switchflag
            case 1
                linestylecounter=linestylecounter+1;
                if linestylecounter==5
                    linestylecounter=1;
                end
            case 2
                colourcounter=colourcounter+1;
                if colourcounter==maxc
                    colourcounter=1;
                end
            case 3
                colourcounter=colourcounter+1;
                if colourcounter==maxc
                    colourcounter=1;
                    linestylecounter=linestylecounter+1;
                    if linestylecounter==5
                        linestylecounter=1;
                    end
                end
            case 4
                % do nothing. 
            case 5
                % do nothing.
                
        end % switch switchflag
    end % if linelist(1)~=-1;
end % for r=1:length(linelist);




