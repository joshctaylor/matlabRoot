% subfunction used within the HVGRAPH routines to set the axis labels by
% checking the stored axis label properties of each line on the graph
%
% function [] = HVGRAPHAUTOLABEL (figure_handle);

function [] = HVGRAPHAUTOLABEL (figure_handle);

% get the axis handles
axishandles=HVGETOBTYPE(figure_handle,'axes');

% loop through each axis
for q=1:length(axishandles);
    
    % check for a legend
islegend=HVGRAPHISLEGEND(axishandles(q));
    
    % if axis is not a legend:
    if islegend==0
        
        % loop through children
        linehandles=HVGETOBTYPE(axishandles(q),'line');
        if length(linehandles)>1
            
            for r=1:length(linehandles)
                
                % get the axis labels stored for each line
                lineuserdata=get(linehandles(r),'userdata');
                linelabel(r).x=lineuserdata.xlabel;
                linelabel(r).y1=lineuserdata.ylabel1;
                linelabel(r).y2=lineuserdata.ylabel2;
                linelabel(r).matchx=0;
                linelabel(r).matchy1=0;
                linelabel(r).matchy2=0;
            end % for r=1:length(linehandles)
            
            %check if labels are identical
            
            % generate a binary sequence
            bseq=2.^[0:(length(linelabel)-1)];
            % loop through each label
            for r=1:length(linelabel)
                
                %compare with all other labels
                
                for s=1:length(linelabel)
                    
                    % check for x match
                    if length(linelabel(r).x)==length(linelabel(s).x);
                        if linelabel(r).x==linelabel(s).x
                            linelabel(s).matchx=linelabel(s).matchx+bseq(r); % increment a binary sequence
                        end 
                    end
                    
                    % check for y1 match
                    if length(linelabel(r).y1)==length(linelabel(s).y1);
                        if linelabel(r).y1==linelabel(s).y1
                            linelabel(s).matchy1=linelabel(s).matchy1+bseq(r); % increment a binary sequence
                        end 
                    end
                    
                    % check for y2 match
                    if length(linelabel(r).y2)==length(linelabel(s).y2);
                        if linelabel(r).y2==linelabel(s).y2
                            linelabel(s).matchy2=linelabel(s).matchy2+bseq(r); % increment a binary sequence
                        end 
                    end
                    
                    
                end % for s=1:length(linelabel)
                
            end % for r=1:length(linelabel)
            
            % extract the different axis labels
            
            for r=1:length(linelabel)
                xflags(r)=(linelabel(r).matchx);
                y1flags(r)=(linelabel(r).matchy1);
                y2flags(r)=(linelabel(r).matchy2);
            end % for r=1:length(linelabel)
            
            % sort and remove duplicates
            xflags=sort(xflags);
            y1flags=sort(y1flags);
            y2flags=sort(y2flags);
            
            xflagsnd=xflags(1);
            y1flagsnd=y1flags(1);
            y2flagsnd=y2flags(1);
            for r=2:length(linelabel)
                if xflags(r)~=xflags(r-1)
                    xflagsnd(r)=xflags(r);
                end
                if y1flags(r)~=y1flags(r-1)
                    y1flagsnd(r)=y1flags(r);
                end
                if y2flags(r)~=y2flags(r-1)
                    y2flagsnd(r)=y2flags(r);
                end
                
            end % 1:length(linelabel)
            
            
            % generate the legend strings
            
            xlegend=[];
            for r=1:length(xflagsnd)
                xbin=dec2bin(xflagsnd(r));
                useflag=1;
                for s=1:length(xbin)
                    if and(xbin(s),useflag)
                        if length(xlegend)==0
                            xlegend=linelabel(r).x;
                        else
                        xlegend=[xlegend,', ',linelabel(r).x];
                    end
                        useflag=0;
                    end
                end
            end % for r=1:length(xflagsnd)

                        y1legend=[];
            for r=1:length(y1flagsnd)
                y1bin=dec2bin(y1flagsnd(r));
                useflag=1;
                for s=1:length(y1bin)
                    if and(y1bin(s),useflag)
                        if length(y1legend)==0
                            y1legend=linelabel(r).y1;
                        else
                        y1legend=[y1legend,', ',linelabel(r).y1];
                    end
                        useflag=0;
                    end
                end
            end % for r=1:length(y1flagsnd)

                        y2legend=[];
            for r=1:length(y2flagsnd)
                y2bin=dec2bin(y2flagsnd(r));
                useflag=1;
                for s=1:length(y2bin)
                    if and(y2bin(s),useflag)
                        if length(y2legend)==0
                            y2legend=linelabel(r).y2;
                        else
                        y2legend=[y2legend,', ',linelabel(r).y2];
                    end
                        useflag=0;
                    end
                end
            end % for r=1:length(y2flagsnd)
            
            
            % set the legends
                  set(get(axishandles(q),'xlabel'),'string',xlegend);
            set(get(axishandles(q),'ylabel'),'string',y1legend);      
            
            
            
        else % if length(linehandles)>1
            
            if linehandles==-1
                
                % if there are no lines do nothing. 
            else
            
            % use the axis data to set the axis labels
            lineuserdata=get(linehandles,'userdata');
            xlegend=lineuserdata.xlabel;
            y1legend=lineuserdata.ylabel1;
            y2legend=lineuserdata.ylabel2;
            
            set(get(axishandles(q),'xlabel'),'string',xlegend);
            set(get(axishandles(q),'ylabel'),'string',y1legend);
            
            %only one line so use the labels directly
            
        end %  if linehandles==-1
            
        end % if length(linehandles)>1

    end % if skipplot==0 
end % q=1:length(axishandles)


