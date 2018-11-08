% function to accompany hvgraph to operate the HVGraph menu controls
%
% function [] = HVGRAPHMENU (switchstring,handle);
% 
% written TPG 14/6/2004

% modified TPG 24/6/2004 to switch between merge and overlay modes directly
% without having to go via the separate axis layout. Overlay uses axis
% log/linear state from the top left graph and returns graphs to their
% original scaling. Added axis scaling options to the menu via
% HVGRAPHAXISSCLAE. The y-label position option code has been deleted from
% HVGRAPHMENU(20) and is now part of HVGRAPHSTYLE. Added line styling
% options. 

function [] = HVGRAPHMENU (switchcode,figure_handle,defineflag);

if ~exist('defineflag')
    defineflag=0;
end


% generate uimenu
if defineflag==1
    
    menuhand=uimenu(figure_handle,'Label','HVLab','tag','hvlabtopmenu');
    
    formatsubmenu=uimenu(menuhand,'Label','Set colour scheme','Tag','Autoformat');
    uimenu(formatsubmenu,'Label','HFRU powerpoint','Tag','ppt','callback','HVGRAPHMENU(7,gcf)')
    uimenu(formatsubmenu,'Label','HFRU OHP','Tag','ohp','callback','HVGRAPHMENU(8,gcf)')
    uimenu(formatsubmenu,'Label','Default','Tag','defaultformat','callback','HVGRAPHMENU(9,gcf)','checked','on')
    
    layouthand=uimenu(menuhand,'Label','Axis layout','tag','Layout');
    uimenu(layouthand,'Label','Merge axes','Tag','merge','callback','HVGRAPHMENU(4,gcf)')
    uimenu(layouthand,'Label','Overlay data','Tag','overlay','callback','HVGRAPHMENU(11,gcf)')
    
    limithand=uimenu(menuhand,'Label','Axis ranges','tag','Layout');
    
    uimenu(limithand,'Label','Manual','Tag','setx','callback','HVGRAPHMENU(1,gcf)')
    
    autoscalehand=uimenu(limithand,'Label','Autoscale','Tag','showall');
    uimenu(autoscalehand,'Label','x only','Tag','scalex','callback','HVGRAPHMENU(14,gcf)')
    uimenu(autoscalehand,'Label','y only','Tag','scaley','callback','HVGRAPHMENU(15,gcf)')
    uimenu(autoscalehand,'Label','Both','Tag','scaleboth','callback','HVGRAPHMENU(6,gcf)')
    
    zoomhand=uimenu(limithand,'Label','Zoom','tag','Zoom');
    uimenu(zoomhand,'Label','x only','Tag','zoomx','callback','HVGRAPHMENU(12,gcf)')
    uimenu(zoomhand,'Label','y only','Tag','zoomy','callback','HVGRAPHMENU(13,gcf)')
    uimenu(zoomhand,'Label','Both','Tag','zoom','callback','HVGRAPHMENU(10,gcf)')
    
    scalehand=uimenu(limithand,'Label','Axis scales');
    uimenu(scalehand,'Label','linear x, linear y','Tag','slinear','callback','HVGRAPHMENU(20,gcf)')
    uimenu(scalehand,'Label','log x, linear y','Tag','slogx','callback','HVGRAPHMENU(21,gcf)')
    uimenu(scalehand,'Label','linear x, log y','Tag','slogy','callback','HVGRAPHMENU(22,gcf)')
    uimenu(scalehand,'Label','log x, log y','Tag','sloglog','callback','HVGRAPHMENU(23,gcf)')
    
    alinemenu=uimenu(menuhand, 'Label', 'Line styling');
    
    autolinestylemenu=uimenu(alinemenu, 'Label', 'Style and colour');
    uimenu(autolinestylemenu, 'Label', 'Line styles', 'Callback', 'HVGRAPHMENU(24,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Line colours', 'Callback', 'HVGRAPHMENU(25,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Both', 'Callback', 'HVGRAPHMENU(26,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Neither', 'Callback', 'HVGRAPHMENU(27,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Hide lines', 'Callback', 'HVGRAPHMENU(34,gcf)');
    
    linewidthmenu=uimenu(alinemenu, 'Label', 'Line width');
    uimenu(linewidthmenu, 'Label', '0.1', 'Callback', 'HVGRAPHMENU(35,gcf)');
    uimenu(linewidthmenu, 'Label', '0.25', 'Callback', 'HVGRAPHMENU(36,gcf)');
    uimenu(linewidthmenu, 'Label', '0.5 (default)', 'Callback', 'HVGRAPHMENU(37,gcf)');
    uimenu(linewidthmenu, 'Label', '1.0', 'Callback', 'HVGRAPHMENU(38,gcf)');
    uimenu(linewidthmenu, 'Label', '2.5', 'Callback', 'HVGRAPHMENU(39,gcf)');
    uimenu(linewidthmenu, 'Label', '5.0', 'Callback', 'HVGRAPHMENU(40,gcf)');
    
    automarkermenu=uimenu(alinemenu, 'Label', 'Markers');
    uimenu(automarkermenu, 'Label', 'Set markers', 'Callback', 'HVGRAPHMENU(28,gcf)');
    
    markersizemenu=uimenu(automarkermenu, 'Label', 'Set marker size');
    uimenu(markersizemenu, 'Label', '3', 'Callback', 'HVGRAPHMENU(30,gcf)');
    uimenu(markersizemenu, 'Label', '6 (default)', 'Callback', 'HVGRAPHMENU(31,gcf)');
    uimenu(markersizemenu, 'Label', '9', 'Callback', 'HVGRAPHMENU(32,gcf)');
    uimenu(markersizemenu, 'Label', '12', 'Callback', 'HVGRAPHMENU(33,gcf)');
    
    uimenu(automarkermenu, 'Label', 'Remove markers', 'Callback', 'HVGRAPHMENU(29,gcf)');
    
    uimenu(menuhand, 'Label', 'Set units for all lines', 'Callback', 'HVGRAPHMENU(16,gcf)');
    
    uimenu(menuhand,'Label','Show legends','Tag','legendtoggle','callback','HVGRAPHMENU(5,gcf)')
    
    
