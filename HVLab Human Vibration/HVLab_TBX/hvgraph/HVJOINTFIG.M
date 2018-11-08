%hvjointfig
%[] = hvjointfig(hfig,no_row,no_col,ititle)
%--> join subplots without any space between them
%
%hfig   : figure handler, if none, activated figure will be managed
%no_row : No. of row subplots
%         put minus number for smart ylabels, 
%           -> only one ylabel is left at the centre of leftmost y axis
%no_col : No. of column subplots
%         put minus number for smart xlabels            
%           -> only one xlabel is left at the centre of lowest x axis
%ititle : 1 for smart titles
%           -> only one title is left at the centre of highest x axis
%
%Usage  : jointfig( 2, 1)           : joint subplots on the current figure
%       : jointfig(-2, 1)           : joint AND only one ylabel at the centre of y axis
%       : jointfig( 2,-1)           : joint AND only one xlabel at the centre of y axis
%       : jointfig(-2,-1)           : joint AND only one ylabel & one xlabel
%       : jointfig(gcf, -2, -1, 1)  : joint AND only one ylabel & one xlabel & one title
%       : jointfig(Figure_handler,2,1)
%       : jointfig(Figure_handler,-2,1,1)
%
% Written by Do-Sig Gong 19-05-1999
% Renamed to to 'hvjointfig' TPG 8/1/2003 to integrate with the HVLAB matlab toolbag
% Modified TPG 23-12-2003 to include basic argument checking and provide an 'operating' message
% Modified TPG 15/6/2004 to check for axis object type



function hvjointfig(hfig,no_row,no_col,ititle)

% check arguments
if (HVCHECKARGUMENT('r3',[hfig,no_row,no_col],'Handle or row and column settings'))
    return
end

% information message
HVFUNPAR('Reformatting the figure to remove the gaps between the axes')

if nargin ~= 4, ititle = 0; end
if nargin == 2, no_col = no_row; no_row = hfig;, hfig = gcf; end

% need to arrange when the nargin == 3
sign_no_row = sign(no_row);  no_row = abs(no_row); 
sign_no_col = sign(no_col);  no_col = abs(no_col);

matlabv = version; 

%check for axis objects
figure(hfig), hchild = get(hfig,'Children');
count1=1;
for q=1:length(hchild)
    hotype=get(hchild(q),'type');
    if hotype(1:4)=='axes'
        hsubplot(count1)=hchild(q);
        count1=count1+1;
    end
end


% All the movement of subplots should be done in unit of points
% --> convert the position unit from pixel into points : should be restored)
set(hfig,'unit','point')

% BEWARE! hsubplot has different order from the original subplot sequence
% for instance,
%   ----------------------          ----------------------
%  |     1    |     2     |        |     4    |     3     |
%  |----------+-----------|        |----------+-----------|
%  |     3    |     4     |        |     2    |     1     |
%   ----------------------          ----------------------
%       subplot(22i)                  get(gcf,'Children')
% THEREFORE, transpose hsubplot into the one in original subplot sequence, like this..
hsubplot = hsubplot(length(hsubplot):-1:1);

no_subplot1 = length(hsubplot);
no_space  = no_row*no_col;
no_delta = no_space - no_subplot1;

% in case of the odd number of subplots, add some dummy subplots to make it square
if no_delta,
    for i = 1:no_delta
        addsubplot = subplot(no_row,no_col,no_subplot1+i);
        hsubplot = [hsubplot; addsubplot];
    end
end

no_subplot = length(hsubplot);

% Default position of figure in a window is in point coord
for i=1:no_subplot,
    set(hsubplot(i),'unit','point'),
    tmp_ylab_pos = get(get(hsubplot(i),'ylabel'),'position');
    ylab_pos(i) = tmp_ylab_pos(1);
end

new_ylab_pos = min(ylab_pos);

coner1 = get(hsubplot(1),'position');
coner2 = get(hsubplot(length(hsubplot)),'position');

% position of lowest-left coner
inix = coner1(1);  iniy = coner2(2)*1.13;

