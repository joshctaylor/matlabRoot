% HVCHECKARGUMENTS
% [strError]=HVCHECKARGUMENT(argumentstring,argumentvalue,parameterlabel)
% argumentstring    = A string containing comma seperated data type and length codes as a string. 
%                     Use 's' for string, 'r' for real, 'i' for integer and 'd' for dataset.
%                     A size is optional anfd may be an integer for a vector or 'nxn' for a matrix. For example:
%        's10' 10 character string 'teststring'
%        'r3x2' 3 x 2 real matrix [1.2,2.4;3.0,4.2;5.7,6.4]
%        'd5' dataset containing 5 channels mydata(1:5)
% parameterlabel    = optional string describing the parameter, usually 
%   E.g. [strError]=HVCHECKARGUMENT('s10','teststring')
% strError          = 0 if data types and sizes are as specified, otherwise = 1 indicating an error
% Written TPG 23-12-2003

function [strError]=HVCHECKARGUMENT(argumentstring,argumentvalue, paralabel)

% initialise the output
strError=0;


if isempty('paralabel')
    commentstring='DATA PROBLEM: A parameter';
else
    commentstring=['DATA PROBLEM: ',paralabel];
end

global HV;  %allow access to global parameter structure
if isempty(HV)
    fprintf(1, '\t%s', 'GLOBAL PARAMETER STRUCTURE HV DOES NOT EXIST');
    fprintf(1, '\n');
    strError=1;
    return;
end

% check for a string argument
if isstr(argumentstring)~=1
    fprintf(1, '\t%s', 'HVCHECKARGUMENT SHOULD BE CALLED WITH A STRING');
    fprintf(1, '\n');
    strError=1;
    return;
end

% check the type
switch argumentstring(1)
case 's'
    if isstr(argumentvalue)==0;
        HVFUNPAR([commentstring,' was not a string']);
        strError=1;
        return;
    end
case 'r'
    if or(isreal(argumentvalue)==0,and(isstr(argumentvalue)==1,isreal(argumentvalue)==1));
        HVFUNPAR([commentstring,' was not a real value']);
        strError=1;
        return;
    end
case 'd'
    [checkstructurestring] = HVFUNSTART([],argumentvalue);
    if length(checkstructurestring)>0
        HVFUNPAR([commentstring,' was not a dataset']);
        strError=1;
        return;
    end
    
end % switch arg(1)

% check for a length or size specification
if length(argumentstring)>1
    
    % MATRIX
    % check for a size specification
    sizeind=findstr(argumentstring,'x');
    if length(sizeind)>0
        s1=str2num(argumentstring(2:(sizeind-1)));
        s2=str2num(argumentstring((sizeind+1):end));
        parasize=size(argumentvalue);
        if or(s1~=parasize(1),s2~=parasize(2))
            HVFUNPAR([commentstring,' was not the correct size']);
            strError=1;
            % check for transposed matrix size
            if and(s1==parasize(2),s2==parasize(1))
                HVFUNPAR('The matrix might be transposed?')
            end %if and(s1==parasize(2),s2==parasize(1))
            return;
        end % if or(s1~=parasize(1),s2~=parasize(2))

        % VECTOR
    else %if length(sizeind)>0
        len=str2num(argumentstring(2:end));
        if length(argumentvalue)~=len
            HVFUNPAR([commentstring,' was not the correct length']);
            strError=1;
            return;
        end %if length(argumentvalue)~=len
    end %if length(sizeind)>0
    
end % if length(argumentstring)>1
