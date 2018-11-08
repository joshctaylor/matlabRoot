%HVISVALID
% [strErrors] = HVISVALID(dasIn, strCndtn, dasCmp)
% Check that data structure is valid for a given application
% where strCndtn is an optional cell array of strings which can contain any combination 
% of the following:
%   'real'      = input data must be real
%   'cmplx'     = input data must be complex
%   'moph'      = input data must be modulus and phase pairs
%   '~real'     = input data cannot be real
%   '~cmplx'    = input data cannot be complex
%   '~moph'     = input data cannot be modulus and phase pairs
%   '~hz'       = input data cannot be in the frequency domain
%   '~s'        = input data cannot be in the time domain
%   '~xvar'     = input data must be sampled with a constant x-axis increment
%   'length'    = number of data samples does not match that of data structure dasCmp
%   'yunit'     = yunit of structure does not match that of data structure dasCmp (warning only)
%   'xaxis'     = xaxis of structure is not the same as that of data structure dasCmp (warning only)
% strErrors     = 'INVALID INPUT DATA' if conditions are not met
% Written by Chris Lewis, August 2002
% Modified  TPG 23-12-2003 to define strErrors in the help and to accept datasets dasIn with emore than 1 channel

function [strErr] = HVISVALID(dasIn, strCndtn, dasCmp)

errFlag = 0;
for q=1:length(dasIn); % loop through channels in dataset
    
    
    if or(or(dasIn(q).dtype < 1, dasIn(q).dtype > 3), ~isstruct(dasIn(q)));
        errFlag = 1;
        fprintf(1, '\tinput is not a valid data structure\n');
    else
        if nargin > 1
            for k = 1:length(strCndtn);
                if strcmpi(strCndtn{k}, 'real')
                    if dasIn(q).dtype ~= 1
                        errFlag = 1;  
                        fprintf(1, '\tinput data must be real\n');
                    end
                end
                if strcmpi(strCndtn{k}, 'cmplx')
                    if dasIn(q).dtype ~= 2
                        errFlag = 1;  
                        fprintf(1, '\tinput data must be complex\n');
                    end
                end
                if strcmpi(strCndtn{k}, 'moph')
                    if dasIn(q).dtype ~= 3
                        errFlag = 1;  
                        fprintf(1, '\tinput data must be modulus and phase pairs\n');
                    end
                end
                if strcmpi(strCndtn{k}, '~real')
                    if dasIn(q).dtype == 1
                        errFlag = 1;  
                        fprintf(1, '\tinput data cannot be real\n');
                    end
                end
                if strcmpi(strCndtn{k}, '~cmplx')
                    if dasIn(q).dtype == 2
                        errFlag = 1;  
                        fprintf(1, '\tinput data cannot be complex\n');
                    end
                end
                if strcmpi(strCndtn{k}, '~moph')
                    if dasIn(q).dtype == 3
                        errFlag = 1;  
                        fprintf(1, '\tinput data cannot be modulus and phase pairs\n');
                    end
                end
                if strcmpi(strCndtn{k}, '~hz')
                    if strcmpi(dasIn(q).xunit, 'Hz')
                        errFlag = 1;  
                        fprintf(1, '\tinput data cannot be in the frequency domain\n');
                    end
                end
                if strcmpi(strCndtn{k}, '~s')
                    if strcmpi(dasIn(q).xunit, 'S') 
                        errFlag = 1;  
                        fprintf(1, '\tinput data cannot be in the time domain\n');
                    end
                end
                if strcmpi(strCndtn{k}, '~xvar')
                    if dasIn(q).dxvar > 0
                        errFlag = 1;  
                        fprintf(1, '\tinput data must be sampled with a constant x-axis increment\n');
                    end
                end
                if nargin > 2
                    if and(strcmpi(strCndtn{k}, 'length'), isstruct(dasCmp))
                        if length(dasIn(q).y) ~= length(dasCmp.y)
                            errFlag = 1; 
                            fprintf(1, '\tdata sets must have the same length\n');
                        end 
                    end
                    if and(strcmpi(strCndtn{k}, 'yunit'), isstruct(dasCmp))
                        if ~strcmpi(dasIn(q).yunit, dasCmp.yunit)
                            %errFlag = 1;  % WARNING only
                            fprintf(1, '\twarning: data sets have different y-axis units\n');
                        end
                    end
                    if and(strcmpi(strCndtn{k}, 'xaxis'), isstruct(dasCmp))
                        if dasIn(q).x ~= dasCmp.x
                            %errFlag = 1;  % WARNING only
                            fprintf(1, '\warning: data sets have different x-axes\n');
                        elseif ~strcmpi(dasIn(q).xunit, dasCmp.xunit)
                            %errFlag = 1;  % WARNING only
                            fprintf(1, '\twarning: data sets have different x-axis units\n');
                        end
                    end
                end
            end
        end
    end    
    
end % for q=1:length(dasIn); % loop through channels in dataset
if errFlag
    strErr = 'INVALID INPUT DATA'; 
else
    strErr = ''; 
end

return;