% axis line width
alinewidth = get(hsubplot(1),'linewidth');

% total lengths
total_xlength = (coner2(1) + coner2(3) - coner1(1)) + (no_col-1) * alinewidth;
total_ylength = (coner1(2) + coner1(4) - coner2(2)) + (no_row-1) * alinewidth;

delx = 1.0 * total_xlength / no_col;   % width of each subplot
dely = 0.97 * total_ylength / no_row;  % height of each subplot (decreasing by 97% for safety)

%...re-positioning the subpplots
index_loop = no_subplot+1;              % total subplots index (reverse order)
for index_row = no_row:-1:1,             % loop for row index
    for index_col = no_col:-1:1          % loop for column index
        index_loop = index_loop - 1;
        
        subplot(hsubplot(index_loop));
        
        startx = inix + (index_col - 1) * delx;
        starty = iniy + (no_row - index_row) * dely;
        POSITION = [startx, starty, delx ,dely];
        
        %.......Well, This is a kind of bug of MATLAB
        if alinewidth < 1.0
            POSITION =  [ startx - 0.5 * alinewidth * (index_col-1), ...
                    starty + (no_row-1)* 0.1 * alinewidth * (index_row-1), ...
                    delx ,dely];
            %          POSITION =  [startx-1.0*alinewidth*(index_col-1), starty+1.5*alinewidth*(index_row-1), delx ,dely]);
        end
        
        set(gca,'position',POSITION);
        
        %        xlim1 = get(gca,'xlim'); xlim1 = xlim1(length(xlim1));
        if index_col == no_col, ylim1 = get(gca,'ylim'); ylim1 = ylim1(length(ylim1));
        elseif index_col == 1,  ylim2 = get(gca,'ylim'); ylim2 = ylim2(length(ylim2));
            if ylim1 ~= ylim2, id_dif_yscale(index_row) = 1; else, id_dif_yscale(index_row) = 0; end 		
        end
        
    end
end        

dif_yscale = 0;   % for different yscale in a same row
% for different xscale in a same row  -> Forget it! jointfig is nor suitable in such figure!

if no_col > 1, dif_yscale = ~isempty(find(id_dif_yscale)); end

%...managing the labels (xlabel, ylabel, xticklabel, yticklabel, etc)
index_loop = no_subplot+1;               % total subplots index (reverse order)
for index_row = no_row:-1:1,             % loop for row index
    for index_col = no_col:-1:1          % loop for column index
        index_loop = index_loop - 1;
        
        subplot(hsubplot(index_loop));
        
        iscalex = size(get(gca,'xscale'),2);  % 3:log, 6:linear
        iscaley = size(get(gca,'yscale'),2);  % 3:log, 6:linear
        
        if index_row ~= 1,	set(get(hsubplot(index_loop),'title'),'string',[]); end
        
        % remove xlabels & xticklabels of subplots located in upper rows other than lowest row
        if index_row ~= no_row,
            if ~(no_delta & index_row == (no_row - 1) & index_col == no_col),
                set(get(gca,'xlabel'),'String','')
                set(gca,'xticklabel','');
            end
        end
        
        if dif_yscale
            if index_col == no_col, set(gca,'YAxisLocation','right'); end
        else
            % remove ylabels & yticklabels of subplots located in right columns other than leftmost column
            if index_col ~= 1,
                set(get(gca,'ylabel'),'String','')
                set(gca,'yticklabel','');
            end		
        end
        
        % remove first xticklabel of subplots located in left columns other than rightmost column
        if ~no_delta,
            if index_col ~= no_col 
                if iscalex == 6   % linear scale
                    a = get(gca,'xtick'); b = get(gca,'xlim');
                    if a(length(a)) == b(length(b)),
                        a = a(1:length(a)-1);
                        set(gca,'xtick',a);
                    end
                elseif iscalex == 3  % for log scale -> reduce max lim of axis by (min lim)/1000
                    a = get(gca, 'xlim');
                    a(end) = a(end)-a(1)/1000;  
                    set(gca,'xlim',a);
                end
            end	        	
        else
            if index_col == no_col & index_row == no_row - 1
                if iscalex == 6,  % linear scale
                    a = get(gca,'xtick');
                    a = a(2:length(a));
                    set(gca,'xtick',a);
                elseif iscalex == 3,  % for log scale -> reduce max lim of axis by (min lim)/1000
                    a = get(gca, 'xlim');
                    a(end) = a(end)-a(1)/1000;  
                    set(gca,'xlim',a);
                end	
            end
        end
        
        
        % remove first yticklabel of subplots located in lower rows other than highest row, linear yscale only
        % .... only linear scale
        if index_row ~= 1 
            if iscaley == 6  % linear scale
                a = get(gca,'ytick'); b = get(gca,'ylim');
                if a(length(a)) == b(length(b)),
                    a = a(1:length(a)-1);
                    set(gca,'ytick',a);
                end
            elseif iscaley == 3  % for log scale -> reduce max lim of axis by (min lim)/1000
                a = get(gca, 'ylim');
                a(end) = a(end)-a(1)/1000;  
                set(gca,'ylim',a);
            end	
        end
        
    end
