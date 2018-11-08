%hvsavepars - issue 1.1 (02/02/09) - HVLab HRV Toolbox
%-----------------------------------------------------
%[] = hvsavepars(parfile);
% Save parameter values in global parameter structure 'HV' to a
% parameter file
%
% parfile	=	string containing pathname of the parameter file that 
%               contains the values to be loaded into the fields of global 
%               parameter structure HV
%Example:
%--------
%hvsavepars (‘parfile.pas’) 
% saves global parameters values to parameter file parfile.pas
%

% Written by Chris Lewis, April 2001
% Modified by TPG 29/7/2004 to add reference to HV.INCHANNEL(16).VOLTAGE
% Modified TPG 5/11/2004 to add reference to HV.FIRSTCHANNEL
% Modified by PH 05/04/2006 to add references to new parameters in the help
% Tested by NN 29/01/2007 and found to work well
% Modified by CHL 02/02/2009 to bring HELP in line with technical manual

function [] = hvsavepars(strFilename);

error(HVFUNSTART('SAVING GLOBAL PARAMETERS'));

global HV;  %allow access to global parameter structure
    if nargin > 0
        strFullname = HVFILEXT(strFilename, '.pas');
    else
        strFullname = 'hvdefault.pas';
    end
    save(strFullname, 'HV', '-mat');
    HVFUNPAR(['Parameters saved to file ', strFullname]);

return;
