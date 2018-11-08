%hvgraph - issue 3.0 (27/01/10) - HVLab HRV Toolbox
%--------------------------------------------------
%[figurehandle] = hvgraph(data, figureno, keyword, value,…)
% Displays data as formatted graphs.
%
%   figurehandle   =	handle to the figure object (optional)
%   datastruct 	   =	name of data structure containing the data to be
%                    	displayed
%   figure_number  =	the figure number to be used (optional)
%   keyword, value =	keyword strings, some with associated values, to 
%                       specify the formatting of the graph. All are 
%                       optional and are detailed in the user documentation 
%Examples:
%--------
%hvgraph(data(1)) Displays the first channel from the structure data
%hvgraph(data) Displays all channels from the structure data
%hvgraph(data(1,3,5:7)) Displays the selected channels from the structure
% 'data'
%hvgraph([data(3), mydata(5:7)]) Displays the selected channels from the
% structures 'data' and 'mydata'
%hvgraph([data, mydata]) Displays all channels from the structures 'data'
% and 'mydata'
%

% written TPG 15/3/2001 as 'graph.m'
% updated by TPG 31-10-2001 to 'DASgraphplot.m'
% renamed to hvgraph TPG 6/12/2001 and incorporating DASgraphplot code
% modified TPG 10/12/2001 to display complex channels as magnitude and phase in separate plots
% modified TPG 21/1/2002 to include the subplotorder option and debug a problem with the selection
% of rows and columns, and to include the automatic graphic style selection
% modified TPG 22/5/2002 to include all of the old HVLab functionality as command line options
% calls hvchancompress.m to remove empty channels from the input array.
% modified TPG 19/7/2002 to cope with dtype 3 (modphase) data.
% modified TPG 8/8/2002 to optionally output the axes handles using 'varargout'
% modified TPG 18/11/2003 to correct 'strfind' to 'findstr'
% modified TPG 18/11/2003 to wrap the 'axes' vector if more channels are present than axes
% modified TPG 18/11/2003 to correctly display one axis label on all axes if only one is specified
% modified TPG 25/11/2003 to allow the use of logarithmic scaling for the 'xdiv' and 'ydiv' arguments
% Modified TPG 23/12/2003 to include start and finish messages for the routine and to limit the length of the help.
% Modified TPG 11/6/2004 to use 'col' to set the line colour sequence
% Modified TPG 14/6/2004 to use the graphical interface. added uimenus and
% uicontextmenus. Check for existing figure and close before opening. Store
% figure property information in figure 'userdata' field. line objects
% store titles in userdata field
% Modified TPG 21/6/2004 to correct an error in the display of the real part of complex data.
% Modified TPG 23/6/2004 to allow 'n' for 'none' as a linestyle option and to
% specify linestyles as sections of a '2-bit' string. Added 'marker' option
% as a '1-bit' string.
% Modified TPG 23/6/2004 to allow integers to be included in the 'marker'
%'linestyle' and 'colour' strings. Renamed 'col' to 'colour'.
% Modified TPG 24/6/2004 to add xscale and yscale fields to the line
% userdata. Linestyles now cycle through all 4 styles rather than 3.
% Modified TPG 12/10/2004 to use US color spelling, fix a bug with grid
% that displays grids on all graphs if only one grid axis is specified,
% enable user-defined titles and default axis titles,
% Modified TPG 10/12/2004 to correctly handle an error whereby the user
% provides more 'axes' for displaying data than the number of data channels to display.
% Modified TPG 16/12/2004 to prevent the linestyles and colors resetting when the
% 'apply scaling to all axes' option is selected and to preserve line
% colors by default when overlaying data.
% Modified TPG 16/12/2004 to fix the 'merge axis' crash when empty axes are
% present.
% Modified TPG 5/1/2005 to correct a bug that caused graphs to be plotted
% on incorrect axes when using the 'axes' option.
% Modified TPG 8/2/2005 to default to 'both' when complex or real/imaginary
% data is present
% Modified CHL 27/1/2010 to bring HELP in line with technical manual