end

if sign_no_row == -1
    % for smart ylabel
    index_loop = no_subplot+1;
    for index_row = no_row:-1:1,
        for index_col = no_col:-1:1          % loop for column index
            index_loop = index_loop - 1;
            if index_row ~= ceil(no_row/2),
                % remain ylabel only located the centre subplot
                set(get(hsubplot(index_loop),'ylabel'),'string',[]);
            else
                if even(no_row) == 1
                    % move position of ylabel into the subplot located upper part of center figure
                    ypos_ylabel = get(get(hsubplot(index_loop),'ylabel'),'position');
                    ylim = get(hsubplot(index_loop),'ylim');
                    ypos_ylabel(2) = ylim(1);
                    set(get(hsubplot(index_loop),'ylabel'),'position', ypos_ylabel);
                end
            end	
        end			
    end
end	


if sign_no_col == -1
    % for smart xlabel
    index_loop = no_subplot+1;
    for index_row = no_row:-1:1,
        for index_col = no_col:-1:1          % loop for column index
            index_loop = index_loop - 1;
            if index_col ~= ceil(no_col/2),
                % remain xlabel only located the centre subplot
                set(get(hsubplot(index_loop),'xlabel'),'string',[]);
            else
                if even(no_col) == 1
                    % move position of ylabel into the subplot located upper part of center figure
                    xpos_xlabel = get(get(hsubplot(index_loop),'xlabel'),'position');
                    xlim = get(hsubplot(index_loop),'xlim');
                    xpos_xlabel(1) = xlim(2);
                    set(get(hsubplot(index_loop),'xlabel'),'position', xpos_xlabel);
                end
            end	
        end			
    end
end	

if ititle,
    % for smart title
    index_loop = no_subplot+1;
    for index_col = no_col:-1:1          % loop for column index
        for index_row = no_row:-1:1,
            index_loop = index_loop - 1;
            if index_row ~= 1,
                set(get(hsubplot(index_loop),'title'),'string',[]);
            end	
            if index_col ~= ceil(no_col/2),
                % remain xlabel only located the centre subplot
                set(get(hsubplot(index_loop),'title'),'string',[]);
            else
                if even(no_col) == 1
                    % move position of ylabel into the subplot located upper part of center figure
                    xpos_xlabel = get(get(hsubplot(index_loop),'title'),'position');
                    xlim = get(hsubplot(index_loop),'xlim');
                    xpos_xlabel(1) = xlim(2);
                    set(get(hsubplot(index_loop),'title'),'position', xpos_xlabel);
                end
            end	
        end			
    end
end	

% get back to initial unit
set(hfig,'unit','default')
for i=1:no_subplot,	set(hsubplot(i),'unit','default'),end

% delete dummy subplots
if no_delta, for i = 1:no_delta, delete(hsubplot(no_subplot1+i)); end, end



