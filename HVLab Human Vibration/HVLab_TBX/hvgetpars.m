%hvgetpars - issue 1.1 (02/02/09) - HVLab HRV Toolbox
%----------------------------------------------------
%[] = hvgetpars(parfile, mode);
% Loads parameter values into global parameter structure 'HV' from a
% parameter file
%
% parfile	=	filename of the parameter file that contains the values to
%               be loaded into the fields of global parameter structure HV
% mode      =	(optional) when mode = 1 parameters are set to default 
%               values if filename does not exist 
%
%Example:
%--------
%hvgetpars (‘parfile.pas’) 
% restores global parameters to values stored in parameter file parfile.pas
%

% Written by Chris Lewis, April 2001
% Modified by CHL September 2002 to ensure defaults are loaded if HV does not exist as a structure 
% Modified by TPG 29/7/2004 to add reference to HV.INCHANNEL.VOLTAGE
% Modified by TPG 5/11/2004 to add HV.FIRSTCHANNEL
% Modified by PH 05/04/2006 to add new parameters, modify output parameters
% and put new default values
% Modified by PH 22/05/2006 to change default value of HVDAQTYPE to 'None'
% Modified by CHL 02/02/2009 to bring HELP in line with technical manual

function [] = hvgetpars(strFilename, mode)

global HV;  %allow access to global parameter structure
fprintf(1, '\nLOADING GLOBAL PARAMETERS\n');

if nargin < 2, mode = 0; end    % mode 1 = set parameters to default values if the file does not exist

strFullname = HVFILEXT(strFilename, '.pas');
if exist(strFullname, 'file') % Check that file exists
    load('-mat', strFullname);
    HVFUNPAR(['Parameters loaded from file ', strFullname]);
else
    if or(mode == 1, ~isstruct(HV))
        HVSETDEFAULTS
        HVFUNPAR(['Parameter file ', strFullname, ' does not exist: parameters set to default values']); 
    else
        HVFUNPAR(['Parameter file ', strFullname, ' does not exist: parameters not changed']);
    end       
end    

return;

% =========================================================================
% Initialise global parameter structure to default values
function [] = HVSETDEFAULTS()

global HV; %allow access to global parameter structure

    HV.INCHANNELS   = 1;
    HV.FIRSTCHANNEL = 1;
    HV.TINCREMENT   = 0.0025;   % i.e. 400 samples per second  
    HV.DURATION     = 60;
    HV.INFILTER     = 1/(4*HV.TINCREMENT);
    HV.INHIGHPASS   = 'OFF';    
    
for k = 1:16
    HV.INCHANNEL(k).DESCRIPTION = ['channel ', int2str(k)];
    HV.INCHANNEL(k).RANGE       = 25;
    HV.INCHANNEL(k).UNIT        = 'm/s²';        
    HV.INCHANNEL(k).VOLTAGE     = 5;  
end
    HV.OUTENABLE      = 'OFF';
    HV.OUTFILTER      = 1250;
    HV.OUTVOLTAGE     = 10;
    HV.DAQTYPE        = 'None';

    HV.UNIT           = 'm/s²';
    HV.AMPLITUDE      = 1.0;
    HV.OFFSET         = 0.0;
    HV.FREQUENCY      = 1.0;
    HV.FINALFREQUENCY = 100.0;
    HV.FINCREMENT     = 0.0;	% i.e. defaults to finest
    
    HV.CONSTANT          = 1.0;
    HV.HIGHPASS          = 0.1;   
    HV.LOWPASS           = 100.0;       
    HV.FILTERPOLES       = 4.0;
    HV.DISTRIBUTIONSTEPS = 50.0;
    HV.DISTRIBUTIONMIN   = 0.0;
    HV.DISTRIBUTIONMAX   = 0.0;
    HV.MESSAGES          = 'ON'; % i.e. messages on
    HV.WINDOW            = 'HAMMING';

return;