% HVgraph can optionally return the axis handles for each of the axes
%
% axishandles=hvgraph(data)
%
% Any or all of the following options can also be added
%
% -An option to reuse the last figure or to create a new figure wirndon. Defaults to 'new'.
% Example: hvgraph(data, 'new') or hvgraph(data) displays the graphs in a new figure window
%          hvgraph(data, 'reuse') displays the graphs in the last opened
%          figure window
%
% -The method of treating complex or modulu/phase data:
% 'realmod' displays only the modulus or real part
% 'imagphase' displays only the phase or imaginary part
% 'both' displays both parts separately producing two graphs per channel
% Example: hvgraph(data,'both') displays the modulus and phase (or real and imaginary) part of each
% channel on a separate axis. If data contains 5 channels then 10 axes will be displayed.
%
% -The number of rows and columns ('nrows','ncols')
% Example: hvgraph(data, 'nrows',2,'ncols',3]) displays the channels stored in data on up to 6 axes arranged in
% 2 rows of 3 columns each. Axis 1 is on the top left, axis 2 is the next in that row:
%
%     --------------------------------
%     |          |         |         |
%     |  axis #1 | axis #2 | axis #3 |
%     |          |         |         |
%     --------------------------------
%     |          |         |         |
%     |  axis #4 | axis #5 | axis #6 |
%     |          |         |         |
%     --------------------------------
%
% -The specific arrangement of graphs on each axis ('axes' or 'overlay')
% Example 1: hvgraph(data,'axes',[1,3,2,2]) displays the first channel on axis 1, the second channel
% on axis 3 and the remaining two channels on axis 2.
% Example 2: hvgraph(data,'overlay') displays all channels on the same plot
%
% -The type of scale for each axis. Linear axes are assumed unless on of these options is used:
% 'logx' and/or 'logy' specifies that log scales should be % used for the x and/or y
% axes of all graphs.
% Example 1: hvgraph(data,'logy') uses log scales for the y-axes of all axes
% Example 2: hvgraph(data,'logx',[1,2,5]) uses log scales for axes 1,2 and 5.
%
% -The limits for each axis.
% 'xlim',[min,max] specifies the minimum and maximum values for the x axis axis. If [min,max] has
% columns then the first row is used for the first axis and so on. 'xlim and 'ylim' are
% interchangeable. One or both can be used.
% Example 1: hvgraph(data,'xlim',[0,10]) displays each axis using an x-axis from 0 to 10.
% Example 2: ylimits=[1,5;6,10;11,15]; hvgraph(data,'ylim',ylimits) displays the first axis with a y
% axis from 1 to 5, the second axis with a y axis from 6 to 10 and the third axis with a y axis from
% 11 to 15. Axis 4 would use the same range as axis 1, axis 5 as axis 2 and so on.
%
% -The divisions to be used for each axis.
% 'xdiv',[divisions] specifies the tick divisions for the x axis axis. Each row should contain the
% first value, the interval and the last value. If [divisions] has columns then the first row is
% used for the first axis and so on. 'xdiv and 'ydiv' are % interchangeable. One or both can be used.
% Example 1: hvgraph(data,'xdiv',[0,2,10]) displays each axis using an x-axis with marks at 0,2,4,6,
% 8 and 10.
% Example 2: ydivisions=[1,1,5;6,2,10;11,1,15]; hvgraph(data,'ylim',ylimits) displays the first axis
% with y-axis divisions of 1,2,3,4 and 5, the second axis with  y axis divisions 6,8 and 10 and the
% third axis with  y axis divisisions 11,12,13,14 and 15. Axis 4 would use the same range as axis 1,
% axis 5 as axis 2 and so on.
%
% -The title and axis labels for all graphs or individual axes (using ; as a separator). By default
% channel title of the first line on the graph will be used. Using 'title','xlabel' or 'ylabel' will
% override this. Including empty titles (e.g. ;;) will use the channel title or label for that graph.
% Example 1: hvgraph(data,'title','Title will appear on axis 1, no other titles will be shown.')
% Example 2: hvgraph(data,'title','Axis 1 title;Axis 2 title;Axis 3 title') Individual titles
% Example 3: hvgraph(data,'title','Axis 1 title;;Axis 3 title') Individual titles for axes 1 and 3
% and the default title for axis 2.
% Example 3: hvgraph(data,'title','Axis 1 title;' ';Axis 3 title') Individual titles for axes 1 and 3
% and no title for axis 2.
% Example 4: hvgraph(data,'xlabel','X label for all axes')
% Example 5: hvgraph(data,'ylabel','Axis 1 y label;Axis 2 y label;Axis 3 y label')
% Example 6: hvgraph(data,'ylabel','Axis 1 y label;;Axis 3 y label') % Default label for axis 2.
%
% -Hide the labels or axis numbering: 'hidetext' and 'hidenumbers'
% Example 1: hvgraph(data,'hidetext') Does not display any axis labels or titles on all axes
% Example 2: hvgraph(data,'hidenumbers') Does not display any axis numbering
% Example 3: hvgraph(data,'hidetext',[2,3],'hidenumbers',[2,3]) Does not display any axis numbering
% or text on axes 2 and 3.
%
% -Join the axes together: 'merge'
% Example 1: hvgraph(data,'ncols',3,'nrows',2,'merge') Displays 2 rows of 3 axes with no gaps or
% labelling between the axes.


function [varargout] = hvgraph (varargin)

% HVCHECKARGUMENT not used due to the use of varargin cell array

% User message
HVFUNPAR('Displaying the dataset');

% convert the variable length input cell array to a structure
args=cell2struct(varargin,'arg');

