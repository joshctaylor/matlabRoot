function verif = hvcheckstruct(structvar,structtype)
% hvcheckstruct - issue 1.1 (05/04/2006)-HVLab HRV Toolbox
%-------------------------------------------------------------------------
%verif = hvcheckstruct('structure variables', structure type) 
%hvcheckstruct verify that the input structure has the format required
%according to the stucture type.
%
% Structure type numbers:
%    1 : Corresponds to a parameter structure (like HV)
%    2 : Corresponds to a data structure  
%
%hvcheckresult returns the variable "verif", which is equal to 1 if the 
%input structure has the correct format and 0 if not.

%Written by Pierre HUGUENET, February 2006
%Modified by PH 05/04/2006 to add new parameters to the structure type 1


var=structvar;

switch structtype
    
    case 1 %if the structure is a parameter structure
        if ~isstruct(var) || ~isfield(var,'INCHANNELS') || ~isfield(var,'FIRSTCHANNEL') || ~isfield(var,'INFILTER') || ~isfield(var,'INHIGHPASS') || ~isstruct(var.INCHANNEL)  || ~isfield(var,'DURATION') || ~isfield(var,'TINCREMENT') || ~isfield(var,'OUTENABLE') || ~isfield(var,'OUTFILTER') || ~isfield(var,'OUTVOLTAGE') || ~isfield(var,'DAQTYPE') || ~isfield(var,'HIGHPASS') || ~isfield(var,'LOWPASS') || ~isfield(var,'UNIT')|| ~isfield(var,'FINCREMENT') || ~isfield(var,'AMPLITUDE') || ~isfield(var,'OFFSET') || ~isfield(var,'WINDOW') || ~isfield(var,'FILTERPOLES') || ~isfield(var,'MESSAGES') || ~isfield(var,'FREQUENCY') || ~isfield(var,'FINALFREQUENCY') || ~isfield(var,'CONSTANT') || ~isfield(var,'DISTRIBUTIONSTEPS') || ~isfield(var,'DISTRIBUTIONMIN') || ~isfield(var,'DISTRIBUTIONMAX')
            verif=0;
        else
            verif=1;
        end
        
    case 2 %if the structure is a data structure
                
        if ~isstruct(var) || ~isfield(var,'dxvar') || ~isfield(var,'dtype') || ~isfield(var,'title') || ~isfield(var,'yunit') || ~isfield(var,'y2unit') || ~isfield(var,'xunit') || ~isfield(var,'stats') || ~isfield(var,'x') || ~isfield(var,'y')% || ~isequal(sizx,sizy1) 
           verif=0;
        elseif ~isequal(var.dtype,1) && ~isequal(var.dtype,2) && ~isequal(var.dtype,3)
           verif=0;
        elseif size(var,2) > 1
            verif=1;
            for i=1:size(var,2)
                sizx=size(var(i).x,1);
                sizy1=size(var(i).y(:,1),1);
                if ~isequal(sizx,sizy1) %verify that x and y have same size
                    verif=0;
                end 
            end
        else
            verif=1;
            sizx=size(var.x,1);
            sizy1=size(var.y(:,1),1);
            if ~isequal(sizx,sizy1) %verify that x and y have same size
                verif=0;
            end
        end
end



        
        
        
        
        
        
        
        

