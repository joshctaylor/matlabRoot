% function to check the format option and reapply the style
% 
% function [] = HVGRAPHSTYLE(figure_handle)
% 
% TPG 15/6/2004
% Modified TPG 24/6/2004 to include y label position code, subsequenctly
% commented out as too unreliable 


function [] = HVGRAPHSTYLE(figure_handle)

        handlelist=allchild(figure_handle);
        menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
        ppton=get(findobj(menulist,'Tag','ppt'),'checked');
        ohpon=get(findobj(menulist,'Tag','ohp'),'checked');
        defaulton=get(findobj(menulist,'Tag','defaultformat'),'checked');
        
        if ppton(1:2)=='on'
            HVGRAPHMENU(7,figure_handle);
        elseif ohpon(1:2)=='on'
            HVGRAPHMENU(8,figure_handle);
        elseif defaulton(1:2)=='on'
            HVGRAPHMENU(9,figure_handle);
        end
        
%         
%         % reset the ylabel position
%             axislist=HVGETOBTYPE(figure_handle,'axes');
%             for q=1:length(axislist);
%                 % check for a legend
%                 islegend=HVGRAPHISLEGEND(axislist(q));
%                 if islegend==0
%                     % calculate the label position proportional to the
%                     % axis range
%                     xrng=get(axislist(q),'xlim');
%                     lpos=get(get(axislist(q),'ylabel'),'position')
%                     posratio(q)=(lpos(1)-xrng(1))./(xrng(2)-xrng(1));
%                 end % if islegend==0
%             end % for q=1:length(axislist);
%             
%             % find the maximum (negative value
%             maxpos=-min(posratio);
%             
%             % check it is sensible and set to -0.085 if not. 
%             if or(maxpos>0.085,maxpos<0.04)
%                 maxpos=0.085;
%             end
%             
%             for q=1:length(axislist);
%                 if islegend==0
%                     % calculate the label position proportional to the
%                     % axis range
%                     xrng=get(axislist(q),'xlim');
%                     newpos=-maxpos.*(xrng(2)-xrng(1))+xrng(1);
%                     lpos=get(get(axislist(q),'ylabel'),'position');
%                     lpos(1)=newpos;
%                              % set all ylabel positions to this value
%                     set(get(axislist(q),'ylabel'),'position',lpos);
%                     
%                 end % if islegend==0
%             end % for q=1:length(axislist);
%             
   