% look for each argument in turn checking which arguments are taken
erron=0; % error switch
taken=[]; % account for all arguments
datatypecheck=0; % data type error flag
args(length(args)+1).arg=''; % add an extra null entry.
for q=1:length(args);
    % look for the data structure first (chans,nchans,chanind)
    if isstruct(args(q).arg);
        taken=[taken,q];
        [chans,nchans,chanind]= hvchancompress(args(q).arg);
        % END OF DATA


        % check through all string arguments
    elseif isstr(args(q).arg)==1
        switch args(q).arg


            % REALMOD: complexdata='realmod'
            case 'realmod'
                % check for several settings of the same switch
                if datatypecheck==0
                    taken=[taken,q];
                    datatypecheck=1;
                    complexdata='realmod';
                else
                    fprintf('More than one data type setting chosen.\n')
                    erron=1;
                end
                % END OF REALMOD


                % IMAGPHASE: complexdata='imagphase'
            case 'imagphase'
                % check for several settings of the same switch
                if datatypecheck==0
                    taken=[taken,q];
                    datatypecheck=1;
                    complexdata='imagphase';
                else
                    fprintf('More than one data type setting chosen.\n')
                    erron=1;
                end
                % END OF IMAGPHASE



                % BOTH: complexdata='both'
            case 'both'
                % check for several settings of the same switch
                if datatypecheck==0
                    taken=[taken,q];
                    datatypecheck=1;
                    complexdata='both';
                else
                    fprintf('More than one data type setting chosen.\n')
                    erron=1;
                end
                % END OF BOTH



                % NROWS: nrows=n,
            case 'nrows'
                if and(length(args(q+1).arg)==1,isstr(args(q+1).arg)==0)
                    taken=[taken,q,q+1];
                    nrows=args(q+1).arg;
                else
                    fprintf('There is a problem with the nrows setting.\n')
                    erron=1;
                end
                % END OF NROWS



                % NCOLS:  ncols=n
            case 'ncols'
                if and(length(args(q+1).arg)==1,isstr(args(q+1).arg)==0)
                    taken=[taken,q,q+1];
                    ncols=args(q+1).arg;
                else
                    fprintf('There is a problem with the ncols setting.\n')
                    erron=1;
                end
                % END OF NCOLS


                % AXES: plotaxes=[vector];
            case 'axes'
                if and(length(args(q+1).arg)>1,isstr(args(q+1).arg)==0) % if a vector is specified
                    taken=[taken,q,q+1];
                    plotaxes=args(q+1).arg;
                else
                    fprintf('There is a problem with the axes setting.\n')
                    erron=1;

                end
                % END OF AXES

                % COLOR: coloraxis=[vector];
            case 'color'
                taken=[taken,q,q+1];
                rawcoloraxis=args(q+1).arg;
                % parse the vector for any integer elements
                ccount=1;
                for cci=1:length(rawcoloraxis);
                    if str2num(rawcoloraxis(cci))>0;
                        nrpt=str2num(rawcoloraxis(cci));
                        coloraxis(ccount:ccount+nrpt-1)=rawcoloraxis(cci+1);
                        ccount=ccount+nrpt-1;
                    else
                        coloraxis(ccount)=rawcoloraxis(cci);
                        ccount=ccount+1;
                    end
                end
                % END OF COLOR


                % LINESTYLE: linestyles=[vector];
            case 'linestyle'
                taken=[taken,q,q+1];
                rawlinestyles=args(q+1).arg;
                % parse the vector for any integer elements
                lcount=1;
                for lni=1:length(rawlinestyles);
                    if str2num(rawlinestyles(lni))>0;
                        nrpt=str2num(rawlinestyles(lni))-1; % add an extra N-1 elements in place of the number
                        for lrpt=1:nrpt
                            linestyles([lcount:lcount+1])=rawlinestyles([lni+1,lni+2]);
                            lcount=lcount+2; % add a 2-bit element
                        end
                    else
                        linestyles(lcount)=rawlinestyles(lni);
                        lcount=lcount+1;
                    end
                end
                % END OF LINESTYLE

                % LINEWIDTH: linewidths=[vector], 2 elements per style;
            case 'linewidth'
                taken=[taken,q,q+1];
                linewidths=args(q+1).arg;
                % END OF LINEWIDTH

                % MARKER: markers=[vector], one element per style;
            case 'marker'
                taken=[taken,q,q+1];
                rawmarkers=args(q+1).arg;
                % parse the vector for any integer elements
                mcount=1;
                for mki=1:length(rawmarkers);
                    if str2num(rawmarkers(mki))>0;
                        nrpt=str2num(rawmarkers(mki));
                        markers(mcount:mcount+nrpt-1)=rawmarkers(mki+1);
                        mcount=mcount+nrpt-1;
                    else
                        markers(mcount)=rawmarkers(mki);
                        mcount=mcount+1;
                    end
                end
                % END OF MARKER


                % OVERLAY: overlay=1
            case 'overlay'
                taken=[taken,q];
                overlay=1;
                % END OF OVERLAY



                % LOGX: logx=-1 or =[vector]
            case 'logx'
                if isstr(args(q+1).arg)==0 % if a vector is specified
                    taken=[taken,q,q+1];
                    logx=args(q+1).arg;
                else
                    taken=[taken,q]; % if a vector is not specified
                    logx=-1;
                end
                % END OF LOGX


                % LOGY: logy=-1 or =[vector]
            case 'logy'
                if isstr(args(q+1).arg)==0 % if a vector is specified
                    taken=[taken,q,q+1];
                    logy=args(q+1).arg;
                else
                    taken=[taken,q]; % if a vector is not specified
                    logy=-1;
                end
                % END OF LOGX


                % GRID: gridon=-1 or =[vector]
            case 'grid'
                if isstr(args(q+1).arg)==0 % if a vector is specified
                    taken=[taken,q,q+1];
                    gridon=args(q+1).arg;
                else
                    taken=[taken,q]; % if a vector is not specified
                    gridon=-1;
                end
                % END OF LOGX



                % XLIM: xlim=[2 element vector] or [2 column matrix]
            case 'xlim'
                if and(size(args(q+1).arg,2)==2,isstr(args(q+1).arg)==0)
                    taken=[taken,q,q+1];
                    xlim=args(q+1).arg;
                else
                    fprintf('There is a problem with the xlim setting.\n')
                    erron=1;
                end
                % END OF XLIM



                % YLIM: ylim=[2 element vector] or [2 column matrix]
            case 'ylim'
                if and(size(args(q+1).arg,2)==2,isstr(args(q+1).arg)==0)
                    taken=[taken,q,q+1];
                    ylim=args(q+1).arg;
                else
                    fprintf('There is a problem with the ylim setting.\n')
                    erron=1;
                end
                % END OF YLIM


                % XDIV: xdiv=[row vector] or [matrix]
            case 'xdiv'
                if and(size(args(q+1).arg,2)==3,isstr(args(q+1).arg)==0)
                    taken=[taken,q,q+1];
                    xdiv=args(q+1).arg;
                else
                    fprintf('There is a problem with the xdiv setting.\n')
                    erron=1;
                end
                % END OF XDIV



                % YDIV: xdiv=[row vector] or [matrix]
            case 'ydiv'
                if and(size(args(q+1).arg,2)==3,isstr(args(q+1).arg)==0)
                    taken=[taken,q,q+1];
                    ydiv=args(q+1).arg;
                else
                    fprintf('There is a problem with the ydiv setting.\n')
                    erron=1;
                end
                % END OF YDIV


                % TITLE: store as string <axistitle> or structure <axistitle(n).title>
            case 'title'
                % check the title is a string
                if isstr(args(q+1).arg)==1
                    taken=[taken,q,q+1];

                    % see if more than one label is specified separated by ;
                    nstrings=findstr(args(q+1).arg,';');
                    if nstrings>0
                        nstrings=[0,nstrings,length(args(q+1).arg)+1];
                        for r=1:length(nstrings)-1
                            axistitle(r).title=args(q+1).arg(nstrings(r)+1:nstrings(r+1)-1);
                        end % FOR title extraction
                    else
                        axistitle=args(q+1).arg;
                    end % IF title has several entries separated by ;
                else
                    fprintf('The title does not seem to be a string.')
                    erron=1;
                end
                % END OF TITLE


                % XLABEL: store as string <xaxislabel> or structure <xaxislabel(n).label>
            case 'xlabel'
                % check the title is a string
                if isstr(args(q+1).arg)==1
                    taken=[taken,q,q+1];

                    % see if more than one label is specified separated by ;
                    nstrings=findstr(args(q+1).arg,';');
                    if nstrings>0
                        nstrings=[0,nstrings,length(args(q+1).arg)+1];
                        for r=1:length(nstrings)-1
                            xaxislabel(r).label=args(q+1).arg(nstrings(r)+1:nstrings(r+1)-1);
                        end % FOR title extraction
                    else
                        xaxislabel=args(q+1).arg;
                    end % IF title has several entries separated by ;
                else
                    fprintf('The xlabel does not seem to be a string.')
                    erron=1;
                end
                % END OF XLABEL


                % YLABEL: store as string <yaxislabel> or structure <yaxislabel(n).label>
            case 'ylabel'
                % check the title is a string
                if isstr(args(q+1).arg)==1
                    taken=[taken,q,q+1];

                    % see if more than one label is specified separated by ;
                    nstrings=findstr(args(q+1).arg,';');
                    if nstrings>0
                        nstrings=[0,nstrings,length(args(q+1).arg)+1];
                        for r=1:length(nstrings)-1
                            yaxislabel(r).label=args(q+1).arg(nstrings(r)+1:nstrings(r+1)-1);
                        end % FOR title extraction
                    else
                        yaxislabel=args(q+1).arg;
                    end % IF title has several entries separated by ;
                else
                    fprintf('The ylabel does not seem to be a string.')
                    erron=1;
                end
                % END OF XLABEL


                % HIDETEXT: hidetext=1
            case 'hidetext'
                taken=[taken,q];
                hidetext=1;
                % END OF HIDETEXT


                % HIDENUMBERS: hidenumbers=1
            case 'hidenumbers'
                taken=[taken,q];
                hidenumbers=1;
                % END OF HIDENUMBERS


                % MERGE: mergeaxes=1
            case 'merge'
                taken=[taken,q];
                mergeaxes=1;
                % END OF MERGE


        end % ENDCASE

    end % IF looking at arguments not data