else
    
    switch switchcode
        
        case 1 % open 'axis limits' window
            
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
            info.handle=figure_handle;
            set(limitpopuph,'UserData',info);
            
        case 2 % 'axis limits' window cancel
            
            close(gcf);
            
        case 3 % 'axis limits' window OK
            
            % get the parent figure handle
            limitpopuphand=gcf;
            info=get(limitpopuphand,'Userdata');
            phand=info.handle;
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(phand);
            
            % get the specified axis limits
            handlist=allchild(limitpopuphand);
            
            % loop through excluding the uimenu
            axislist=HVGETOBTYPE(phand,'axes');
            for q=1:(length(axislist));
                
                % get the textbox values
                xmin=str2num(get(findobj(handlist,'Tag','xmin'),'string'));
                xmax=str2num(get(findobj(handlist,'Tag','xmax'),'string'));
                ymin=str2num(get(findobj(handlist,'Tag','ymin'),'string'));
                ymax=str2num(get(findobj(handlist,'Tag','ymax'),'string'));
                
                % do not change values corresponding to an empty box
                currentrange(1:2)=get(axislist(q),'xlim');
                currentrange(3:4)=get(axislist(q),'ylim');
                
                if length(xmin)==0;xmin=currentrange(1);end
                if length(xmax)==0;xmax=currentrange(2);end
                if length(ymin)==0;ymin=currentrange(3);end
                if length(ymax)==0;ymax=currentrange(4);end
                
                
                % flip scale order if minimum is greater than maximum
                if (xmax<xmin)
                    holdval=xmin;
                    xmin=xmax;
                    xmax=holdval;
                end
                if (ymax<ymin)
                    holdval=ymin;
                    ymin=ymax;
                    ymax=holdval;
                end
                
                % if ranges are equal then abort
                if or(xmax==xmin,ymax==ymin);
                    fprintf('\nAn axis range is zero. It is not possible to rescale the data');
                    close(limitpopuphand);
                    return;
                end
                
                % set the axis ranges
                set(axislist(q),'xlim',[xmin,xmax]);
                set(axislist(q),'ylim',[ymin,ymax]);
            
            end
            
            % close the popup
            close(limitpopuphand);
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,phand);
            end
            
            % restyle if necessary
            % HVGRAPHSTYLE(phand)
            
            
        case 4 % merge axes - use Jointfig to merge, redraw to unmerge. 
            
            % check overlay state and undo this if necessary
            handlelist=allchild(figure_handle);
            menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
            overlaystate=get(findobj(menulist,'Tag','overlay'),'checked');
            if overlaystate(1:2)=='on'
                HVGRAPHMENU(11,gcf);
            end
            
            % check legendstate
            [reapplylegend]=HVGETLEGENDSTATE(figure_handle);
            
            % get current merge state, re-checking the handle list
            mstate=get(findobj(menulist,'Tag','merge'),'checked');
            
            % to merge the axes use HVJOINTFIG
            if mstate(1:2)=='of'
                userdata=get(figure_handle,'userdata');
                hvjointfig(figure_handle,userdata.axislayout(1),userdata.axislayout(2));
                set(findobj(menulist,'Tag','merge'),'checked','on')
                
            else
                % to unmerge the axes by copying the axes to a duplicate
                % figure, drawing new axes on the original figure to get the position vectors, 
                % and copying the axes back again.
                
                % open a second figure
                dfh=figure;
                
                set(dfh,'visible','off');
                
                figuredata=get(figure_handle,'userdata');
                
                % set the position and size of the new figure to match the old one
                axislist=HVGETOBTYPE(figure_handle,'axes');
                figure(dfh)
                for q=1:length(axislist);
                    posplot=subplot(figuredata.axislayout(1),figuredata.axislayout(2),length(axislist)+1-q);
                    HVAXISCMENU (0,posplot,figure_handle,1);
                    axisposition=get(posplot,'position');
                    delete(posplot);
                    % set the position on the original figure
                    set(axislist(q),'position',axisposition);
                    
                end
                
                % close the second window
                delete(dfh);
                
                % set the 'merge' flag
                set(findobj(menulist,'Tag','merge'),'checked','off')
                
            end % if mstate(1:2)=='of'
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            
            % reapply the axis labels
            HVGRAPHAUTOLABEL(figure_handle)
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 5 % show / hide legends
            
            % get current legends state
            handlelist=allchild(figure_handle);
            menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
            mstate=get(findobj(menulist,'Tag','legendtoggle'),'checked');
            
            % get the axis handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            
            if mstate(1:2)=='of' % add legends
                
                % loop through axes
                for q=1:length(axislist)
                    
                    legendlabels={};
                    linelist=HVGETOBTYPE(axislist(q),'line');
                    for r=1:length(linelist);
                        lineuserdata=get(linelist(r),'userdata');
                        legendlabels=[legendlabels,{lineuserdata.title}];
                    end % for r=1:length(linelist);
                    
                    % apply the legend accouinting for reverse plot order
                    legend(axislist(q),fliplr(legendlabels));
                    
                    
                end % for q=1:length(axislist)
                
                set(findobj(menulist,'Tag','legendtoggle'),'checked','on');
                
                % restyle if necessary
                % HVGRAPHSTYLE(figure_handle)
                
            else % remove legends
                % loop through axes
                for q=1:length(axislist)
                    legend(axislist(q),'off')
                    
                end
                
                set(findobj(menulist,'Tag','legendtoggle'),'checked','off');
                
            end % if mstate
            
            
            
        case 6 % rescale to show all data on all axes
            
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(figure_handle);
            
            % get the axis handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            
            for q=1:length(axislist);
                
                % get the data handles
                linelist=HVGETOBTYPE(axislist(q),'line');
                
                for r=1:length(linelist);
                    
                    % get the maximum and minimum values
                    xmin(r)=min(get(linelist(r),'xdata'));
                    xmax(r)=max(get(linelist(r),'xdata'));
                    ymin(r)=min(get(linelist(r),'ydata'));
                    ymax(r)=max(get(linelist(r),'ydata'));
                end
                
                % set the axis range, ovverscaling the y axis by 5%
                yr=(max(ymax)-min(ymin)).*0.05;
                set(axislist(q),'xlim',[min(xmin),max(xmax)]);
                set(axislist(q),'ylim',[min(ymin)-yr,max(ymax)+yr]);
                
            end
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 7 % autoformat for powerpoint
            
            HVGRAPHRECOLOUR(figure_handle,'ppt',14,14);
            

            handlelist=allchild(figure_handle);
            menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
            set(findobj(menulist,'Tag','ppt'),'checked','on');
            set(findobj(menulist,'Tag','ohp'),'checked','off');
            set(findobj(menulist,'Tag','defaultformat'),'checked','off');
            
            % remove markers
            HVGRAPHMENU(29,gcf)
            
            % style by colour
            HVGRAPHMENU(25,gcf)
            
            % linewidth to 2.5 
            HVGRAPHMENU(39,gcf)

            
        case 8 % autoformat for ohp
            
            HVGRAPHRECOLOUR(figure_handle,'ohp',14,14);
            
            handlelist=allchild(figure_handle);
            menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
            set(findobj(menulist,'Tag','ppt'),'checked','off');
            set(findobj(menulist,'Tag','ohp'),'checked','on');
            set(findobj(menulist,'Tag','defaultformat'),'checked','off');
            
            % remove markers
            HVGRAPHMENU(29,gcf)
            
            % style by colour
            HVGRAPHMENU(25,gcf)
            
            % linewidth to 2.5 
            HVGRAPHMENU(39,gcf)
            
        case 9 % autoformat for matlab
            
            HVGRAPHRECOLOUR(figure_handle,'ohp',10,10,1);
            
            handlelist=allchild(figure_handle);
            menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
            set(findobj(menulist,'Tag','ppt'),'checked','off');
            set(findobj(menulist,'Tag','ohp'),'checked','off');
            set(findobj(menulist,'Tag','defaultformat'),'checked','on');
            
            
            % remove markers
            HVGRAPHMENU(29,gcf)
            
            % style by linestyle
            HVGRAPHMENU(24,gcf)
            
            % linewidth to 0.5
            HVGRAPHMENU(37,gcf)

            
        case 10 % zoom
            
            % get values
            rng=ginput(2);
            
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
            info.handle=figure_handle;
            set(limitpopuph,'UserData',info);
            
            % set the values to the 'zoomed' values
            handlist=allchild(limitpopuph);
            set(findobj(handlist,'Tag','xmin'),'string',num2str(rng(1,1)));
            set(findobj(handlist,'Tag','xmax'),'string',num2str(rng(2,1)));
            set(findobj(handlist,'Tag','ymin'),'string',num2str(rng(1,2)));
            set(findobj(handlist,'Tag','ymax'),'string',num2str(rng(2,2)));
            
            % hit the OK button
            HVGRAPHMENU (3)
            
            
        case 11 % plot all the data on the same axis
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(figure_handle);
            
            handlelist=allchild(figure_handle);
            menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
            
            % check the overlay state
            overlaystate=get(findobj(menulist,'Tag','overlay'),'checked');
            
            % plot data overlaid
            if overlaystate(1:2)=='of'
                
                % open a second figure
                dfh=figure;
                set(dfh,'visible','off');
                
                figuredata=get(figure_handle,'userdata');
                
                % copy all the data to the new figure
                axislist=HVGETOBTYPE(figure_handle,'axes');
                figure(dfh)
                targaxis=subplot(1,1,1);
                
                set(targaxis,'box','on');
                
                % get the log/linear axis state and axis limits of the top left graph
                xscale=get(axislist(end),'XScale');
                yscale=get(axislist(end),'YScale');
                xlims=get(axislist(end),'xlim');
                ylims=get(axislist(end),'ylim');
                
                % loop through axes
                for q=1:length(axislist);
                    
                    % loop through lines
                    linelist=HVGETOBTYPE(axislist(q),'line');
                    
                    % check that there are lines to copy
                    if linelist(1)~=-1;
                        for r=1:length(linelist);
                            copyobj(linelist(r),targaxis)
                        end
                    end
                    % delete the axis once all the data has been moved
                    delete(axislist(q))
                end
  
                
                % copy the children back again
                figure(figure_handle)
                overlayaxis=subplot(1,1,1);
                HVAXISCMENU (0,overlayaxis,figure_handle,1);
                linelist2=HVGETOBTYPE(targaxis,'line');
                for q=1:length(linelist2);
                    copyobj(linelist2(q),overlayaxis)
                end
                set(overlayaxis,'box','on');
  
                
                % set the log/linear state and axis limits
                set(overlayaxis,'XScale',xscale);
                set(overlayaxis,'YScale',yscale);
                set(overlayaxis,'xlim',xlims);
                set(overlayaxis,'ylim',ylims);
   
                % close the second window
                delete(dfh);
                
                % set the 'overlay' flag and the 'merge' flag
                set(findobj(menulist,'Tag','overlay'),'checked','on')
                set(findobj(menulist,'Tag','merge'),'checked','off')
                
            else % plot data on the original axes
                
                % open a second figure
                dfh=figure;
                set(dfh,'visible','off');
                
                % copy all data to a duplicate figure,
                axislist=HVGETOBTYPE(figure_handle,'axes');
                holdaxis=copyobj(axislist(1),dfh);
                
                % generate the required subplots
                userdata=get(figure_handle,'userdata');
                nplots=userdata.originalaxislayout(1).*userdata.originalaxislayout(2);
                figure(figure_handle)
                for q=1:nplots
                    newaxis(q)=subplot(userdata.originalaxislayout(1),userdata.originalaxislayout(2),q);
                    set(newaxis(q),'box','on');
                    HVAXISCMENU (0,newaxis(q),figure_handle,1);
                    % sort through data due to be ploted in this window
                    linelist=HVGETOBTYPE(holdaxis,'line');
                    for r=1:length(linelist)
                        linedata=get(linelist(r),'userdata'); % check the stored axis location for each line
                        if linedata.axis==q;
                            copyobj(linelist(r),newaxis(q)); % copy the data back to the new axis
                            % set xscale and yscale properties
                            lineuserdata=get(linelist(r),'userdata');
                            set(newaxis(q),'XScale',lineuserdata.xscale);
                            set(newaxis(q),'YScale',lineuserdata.yscale);
                        end % if linedata.axis==q;
                    end % for r=1:length(linelist)
                    % set the scales for all axes
                    set(newaxis(q),'xlim',get(holdaxis,'xlim'));
                    set(newaxis(q),'ylim',get(holdaxis,'ylim'));
                end % for q=1:nplots
                
                
                % close the second window
                delete(dfh);
                
                % set the 'overlay' flag
                set(findobj(menulist,'Tag','overlay'),'checked','off')
                
            end % if mstate(1:2)=='of'
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            
            % reapply the axis labels
            HVGRAPHAUTOLABEL(figure_handle)
            
            % rescale the axes to correct the axis scaling of any empty axis
            % windows
            HVAXISCMENU(13,newaxis(1),figure_handle)
            
            % restyle if necessary
            % HVGRAPHSTYLE(figure_handle)
            
            
        case 12 % zoom x
            
            % get values
            rng=ginput(2);
            
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
            info.handle=figure_handle;
            set(limitpopuph,'UserData',info);
            
            % set the values to the 'zoomed' values
            handlist=allchild(limitpopuph);
            set(findobj(handlist,'Tag','xmin'),'string',num2str(rng(1,1)));
            set(findobj(handlist,'Tag','xmax'),'string',num2str(rng(2,1)));
            
            
            % hit the OK button
            HVGRAPHMENU (3)
            
        case 13 % zoom y
            
            % get values
            rng=ginput(2);
            
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
            info.handle=figure_handle;
            set(limitpopuph,'UserData',info);
            
            % set the values to the 'zoomed' values
            handlist=allchild(limitpopuph);
            set(findobj(handlist,'Tag','ymin'),'string',num2str(rng(1,2)));
            set(findobj(handlist,'Tag','ymax'),'string',num2str(rng(2,2)));
            
            
            % hit the OK button
            HVGRAPHMENU (3)
            
            
        case 14 % rescale x to show all data on all axes
            
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(figure_handle);
            
            % get the axis handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            
            for q=1:length(axislist);
                
                % get the data handles
                linelist=HVGETOBTYPE(axislist(q),'line');
                
                for r=1:length(linelist);
                    
                    % get the maximum and minimum values
                    xmin(r)=min(get(linelist(r),'xdata'));
                    xmax(r)=max(get(linelist(r),'xdata'));
                end
                
                % set the axis range
                set(axislist(q),'xlim',[min(xmin),max(xmax)]);
                
            end
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 15 % rescale y to show all data on all axes
            
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(figure_handle);
            
            % get the axis handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            
            for q=1:length(axislist);
                
                % get the data handles
                linelist=HVGETOBTYPE(axislist(q),'line');
                
                for r=1:length(linelist);
                    
                    % get the maximum and minimum values
                    ymin(r)=min(get(linelist(r),'ydata'));
                    ymax(r)=max(get(linelist(r),'ydata'));
                end
                
                % set the axis range, overscaling the y axis by 5%
                yr=(max(ymax)-min(ymin)).*0.05;
                set(axislist(q),'ylim',[min(ymin)-yr,max(ymax)+yr]);
                
            end
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
        case 17 % 'axis label' window cancel
            
            close(gcf);
            
        case 18 % axis label' window OK. 
            
            %get the stored figure and axis handles
            labelpopuph=gcf;
            userdata=get(labelpopuph,'UserData');
            figure_handle=userdata.figurehandle
            reapplylegend=0;
            
            % get the specified axis limits
            handlist=allchild(labelpopuph);
            
            % get the textbox values
            xlabel=get(findobj(handlist,'Tag','xlabel'),'string');
            ylabel=get(findobj(handlist,'Tag','ylabel'),'string');
            
            % loop through axes
            axislist=HVGETOBTYPE(figure_handle,'axes');
            
            for q=1:length(axislist);
                
                % check for a legend
                islegend=HVGRAPHISLEGEND(axislist(q));
                
                if islegend==0
                    
                    % set the axis labels for all lines
                    
                    % get the data handles
                    linelist=HVGETOBTYPE(axislist(q),'line');
                    
                    % check for lines on the axis
                    if linelist(1)~=-1;
                        for r=1:length(linelist);
                            % set line label string properties if a new value is
                            % given
                            lineuserdata=get(linelist(r),'userdata');
                            if length(xlabel)>0;
                                lineuserdata.xlabel=xlabel;
                            end
                            if length(ylabel)>0;
                                lineuserdata.ylabel1=ylabel;
                            end
                            set(linelist(r),'userdata',lineuserdata);
                            
                            % update the line context menu
                            HVLINECMENU (0,linelist(r),figure_handle,1);
                            
                        end %  for r=1:length(linelist);
                    end %  if linelist(1)~=-1;
                end % if islegend==0
            end % for q=1:length(axislist);
            % close the popup window
            close(labelpopuph);
            
            % relabel the graph
            HVGRAPHAUTOLABEL (figure_handle);
            
            
            
        case 20 % axis scaling, linear x, linear y
            
            % loop through each axis
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAXISSCALE(axislist(q),'linear','linear')
            end
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 21 % axis scaling, log x, linear y
            
            % loop through each axis
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAXISSCALE(axislist(q),'log','linear')
            end
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 22 % axis scaling, linear x, log y
            
            % loop through each axis
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAXISSCALE(axislist(q),'linear','log')
            end
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 23 % axis scaling, log x, log y
            
            % loop through each axis
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAXISSCALE(axislist(q),'log','log')
            end
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
            
            %%%%%%%%%%%%%%%%
        case 24 % set all linestyles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAUTOLINESTYLE(figure_handle,axislist(q),1);
            end
            
        case 25 % set all linestyles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAUTOLINESTYLE(figure_handle,axislist(q),2);
            end
            
        case 26 % set all linestyles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAUTOLINESTYLE(figure_handle,axislist(q),3);
            end           
            
        case 27 % remove all linestyles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAUTOLINESTYLE(figure_handle,axislist(q),4);
            end
            
            
        case 28 % set markers
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAUTOMARKERS(figure_handle,axislist(q),1);
            end
            
        case 29 % remove markers
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAUTOMARKERS(figure_handle,axislist(q),0);
            end    
            
            
        case 30 % marker size
            % get the line handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                linelist=HVGETOBTYPE(axislist(q),'line');   
                if linelist(1)~=-1;
                    for q=1:length(linelist);
                        set(linelist(q),'markersize',3)
                    end
                end
            end
            
        case 31 % marker size
            % get the line handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                linelist=HVGETOBTYPE(axislist(q),'line');   
                if linelist(1)~=-1;
                    for q=1:length(linelist);
                        set(linelist(q),'markersize',6)
                    end
                end
            end
            
        case 32 % marker size
            % get the line handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                linelist=HVGETOBTYPE(axislist(q),'line');    
                if linelist(1)~=-1;
                    for q=1:length(linelist);
                        set(linelist(q),'markersize',9)
                    end
                end
            end
            
        case 33 % marker size
            % get the line handles
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                linelist=HVGETOBTYPE(axislist(q),'line');  
                if linelist(1)~=-1;
                    for q=1:length(linelist);
                        set(linelist(q),'markersize',12)
                    end
                end
            end
            
        case 34 % remove all lines
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHAUTOLINESTYLE(figure_handle,axislist(q),5);
            end
            
        case 35  % linewidth
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHSETALLLINEWIDTH(axislist(q),0.1);
            end
            
        case 36  % linewidth
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHSETALLLINEWIDTH(axislist(q),0.25);
            end
            
        case 37  % linewidth
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHSETALLLINEWIDTH(axislist(q),0.5);
            end
            
        case 38  % linewidth
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHSETALLLINEWIDTH(axislist(q),1);
            end
            
        case 39  % linewidth
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHSETALLLINEWIDTH(axislist(q),2.5);
            end           
            
        case 40  % linewidth
            axislist=HVGETOBTYPE(figure_handle,'axes');
            for q=1:length(axislist);
                HVGRAPHSETALLLINEWIDTH(axislist(q),5);
            end
            
    end % switch 
    
end % if defineflag==1