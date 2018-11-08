% function to generate a uicontextmenu for an axis
% 
% function [] = HVAXISCMENU (switchcode,axis_handle,figure_handle,defineflag);
% set defineflag=1 to generate the context menu for an axis
% written TPG 15/6/2004
% Modified TPG 24/6/2004 to add axis scaling options and use
% HVGRAPHAPPLYTOALL and HVGRAPHAXISSCALE. Added automatic line style
% options using HVGRAPHAUTOLINESTYLE. Rearranged axes. Added automatic
% marker set/remove option and marker size options. 

function [] = HVAXISCMENU (switchcode,axis_handle,figure_handle,defineflag);


if exist('defineflag');
    
    % generate the context menu 
    cmenu = uicontextmenu;
    
    set(axis_handle,'uicontextmenu',cmenu);
    
    uimenu(cmenu, 'Label', 'Cursor', 'Callback', 'HVAXISCMENU(16,gca,gcf)');
    
    ascalemenu=uimenu(cmenu, 'Label', 'Axis ranges');
    
    uimenu(ascalemenu, 'Label', 'Manual', 'Callback', 'HVAXISCMENU(7,gca,gcf)');
    
    autoscalemenu=uimenu(ascalemenu, 'Label', 'Autoscale');
    uimenu(autoscalemenu, 'Label', 'x only', 'Callback', 'HVAXISCMENU(5,gca,gcf)');
    uimenu(autoscalemenu, 'Label', 'y only', 'Callback', 'HVAXISCMENU(6,gca,gcf)');
    uimenu(autoscalemenu, 'Label', 'Both', 'Callback', 'HVAXISCMENU(4,gca,gcf)');
    
    zoommenu=uimenu(ascalemenu, 'Label', 'Zoom');
    uimenu(zoommenu, 'Label', 'x only', 'Callback', 'HVAXISCMENU(1,gca,gcf)');
    uimenu(zoommenu, 'Label', 'y only', 'Callback', 'HVAXISCMENU(2,gca,gcf)');
    uimenu(zoommenu, 'Label', 'Both', 'Callback', 'HVAXISCMENU(3,gca,gcf)');
    
    scalemenu=uimenu(ascalemenu, 'Label', 'Axis scales');
    uimenu(scalemenu, 'Label', 'linear x, linear y', 'Callback', 'HVAXISCMENU(17,gca,gcf)');
    uimenu(scalemenu, 'Label', 'log x, linear y', 'Callback', 'HVAXISCMENU(18,gca,gcf)');
    uimenu(scalemenu, 'Label', 'linear x, log y', 'Callback', 'HVAXISCMENU(19,gca,gcf)');
    uimenu(scalemenu, 'Label', 'log x, log y', 'Callback', 'HVAXISCMENU(20,gca,gcf)');
    
    copymenu=uimenu(ascalemenu, 'Label', 'Apply scaling to all axes');
    uimenu(copymenu, 'Label', 'x only', 'Callback', 'HVAXISCMENU(14,gca,gcf)');
    uimenu(copymenu, 'Label', 'y only', 'Callback', 'HVAXISCMENU(15,gca,gcf)');
    uimenu(copymenu, 'Label', 'Both', 'Callback', 'HVAXISCMENU(13,gca,gcf)');
    
    alinemenu=uimenu(cmenu, 'Label', 'Line styling');
    
    autolinestylemenu=uimenu(alinemenu, 'Label', 'Style and colour');
    uimenu(autolinestylemenu, 'Label', 'Line styles', 'Callback', 'HVAXISCMENU(21,gca,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Line colours', 'Callback', 'HVAXISCMENU(22,gca,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Both', 'Callback', 'HVAXISCMENU(23,gca,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Neither', 'Callback', 'HVAXISCMENU(26,gca,gcf)');
    uimenu(autolinestylemenu, 'Label', 'Hide lines', 'Callback', 'HVAXISCMENU(31,gca,gcf)');
    
    linewidthmenu=uimenu(alinemenu, 'Label', 'Line width');
    uimenu(linewidthmenu, 'Label', '0.1', 'Callback', 'HVAXISCMENU(32,gca,gcf)');
    uimenu(linewidthmenu, 'Label', '0.25', 'Callback', 'HVAXISCMENU(33,gca,gcf)');
    uimenu(linewidthmenu, 'Label', '0.5 (default)', 'Callback', 'HVAXISCMENU(34,gca,gcf)');
    uimenu(linewidthmenu, 'Label', '1.0', 'Callback', 'HVAXISCMENU(35,gca,gcf)');
    uimenu(linewidthmenu, 'Label', '2.5', 'Callback', 'HVAXISCMENU(36,gca,gcf)');
    uimenu(linewidthmenu, 'Label', '5.0', 'Callback', 'HVAXISCMENU(37,gca,gcf)');
    
    automarkermenu=uimenu(alinemenu, 'Label', 'Markers');
    uimenu(automarkermenu, 'Label', 'Set markers', 'Callback', 'HVAXISCMENU(24,gca,gcf)');
    
    markersizemenu=uimenu(automarkermenu, 'Label', 'Set marker size');
    uimenu(markersizemenu, 'Label', '3', 'Callback', 'HVAXISCMENU(27,gca,gcf)');
    uimenu(markersizemenu, 'Label', '6 (default)', 'Callback', 'HVAXISCMENU(28,gca,gcf)');
    uimenu(markersizemenu, 'Label', '9', 'Callback', 'HVAXISCMENU(29,gca,gcf)');
    uimenu(markersizemenu, 'Label', '12', 'Callback', 'HVAXISCMENU(30,gca,gcf)');
    
    uimenu(automarkermenu, 'Label', 'Remove markers', 'Callback', 'HVAXISCMENU(25,gca,gcf)');
    
    uimenu(cmenu, 'Label', 'Set units for all lines', 'Callback', 'HVAXISCMENU(10,gca,gcf)');
    
    
    