end % endFOR


% check for a left over integer to use as the figure number
args=args(1:length(args)-1); % remove the extra null entry.
if length(taken)==length(args)-1;
    for q=1:length(args)
        if q~=taken
            fignum=args(q).arg;
            taken=[taken,q];
        end
    end
end




% input checker
eval('checker1=sort(taken)==1:length(args);','erron=1;');
if exist('checker1')==1
    for q=1:length(checker1)
        if checker1(q)==0
            erron=1;
        end
    end
else
    erron=1;
end
if erron==1
    fprintf('Hvgraph has reported an error with the input variables and has stopped\n');
    return
end
% end of error checker

% Deal with the data type as specified by 'realmod','imagphase','both'
% Decide what to do. Data mode: 1 = real; 2 = real-and-imaginary; 3 = modulus-and-phase or polar.
% Default to 'both'
if datatypecheck==0;
    complexdata='both';
end
%if exist('complexdata')==1
if complexdata(1:4)=='real'
    for q=1:nchans
        if chans(q).dtype==2
            % extract the real part
            chans(q).y=real(chans(q).y);
        elseif chans(q).dtype==3
            chans(q).y=chans(q).y(:,1);
        end%IF
    end%FOR

elseif complexdata(1:4)=='imag'
    for q=1:nchans
        if chans(q).dtype==2
            % extract the imaginary part
            chans(q).y=imag(chans(q).y);
        elseif chans(q).dtype==3
            % extract the phase part
            chans(q).y=chans(q).y(:,2);
        end%IF
    end%FOR

