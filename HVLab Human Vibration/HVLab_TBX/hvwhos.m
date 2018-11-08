%hvwhos - issue 2.0 (10/12/2001) - HVLab HRV Toolbox
%---------------------------------------------------
% The equivalent of the Matlab 'whos' command but only lists HVLab datasets
% and provides more detail. 
%
% THIS IS A SCRIPT. ANY WORKSPACE VARIABLES BEGINNING 'HVDIR_' MAY BE
% DELETED. 
%

% Written TPG 15/3/2001
% Modified TPG 31-10-2001
% Modified TPG 29-11-2001 to DASdir 
% This function has to run as a script to locate the channels defined as workspace varibales using 'whos'
% modified TPG 6-12-2001 to hvdor from DASdir tpg 6-12-2001
% modified to look for .y rather than .data to check that data exists, and to use HVdasdir_variables as 
% a structure to contain all variables used by this script. TPG 6/12/2001
% renamed hvwhos TPG 10/12/2001

% initialise variables
HVDIR_variables.HVisdata=[];
HVDIR_variables.HVchannelcounter=0;

%get the list of variables
HVDIR_variables.HVvarlist=whos;

% find out which of them are HVLab data structures by looking for the 'dxvar' field
for HVDIR_counter1=1:length(HVDIR_variables.HVvarlist)
   % look for the .dxvar field
   HVDIR_variables.HVfail=0;
   eval([HVDIR_variables.HVvarlist(HVDIR_counter1).name,'.dxvar;'],'HVDIR_variables.HVfail=1;')
   % if it is there
   if HVDIR_variables.HVfail==0
      HVDIR_variables.HVisdata=[HVDIR_variables.HVisdata,HVDIR_counter1];
   end
end


% loop through each of the structure names found
for HVDIR_counter2=1:length(HVDIR_variables.HVisdata);
   
   % loop through the channel numbers for each of the structures
   for HVDIR_counter3=1:max(HVDIR_variables.HVvarlist(HVDIR_variables.HVisdata(HVDIR_counter2)).size)
      
      % check if any data is present and store the name in the list box 
      
      
      if length(eval([HVDIR_variables.HVvarlist(HVDIR_variables.HVisdata(HVDIR_counter2)).name,...
               '(HVDIR_counter3).y']))>0
         
         HVDIR_variables.HVchannelcounter=HVDIR_variables.HVchannelcounter+1;
         
         HVDIR_variables.HVstr(HVDIR_variables.HVchannelcounter)=...
            {[HVDIR_variables.HVvarlist(HVDIR_variables.HVisdata(HVDIR_counter2)).name,...
                  '(',num2str(HVDIR_counter3),')']};
      end
      
   end % end of channel locator loop
   
end % end of structure selection loop

if and(isfield(HVDIR_variables,'HVstr')>0,HVDIR_variables.HVchannelcounter==1)
   fprintf(['\nThere is 1 HVLab data structure in the workspace at the moment:\n'])
   HVDIR_variables.HVstr=cell2struct(HVDIR_variables.HVstr,'name',1);
   fprintf([HVDIR_variables.HVstr.name]);
   fprintf('\n\n')
elseif  and(isfield(HVDIR_variables,'HVstr')>0,HVDIR_variables.HVchannelcounter>1)
   
   fprintf(['\nThere are ',num2str(HVDIR_variables.HVchannelcounter),' HVLab data structures in the workspace at the moment:\n'])
   HVDIR_variables.HVstr=cell2struct(HVDIR_variables.HVstr,'name',1);
   for HVDIR_counter4=1:HVDIR_variables.HVchannelcounter
      fprintf([HVDIR_variables.HVstr(HVDIR_counter4).name,'\t',...
            eval([HVDIR_variables.HVstr(HVDIR_counter4).name,'.title'])]);
      
      if HVDIR_counter4==HVDIR_variables.HVchannelcounter
         fprintf('\n\n')
      else
         fprintf('\n')
      end
   end
else
   fprintf(['\nThere are no HVLab data structures in the workspace at the moment\n\n'])
end

% clear the variables
clear HVDIR_variables HVDIR_counter1 HVDIR_counter2 HVDIR_counter3 HVDIR_counter4