else % if the call is for a menu operation rather than to generate the menu:
    
    switch switchcode
        case 1 % zoom x
            
            % get values
            rng=ginput(2);
            
            xmin=rng(1,1);
            xmax=rng(2,1);
            
            % flip scale order if minimum is greater than maximum
            if (xmax<xmin)
                holdval=xmin;
                xmin=xmax;
                xmax=holdval;
            end
            
            % if ranges are equal then abort
            if xmax==xmin;
                fprintf('\nX axis range is zero. It is not possible to rescale the data');
                return;
            end
            
            set(axis_handle,'xlim',[xmin,xmax]);
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
            
        case 2 % zoom y
            
            % get values
            rng=ginput(2);
            
            
            ymin=rng(1,2);
            ymax=rng(2,2);
            
            % flip scale order if minimum is greater than maximum
            
            if (ymax<ymin)
                holdval=ymin;
                ymin=ymax;
                ymax=holdval;
            end
            
            % if ranges are equal then abort
            if ymax==ymin;
                fprintf('\nY axis range is zero. It is not possible to rescale the data');
                return;
            end
            
            set(axis_handle,'ylim',[ymin,ymax]);;
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
            
        case 3 % zoom both
            
            % get values
            rng=ginput(2);
            
            xmin=rng(1,1);
            xmax=rng(2,1);
            
            ymin=rng(1,2);
            ymax=rng(2,2);
            
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
                return;
            end
            
            set(axis_handle,'xlim',[xmin,xmax]);
            set(axis_handle,'ylim',[ymin,ymax]);
            
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
            
        case 4 % Autoscale
            
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(figure_handle);
            
            % get the data handles
            linelist=HVGETOBTYPE(axis_handle,'line');
            
            for r=1:length(linelist);
                
                % get the maximum and minimum values
                xmin(r)=min(get(linelist(r),'xdata'));
                xmax(r)=max(get(linelist(r),'xdata'));
                ymin(r)=min(get(linelist(r),'ydata'));
                ymax(r)=max(get(linelist(r),'ydata'));
            end
            
            % set the axis range, ovverscaling the y axis by 5%
            yr=(max(ymax)-min(ymin)).*0.05;
            set(axis_handle,'xlim',[min(xmin),max(xmax)]);
            set(axis_handle,'ylim',[min(ymin)-yr,max(ymax)+yr]);
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 5 % Autoscale x
            
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(figure_handle);
            
            % get the data handles
            linelist=HVGETOBTYPE(axis_handle,'line');
            
            for r=1:length(linelist);
                
                % get the maximum and minimum values
                xmin(r)=min(get(linelist(r),'xdata'));
                xmax(r)=max(get(linelist(r),'xdata'));
                
            end
            
            % set the axis range
            
            set(axis_handle,'xlim',[min(xmin),max(xmax)]);
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
            
        case 6 % Autoscale y
            
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(figure_handle);
            
            % get the data handles
            linelist=HVGETOBTYPE(axis_handle,'line');
            
            for r=1:length(linelist);
                
                % get the maximum and minimum values
                
                ymin(r)=min(get(linelist(r),'ydata'));
                ymax(r)=max(get(linelist(r),'ydata'));
            end
            
            % set the axis range, ovverscaling the y axis by 5%
            yr=(max(ymax)-min(ymin)).*0.05;
            
            set(axis_handle,'ylim',[min(ymin)-yr,max(ymax)+yr]);
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
        case 7 % open 'axis limits' window
            
            % open the rescale window
            limitpopuph=hgload('hvrescaleaxisGUI');
            
            % position it
            set(limitpopuph,'units','pixels');
            mpos=get(figure_handle,'position');
            ppos=get(limitpopuph,'position');
            newpos(1)=mpos(1)+mpos(3)./2-ppos(3)./2;
            newpos(2)=mpos(2)+mpos(4)./2-ppos(4)./2;
            set(limitpopuph,'position',[newpos,ppos(3:4)]);
            
            
            % store the parent axis handle
            userdata.axishandle=axis_handle;
            userdata.figurehandle=figure_handle;
            set(limitpopuph,'UserData',userdata);
            
            
            
        case 8 % 'axis limits' window cancel
            
            % get the figure handle to prevent HVGRAPHSTYLE from complaining 
            userdata=get(gcf,'UserData');
            figure_handle=userdata.figurehandle;
            
            
            close(gcf);
            
            
        case 9 % 'axis limits' window OK
            
            % get the parent axis handle
            limitpopuphand=gcf;
            userdata=get(limitpopuphand,'Userdata');
            axis_handle=userdata.axishandle;
            figure_handle=userdata.figurehandle;
            
            % check legendstate
            reapplylegend=HVGETLEGENDSTATE(get(axis_handle,'parent'));
            
            % get the specified axis limits
            handlist=allchild(limitpopuphand);
            
            % get the textbox values
            xmin=str2num(get(findobj(handlist,'Tag','xmin'),'string'));
            xmax=str2num(get(findobj(handlist,'Tag','xmax'),'string'));
            ymin=str2num(get(findobj(handlist,'Tag','ymin'),'string'));
            ymax=str2num(get(findobj(handlist,'Tag','ymax'),'string'));
            
            % do not change values corresponding to an empty box
            currentrange(1:2)=get(axis_handle,'xlim');
            currentrange(3:4)=get(axis_handle,'ylim');
            
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
            
            set(axis_handle,'xlim',[xmin,xmax]);
            set(axis_handle,'ylim',[ymin,ymax]);
            
            % close the popup
            close(limitpopuphand);
            
            % turn the legends back on if required
            if reapplylegend==1;
                HVGRAPHMENU(5,figure_handle);
            end
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
            
        case 10 % open 'axis label' window
            
            % open the rescale window
            labelpopuph=hgload('hvaxislabelGUI');
            
            % position it
            set(labelpopuph,'units','pixels');
            mpos=get(figure_handle,'position');
            ppos=get(labelpopuph,'position');
            newpos(1)=mpos(1)+mpos(3)./2-ppos(3)./2;
            newpos(2)=mpos(2)+mpos(4)./2-ppos(4)./2;
            set(labelpopuph,'position',[newpos,ppos(3:4)]);
            
            
            % store the parent axis handle
            userdata.axishandle=axis_handle;
            userdata.figurehandle=figure_handle;
            set(labelpopuph,'UserData',userdata);
            
            
            % get the current axis labels
            xlabel=get(get(axis_handle,'xlabel'),'string');
            ylabel=get(get(axis_handle,'ylabel'),'string');
            
            % set the textbox values
            handlist=allchild(labelpopuph);
            set(findobj(handlist,'Tag','xlabel'),'string',xlabel);
            set(findobj(handlist,'Tag','ylabel'),'string',ylabel);
            
            
            
        case 11 % 'axis label' window cancel
            
            % get the figure handle to prevent HVGRAPHSTYLE from complaining 
            userdata=get(gcf,'UserData');
            figure_handle=userdata.figurehandle;
            
            
            close(gcf);
            
            
        case 12 % axis label' window OK. 
            
            %get the stored figure and axis handles
            labelpopuph=gcf;
            userdata=get(labelpopuph,'UserData');
            figure_handle=userdata.figurehandle;
            axis_handle=userdata.axishandle;
            
            
            % get the specified axis limits
            handlist=allchild(labelpopuph);
            
            % get the textbox values
            xlabel=get(findobj(handlist,'Tag','xlabel'),'string');
            ylabel=get(findobj(handlist,'Tag','ylabel'),'string');
            
            % set the axis labels for all lines
            
            % get the data handles
            linelist=HVGETOBTYPE(axis_handle,'line');
            
            
            if linelist(1)~=-1;
                for r=1:length(linelist);
                    % set line label string properties
                    
                    lineuserdata=get(linelist(r),'userdata');
                    if length(xlabel)>0
                        lineuserdata.xlabel=xlabel;
                    end
                    if length(ylabel)>0
                        lineuserdata.ylabel1=ylabel;
                    end
                    set(linelist(r),'userdata',lineuserdata);
                    
                    % update the line context menu
                    HVLINECMENU (0,linelist(r),figure_handle,1);
                    
                end % for r=1:length(linelist);
                
            end % if linelist(1)~=-1;
            
            % close the popup window
            close(labelpopuph);
            
            % relabel the graph
            HVGRAPHAUTOLABEL (figure_handle);
            
        case 13 % apply range to all axes
            
            HVGRAPHAPPLYTOALL(figure_handle,axis_handle,3);
            
        case 14 % apply x range to all axes
            
            HVGRAPHAPPLYTOALL(figure_handle,axis_handle,1); 
            
        case 15 % apply y range to all axes
            
            HVGRAPHAPPLYTOALL(figure_handle,axis_handle,2);
            
        case 16 % cursor
            
            cvals=ginput(1);
            fprintf(['\n',num2str(cvals(1)),', ',num2str(cvals(2))]);
            
        case 17 %  set axis scale linear x linear y
            HVGRAPHAXISSCALE(axis_handle,'linear','linear')
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 18 %  set axis scale log x linear y
            HVGRAPHAXISSCALE(axis_handle,'log','linear')
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 19 %  set axis scale linear x log y
            HVGRAPHAXISSCALE(axis_handle,'linear','log')
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 20 %  set axis scale log x log y
            HVGRAPHAXISSCALE(axis_handle,'log','log')
            % restyle if necessary
            HVGRAPHSTYLE(figure_handle)
            
        case 21 % set all linestyles
            HVGRAPHAUTOLINESTYLE(figure_handle,axis_handle,1);
            
        case 22 % set all linestyles
            HVGRAPHAUTOLINESTYLE(figure_handle,axis_handle,2);
            
        case 23 % set all linestyles
            HVGRAPHAUTOLINESTYLE(figure_handle,axis_handle,3);
            
        case 24 % set markers
            HVGRAPHAUTOMARKERS(figure_handle,axis_handle,1);
            
        case 25 % remove markers
            HVGRAPHAUTOMARKERS(figure_handle,axis_handle,0);
            
        case 26 % remove all linestyles
            HVGRAPHAUTOLINESTYLE(figure_handle,axis_handle,4);
            
        case 27 % marker size
            % get the line handles
            linelist=HVGETOBTYPE(axis_handle,'line');   
            if linelist(1)~=-1;
                for q=1:length(linelist);
                    set(linelist(q),'markersize',3)
                end
            end
            
        case 28 % marker size
            % get the line handles
            linelist=HVGETOBTYPE(axis_handle,'line');   
            if linelist(1)~=-1;
                for q=1:length(linelist);
                    set(linelist(q),'markersize',6)
                end
            end
            
        case 29 % marker size
            % get the line handles
            linelist=HVGETOBTYPE(axis_handle,'line');   
            if linelist(1)~=-1;
                for q=1:length(linelist);
                    set(linelist(q),'markersize',9)
                end
            end
            
        case 30 % marker size
            % get the line handles
            linelist=HVGETOBTYPE(axis_handle,'line');   
            if linelist(1)~=-1;
                for q=1:length(linelist);
                    set(linelist(q),'markersize',12)
                end
            end
            
        case 31 % remove all linestyles
            HVGRAPHAUTOLINESTYLE(figure_handle,axis_handle,5);  
            
            
        case 32  % linewidth
            HVGRAPHSETALLLINEWIDTH(axis_handle,0.1);
            
        case 33  % linewidth
            HVGRAPHSETALLLINEWIDTH(axis_handle,0.25);
            
        case 34  % linewidth
            HVGRAPHSETALLLINEWIDTH(axis_handle,0.5);
            
        case 35  % linewidth
            HVGRAPHSETALLLINEWIDTH(axis_handle,1);
            
        case 36  % linewidth
            HVGRAPHSETALLLINEWIDTH(axis_handle,2.5);
            
        case 37  % linewidth
            HVGRAPHSETALLLINEWIDTH(axis_handle,5);
            
            
        end % switch
        
    end % if exist('defineflag');
    
    
    
    
    
    