elseif complexdata(1:4)=='both'
    chancount=1;
    while chancount<=nchans
        if chans(chancount).dtype==2
            % shuffle the remaining channels up one
            chans(chancount+1:nchans+1)=chans(chancount:nchans);
            nchans=nchans+1;
            % extract the real part
            chans(chancount).y=real(chans(chancount).y);
            % extract the imaginary part
            chans(chancount+1).y=imag(chans(chancount+1).y);
            chancount=chancount+2;
        elseif chans(chancount).dtype==3
            % shuffle the remaining channels up one
            chans(chancount+1:nchans+1)=chans(chancount:nchans);
            nchans=nchans+1;
            % a holding matrix
            holdchan=chans(chancount).y;
            % extract the modulus part
            chans(chancount).y=holdchan(:,1);
            % extract the phase part
            chans(chancount+1).y=holdchan(:,2);
            chancount=chancount+2;
        else
            chancount=chancount+1;
        end%IF
    end%FOR
end%IF both
%end%IF exist


% Find out how many rows and columns to use:
% Find out how many axes are needed
if exist('overlay')==1 % if overlay is defined then plot everything on the same axis
    nrows=1;
    ncols=1;
    plotaxes=ones(1,nchans);
end % if overlay is not defined, look for plotaxes, ncols and nrows.

if exist('plotaxes')==1
    naxes=max(plotaxes);
    % check for blank axes and shuffle if necessary to remove these
    for q=1:naxes;
        if sum(plotaxes==q)==0
            if q<=naxes
                HVFUNPAR(['\nAxis number ',num2str(q),' contained no graphs and has been removed']);
                plotaxes(plotaxes>=q)=plotaxes(plotaxes>=q)-1;
                naxes=naxes-1;
            end
        end
    end


    % check if there are more channels to plot than specified places to plot them
    if exist('plotaxes')
        naxes_spec=length(plotaxes);
    else
        naxes_spec=naxes;
    end
    if nchans>naxes_spec
        chancount=1;
        for q=1:ceil(nchans./(naxes_spec))
            for r=1:naxes_spec
                if chancount<=nchans
                    if exist('plotaxes')
                        plotaxes((q-1).*(naxes_spec)+r)=plotaxes(r);
                    else
                        plotaxes((q-1).*(naxes_spec)+r)=r;
                    end
                    chancount=chancount+1;
                end%IF chancount
            end%FOR r
        end% FOR q
        HVFUNPAR(['The ',num2str(nchans),' channels were wrapped onto the specified ',num2str(naxes_spec),' locations:'])
        HVFUNPAR(['Channel ',num2str(naxes_spec+1),' is on axis ',num2str(plotaxes(naxes_spec+1)),', channel ',num2str(naxes_spec+2),' is on axis ',num2str(plotaxes(naxes_spec+2)),' and so on'])
    end

else
    naxes=nchans;
end


%choose a suitable number of axes
if and(exist('ncols')==0,exist('nrows')==0)
    ncols=floor(sqrt(naxes));
    nrows=ceil(naxes./ncols);
elseif exist('ncols')==0
    ncols=ceil(naxes./nrows);
elseif exist('nrows')==0
    nrows=ceil(naxes./ncols);
end


% check if all the axes will fit on the row/column matrix and cycle then if necessary
if ncols.*nrows<naxes;
    if exist('plotaxes')==1
        nrows=ceil(naxes./ncols);
        HVFUNPAR(['Extra rows were added to fit the ',num2str(naxes),' axes requested by the ''axes'' option onto the figure'])
    else
        % loop through starting with axis 1 when the last axis is reached
        naxes=nrows.*ncols;
        chancount=1;
        for q=1:ceil(nchans./(naxes))
            for r=1:naxes
                if chancount<=nchans
                    plotaxes((q-1).*(naxes)+r)=r;
                    chancount=chancount+1;
                end%IF chancount
            end%FOR r
        end% FOR q
        HVFUNPAR(['The ',num2str(nchans),' channels were wrapped onto the specified ',num2str(naxes),' axes:'])
        HVFUNPAR(['Channel ',num2str(naxes+1),' is on axis 1, channel ',num2str(naxes+2),' is on axis 2 and so on'])
    end
end


% set plotaxes if this has not happened yet
if exist('plotaxes')==0
    plotaxes=1:nchans;
end


% open a figure window, closing it first if it already exists
if exist('fignum')==1
    eval('get(fignum,''type'');close(fignum)','')
    fhand=figure(fignum);
