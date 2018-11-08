% mfile to set figure graphics to HVLab corporate colors for copying 
% into powerpoint (white/yellow on blue) or for OHPs (black on white)
%
% function []=HVGRAPHRECOLOUR(fignum,use,titlefontsize,axisfontsize,nobold,titlecolor,textcolor,backcolor)
% 
% all arguments are optional
% use is either 'ppt' for powerpoint or 'ohp' for slides.
% colors must be [1,0,1] or similar, not strings
%
% Written TPG 06/10/98 as hvlabcol.m
% modified TPG 13-04-2000 to use automatic 14 and 15 point fonts
% Modified 6-9-2001 to use manual fonts and recolor blue lines to white x
% Modified TPG 15/4/2004 for use with HVLab toolbox renamed HVGRAPHRECOLOUR

function []=HVGRAPHRECOLOUR(fignum,use,titlefontsize,axisfontsize,nobold,titlecolor,textcolor,backgroundcolor)

if exist('use')==0
   use='ppt';
end

if isempty(use)==1
   use='ppt';
end

if exist('fignum')==0
   fignum=gcf;
end

if isempty(fignum)==1
   fignum=gcf;
end

if exist('titlefontsize')==0
   titlefontsize=15;
end

if isempty(titlefontsize)==1
   titlefontsize=15;
end

if exist('axisfontsize')==0
   axisfontsize=15;
end

if isempty(axisfontsize)==1
   axisfontsize=15;
end

if exist('nobold')==0
   nobold=0;
end

if isempty(nobold)==1
   nobold=0;
end


% select colors
if use=='ppt',
   titlecol=[1.0,1.0,0.0];
   textcol=[1.0,1.0,1.0];
   backcol=[0.0,0.0,1.0];
elseif use=='ohp'
   titlecol=[0.0,0.0,0.0];  
   textcol=[0.0,0.0,0.0];
   backcol=[1.0,1.0,1.0];
end

if exist('titlecolor')==1
   titlecol=titlecolor;
end

if exist('textcolor')==1
   textcol=textcolor;
end

if exist('backgroundcolor')==1
   backcol=backgroundcolor;
end


% set border colour
set(gcf, 'color',backcol);

% obtain number of subplots

hsubplot=HVGETOBTYPE(fignum,'axes');


% loop to cycle through subplots
for q=1:length(hsubplot);

   
   % set axes to white
   set(hsubplot(q),'xcolor',textcol);
   set(hsubplot(q),'ycolor',textcol);
   set(hsubplot(q),'zcolor',textcol);
   
   % set background to blue
   set(hsubplot(q), 'color',backcol);
   
   % set axis font to arial
   set(hsubplot(q),'fontname','arial');
   
   % set axis linewidth to 5x standard (std is 0.5)
   %set(hsubplot(q),'linewidth',[0.5])
   
   % set axis numbering font size to 20 pt (std is 10 pt)
   set(hsubplot(q),'fontsize',axisfontsize)
   
   % set axis label fontsize to 20 pt (std is 10 pt)
   set(get(hsubplot(q),'xlabel'),'fontsize',axisfontsize);
   set(get(hsubplot(q),'ylabel'),'fontsize',axisfontsize);
   set(get(hsubplot(q),'zlabel'),'fontsize',axisfontsize);
   
   % set title color to yellow
   set(get(hsubplot(q),'title'),'color',titlecol);
   
   %set title font size and embolden if required
   set(get(hsubplot(q),'title'), 'fontname','arial');
   set(get(hsubplot(q),'title'),'fontsize',titlefontsize);
   if nobold==0
   set(get(hsubplot(q),'title'), 'fontweight','bold');
else
    set(get(hsubplot(q),'title'), 'fontweight','normal');
end
   
   
 
   hobs = get(hsubplot(q),'Children');
   
   for r=1:length(hobs);
      
      % get background color
      gbcol=get(hsubplot(q),'color');
      
        % set blue colors to white
      eval('obcol=get(hobs(r),''color'');','obcol=[1,1,1];');
      
      if obcol==gbcol
         set(hobs(r),'color',textcol);
      end
      
      % black to white
      if and(obcol==[0,0,0],gbcol==[0,0,1])
         set(hobs(r),'color',textcol);
      end
      
      % set small linewidths to 2
      %eval('lwidth=get(hobs(r),''linewidth'');','lwidth=2.0;');
      
      %if lwidth<2
      %   eval('set(hobs(r),''linewidth'',2.0);','');
      %end
      
   end % end of line color routine
   
   
end