else
    fhand=figure;
end

% GUI: generate the figure pull-down menu
HVGRAPHMENU (0,fhand,1);

% loop through the axes
chanind=1:nchans;
for q=1:naxes

    % select the subplot
    sph(q)=subplot(nrows,ncols,q);

    % GUI: generate an axis RMB menu
    HVAXISCMENU (0,sph(q),fhand,1);

    % initialise linestyle counters and warn if too many graphs are on the same axis
    linestylecounter=1;
    linewidthcounter=1;
    colorcounter=1;
    if sum(plotaxes==q)>56
        HVFUNPAR(['There are more than 56 lines on axis ',num2str(q),':\n  Line 57 will have the same style as line 1, line 58 as line 2 and so on.'])
    end

    %check if more plot axes have been specified than data supplied
    if length(plotaxes)>length(chanind)
        HVFUNPAR([num2str(length(chanind)),' datasets have been provided with ',num2str(length(plotaxes)),' plotting locations'])
        plotaxes=plotaxes(1:length(chanind));
    end

    for r=chanind(plotaxes==q);

        % check if log scale should be used on the x axis
        if exist('logx')==1
            if length(logx)>1
                if sum(q==logx)
                    plogx=1;
                else
                    plogx=0;
                end
            else
                plogx=1;
            end
        else
            plogx=0;
        end

        % check if log scale should be used on the y axis
        if exist('logy')==1
            if length(logy)>1
                if sum(r==logy)
                    plogy=1;
                else
                    plogy=0;
                end
            else
                plogy=1;
            end
        else
            plogy=0;
        end

        % plot the data in log or linear format
        if and(plogx,plogy)
            ah=loglog(chans(r).x,chans(r).y);
            lineuserdata.xscale='log';
            lineuserdata.yscale='log';
        elseif plogx
            ah=semilogx(chans(r).x,chans(r).y);
            lineuserdata.xscale='log';
            lineuserdata.yscale='linear';
        elseif plogy
            ah=semilogy(chans(r).x,chans(r).y);
            lineuserdata.xscale='linear';
            lineuserdata.yscale='log';
        else
            ah=plot(chans(r).x,chans(r).y);
            lineuserdata.xscale='linear';
            lineuserdata.yscale='linear';
        end

        % set the channel title, x and y units and axis location in the userdata field
        if length(chans(r).title)==0
            lineuserdata.title='Untitled'
        else
            lineuserdata.title=chans(r).title;
        end
        lineuserdata.axis=q;
        lineuserdata.xlabel=chans(r).xunit;
        lineuserdata.ylabel1=chans(r).yunit;
        lineuserdata.ylabel2=chans(r).y2unit;
        lineuserdata.dtype=chans(r).dtype;
        set(ah,'userdata',lineuserdata);

        % GUI generate the line RMB menu
        HVLINECMENU (0,ah,fhand,1);


        % set the line color
        if exist('coloraxis')
            % use the user specified color sequence
            if r>length(coloraxis)
                set(ah,'color',coloraxis(r-length(coloraxis).*floor((r-1)./length(coloraxis))));
            else
                set(ah,'color',coloraxis(r));
            end
        else
            % use the automatic color sequence
            switch(colorcounter)
                case 1
                    set(ah,'color',[0,0,0]);
                case 2
                    set(ah,'color',[1,0,0]);
                case 3
                    set(ah,'color',[0,1,0]);
                case 4
                    set(ah,'color',[0,0,1]);
                case 5
                    set(ah,'color',[1,1,0]);
                case 6
                    set(ah,'color',[1,0,1]);
                case 7
                    set(ah,'color',[0,1,1]);
            end

        end


        % set the linewidth
        if exist('linewidths')
            % use the user spoecified color sequence
            if r>length(linewidths)
                set(ah,'linewidth',linewidths(r-length(linewidths).*floor((r-1)./length(linewidths))));
            else
                set(ah,'linewidth',linewidths(r));
            end
        else
            switch linewidthcounter
                case 1
                    set(ah,'linewidth',0.5)
                case 2
                    set(ah,'linewidth',2.0)
            end
        end


        if exist('linestyles')
            % use the user specified sequence
            if r>length(linestyles)./2
                in=(r-length(linestyles)./2.*floor((r-1)./length(linestyles).*2));
                if linestyles(in.*2-1)=='n';
                    set(ah,'linestyle','none');
                else
                    set(ah,'linestyle',linestyles([in.*2-1:in.*2]));
                end
            else
                if linestyles(r.*2-1)=='n';
                    set(ah,'linestyle','none');
                else
                    set(ah,'linestyle',linestyles([r.*2-1:r.*2]));
                end
            end

        else
            % set the linestyle
            switch linestylecounter
                case 1
                    set(ah,'linestyle','-')
                    linestylecounter=2;
                case 2
                    set(ah,'linestyle','--')
                    linestylecounter=3;
                case 3
                    set(ah,'linestyle',':')
                    linestylecounter=4;
                case 4
                    set(ah,'linestyle','-.')
                    % increment the linestyle counter
                    linestylecounter=1;
                    % increment the linewidth counter
                    if linewidthcounter==1;
                        linewidthcounter=2;
                    else
                        linewidthcounter=1;
                        % increment the color counter
                        if colorcounter==7
                            colorcounter=1;
                        else
                            colorcounter=colorcounter+1;
                        end
                    end
            end
        end


        if exist('markers')
            % use the user specified sequence, otherwise leave off
            if r>length(markers)
                in=(r-length(markers).*floor((r-1)./length(markers)));
                if markers(in)=='n'
                    set(ah,'marker','none');
                else
                    set(ah,'marker',markers(in));
                end
            else
                if markers(r)=='n'
                    set(ah,'marker','none');
                else
                    set(ah,'marker',markers(r));
                end
            end

        end


        hold on
    end %FOR r, channel loop


    % set x limits
    if exist('xlim')==1
        xlims=size(xlim);
        if xlims(1)>1
            % check if the number of settings equals the number of axes
            if xlims(1)<naxes
                % create a matrix for the necessary values
                xlim2=xlim;
                xlim=zeros(naxes,2);
                xlim(1:xlims(1),:)=xlim2;
                % replace the missing values by cycling the existing values
                for s=1:ceil(naxes./xlims(1))
                    for t=1:xlims(1)
                        if s.*xlims(1)+t<=naxes
                            xlim(s.*xlims(1)+t,:)=xlim(t,:);
                        end
                    end
                end
                HVFUNPAR(['Specific X axes ranges were only defined for ',num2str(xlims(1)),' of the ',num2str(naxes),' axes:'])
                HVFUNPAR('The specified ranges were used in a repeating sequence for the remaining axes.')
            end
            set(sph(q),'xlim',xlim(q,:));
        else
            set(sph(q),'xlim',xlim);
        end
    end


    % set y limits
    if exist('ylim')==1
        ylims=size(ylim);
        if ylims(1)>1
            % check if the number of settings equals the number of axes
            if ylims(1)<naxes
                % create a matrix for the necessary values
                ylim2=ylim;
                ylim=zeros(naxes,2);
                ylim(1:ylims(1),:)=ylim2;
                % replace the missing values by cycling the existing values
                for s=1:ceil(naxes./ylims(1))
                    for t=1:ylims(1)
                        if s.*ylims(1)+t<=naxes
                            ylim(s.*ylims(1)+t,:)=ylim(t,:);
                        end
                    end
                end

                HVFUNPAR(['Specific Y axes ranges were only defined for ',num2str(ylims(1)),' of the ',num2str(naxes),' axes:'])
                HVFUNPAR('The specified ranges were used in a repeating sequence for the remaining axes.')
            end
            set(sph(q),'ylim',ylim(q,:));
        else
            set(sph(q),'ylim',ylim);
        end
    end



    % set x divisions
    if exist('xdiv')==1
        xdivs=size(xdiv);
        if xdivs(1)>1
            % check if the number of settings equals the number of axes
            if xdivs(1)<naxes
                % create a matrix for the necessary values
                xdiv2=xdiv;
                xdiv=zeros(naxes,3);
                xdiv(1:xdivs(1),:)=xdiv2;
                % replace the missing values by cycling the existing values
                for s=1:ceil(naxes./xdivs(1))
                    for t=1:xdivs(1)
                        if s.*xdivs(1)+t<=naxes
                            xdiv(s.*xdivs(1)+t,:)=xdiv(t,:);
                        end
                    end
                end
                HVFUNPAR(['Specific X axes divisions were only defined for ',num2str(xdivs(1)),' of the ',num2str(naxes),' axes:'])
                HVFUNPAR('The specified divisions were used in a repeating sequence for the remaining axes.')
            end
            if logx==-1;
                set(sph(q),'xtick',10.^[xdiv(q,1):xdiv(q,2):xdiv(q,3)]);
            else
                set(sph(q),'xtick',[xdiv(q,1):xdiv(q,2):xdiv(q,3)]);
            end
        else
            if logx==-1;
                set(sph(q),'xtick',10.^[xdiv(1,1):xdiv(1,2):xdiv(1,3)]);
            else
                set(sph(q),'xtick',[xdiv(1,1):xdiv(1,2):xdiv(1,3)]);
            end

        end
    end


    % set y divisions
    if exist('ydiv')==1
        ydivs=size(ydiv);
        if ydivs(1)>1
            % check if the number of settings equals the number of axes
            if ydivs(1)<naxes
                % create a matrix for the necessary values
                ydiv2=ydiv;
                ydiv=zeros(naxes,3);
                ydiv(1:ydivs(1),:)=ydiv2;
                % replace the missing values by cycling the existing values
                for s=1:ceil(naxes./ydivs(1))
                    for t=1:ydivs(1)
                        if s.*ydivs(1)+t<=naxes
                            ydiv(s.*ydivs(1)+t,:)=ydiv(t,:);
                        end
                    end
                end
                HVFUNPAR(['Specific X axes divisions were only defined for ',num2str(ydivs(1)),' of the ',num2str(naxes),' axes:'])
                HVFUNPAR('The specified divisions were used in a repeating sequence for the remaining axes.')
            end
            if logy==-1;
                set(sph(q),'ytick',10.^[ydiv(q,1):ydiv(q,2):ydiv(q,3)]);
            else
                set(sph(q),'ytick',[ydiv(q,1):ydiv(q,2):ydiv(q,3)]);
            end
        else
            if logy==-1;
                set(sph(q),'ytick',10.^[ydiv(1,1):ydiv(1,2):ydiv(1,3)]);
            else
                set(sph(q),'ytick',[ydiv(1,1):ydiv(1,2):ydiv(1,3)]);
            end
        end
    end


    % check if text is hidden
    if exist('hidetext')==0

        % set titles (string <axistitle> or structure <axistitle(n).title>)
        currentchaninds=chanind(plotaxes==q);
        if exist('axistitle')==1
            if isstruct(axistitle);
                if q<=length(axistitle)
                    if length(axistitle(q).title)>0
                        set(get(sph(q),'title'),'string',axistitle(q).title);
                    else
                        set(get(sph(q),'title'),'string',chans(currentchaninds(1)).title)
                    end
                else
                    set(get(sph(q),'title'),'string','')
                end
            else
                if q==1
                    set(get(sph(q),'title'),'string',axistitle);
                else
                    set(get(sph(q),'title'),'string','');
                end
            end
        else
            set(get(sph(q),'title'),'string',chans(r).title);
        end


        % set x labels (string <xaxislabel> or structure <xaxislabel(n).label>)
        if exist('xaxislabel')==1
            if isstruct(xaxislabel);
                if q<=length(xaxislabel)
                    if length(xaxislabel(q).label)>0
                        set(get(sph(q),'xlabel'),'string',xaxislabel(q).label);
                    else
                        set(get(sph(q),'xlabel'),'string',chans(currentchaninds(1)).xunit);
                    end
                else
                    set(get(sph(q),'xlabel'),'string','');
                end
            else
                %if q==1
                set(get(sph(q),'xlabel'),'string',xaxislabel);
                %else
                % set(get(sph(q),'xlabel'),'string','')  <---- Removed TPG 18/11/2003
                %end
            end
        else
            set(get(sph(q),'xlabel'),'string',chans(r).xunit);
        end



        % set y labels (string <yaxislabel> or structure <yaxislabel(n).label>)
        if exist('yaxislabel')==1
            if isstruct(yaxislabel);
                if q<=length(yaxislabel)
                    if length(yaxislabel(q).label)>0
                        set(get(sph(q),'ylabel'),'string',yaxislabel(q).label);
                    else
                        set(get(sph(q),'ylabel'),'string',chans(currentchaninds(1)).yunit);
                    end
                else
                    set(get(sph(q),'ylabel'),'string','');
                end
            else
                %if q==1
                set(get(sph(q),'ylabel'),'string',yaxislabel);
                % else
                % set(get(sph(q),'ylabel'),'string','')   <--- removed TPG 18/11/2003
                %end
            end
        else
            set(get(sph(q),'ylabel'),'string',chans(r).yunit);
        end

    end % end of hidetext


    % hidenumbers
    if exist('hidenumbers')==1
        set(sph(q),'xticklabel',[]);
        set(sph(q),'yticklabel',[]);
    end

    % check if a grid should be used
    if exist('gridon')==1
        if sum(gridon)>0
            if sum(q==gridon)
                grid on
            else
                grid off
            end
        else
            grid on
        end
    else
        grid off
    end

    hold off
    box on

    % turn off the automatic axis titles
    % set(get(sph(q),'title'),'string','');


end %FOR q, axis loop

% add extra empty axes if nrows x ncols is greater than naxes
if nrows.*ncols>naxes
    for q=(naxes+1):nrows.*ncols
        sph(q)=subplot(nrows,ncols,q);
        set(sph(q),'box','on');

        % if there are at least two rows then set the x-axis information
        % to the row above
        if nrows>1;
            set(sph(q),'xscale',get(sph(q-ncols),'xscale'));
            set(sph(q),'xlim',get(sph(q-ncols),'xlim'));
            set(sph(q),'xtick',get(sph(q-ncols),'xtick'));
            set(sph(q),'xtickmode',get(sph(q-ncols),'xtickmode'));
        end %  if nrows>1;

        % if there are at least two columns then set the x-axis information
        % to the previous column
        if ncols>1;
            set(sph(q),'xscale',get(sph(q-1),'xscale'));
            set(sph(q),'xlim',get(sph(q-1),'xlim'));
            set(sph(q),'xtick',get(sph(q-1),'xtick'));
            set(sph(q),'xtickmode',get(sph(q-1),'xtickmode'));
        end %  if ncols>1;

    end % for blankax
end % if nrows.*ncols>naxes


% Turn the legends on by default (not used)
%  HVGRAPHMENU(5,gcf)

% set the axis handles as an optional output
if nargout==1
    varargout={sph};
end

% merge the axes using hvjointfig if required
if exist('mergeaxes')==1
    hvjointfig(fhand,nrows,ncols)
    handlelist=allchild(fhand);
    menulist=get(findobj(handlelist,'Tag','hvlabtopmenu'),'children');
    set(findobj(menulist,'Tag','merge'),'checked','on');
end

% store the rows and columns to a substructure of the figure UserData
% property
userdata.axislayout=[nrows,ncols];
userdata.originalaxislayout=[nrows,ncols];
set(fhand,'UserData',userdata);

% Message to the user
HVFUNPAR('Finished displaying the dataset')

