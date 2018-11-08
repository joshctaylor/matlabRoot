%HVLABFILTER - issue 1.1 (06/04/09) - HVLab HRV Toolbox
%------------------------------------------------------
%[filtered_data] = HVLABFILTER(unfiltrd_data, filter, filter_mode, fc, poles)
% Applies specified recursive filter to time histories in HVLab data array 
% using identical algorithm to filters in HVLab_DOS software
%
%		unfiltrd_data	= data structure array containing unweighted time input history data
%		filtered_data	= data structure array containing weighted time input history data
%		filter	        = string describing filter (e.g. 'butterworth', 'bessel') defaults to 'butterworth'
%		filter_mode	    = string describing filter mode (e.g. 'lowpass', 'highpass') defaults to 'lowpass'
%		fc	            = cut-off frequency (-3dB point) in Hz defaults to HV.LOWPASS or HV.HIGHPASS
%		poles	        = number of poles (even number between 1 and 10) defaults to HV.FILTERPOLES
%

% Written by Chris Lewis, February 2004
% Name changed from HVFILTER to HVLABFILTER by CHL, April 2009

function [dasOutarr] = HVLABFILTER(dasInarr, strFilter, strMode, fFc, iPoles)

if nargin < 2, strFilter = 'butterworth'; end
if nargin < 3, strMode = 'lowpass'; end
if nargin < 4
    if strcmpi(strMode, 'highpass')
        fFc = HV.HIGHPASS;
    else
        fFc = HV.LOWPASS;
    end
end
if nargin < 5, iPoles = HV.FILTERPOLES; end

error(HVFUNSTART(['APPLY ', strMode, ' ', strFilter, ' FILTER TO TIME HISTORY'], dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = FILTER(dasInarr(k), strFilter, strMode, fFc, iPoles); % apply weighting
    end
end

return
% =========================================================================
% filter a single workspace data structure
function [dasOut] = FILTER(dasIn, filter, mode, fc, poles)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
dasOut	= HVMAKESTRUCT([filter, ' filtered ', dasIn.title], dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
xincr   = dasIn.x(2) - dasIn.x(1);
srate   = 1 / xincr;

HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('number of samples', length(dasIn.y));
HVFUNPAR('cut off frequency', fc);
HVFUNPAR('number of poles', poles);

if rem(poles, 2) | (poles <= 0) | (poles > 10)
    error('Poles must be an even no. between 2 and 10'); 
    dasOut.dtype = 0; % make created data structure invalid
end

if srate < fc*4
    error('Sampling rate too low for specified cut-off frequency'); 
    dasOut.dtype = 0; % make created data structure invalid
end

% Implement filters
% -----------------
errFilt = 1;

if strcmpi(filter, 'butterworth')
    qs = [0.7071, 0, 0, 0, 0; 0.541, 1.306, 0, 0, 0; 0.518, 0.707, 1.932, 0, 0; 0.510,  0.601, 0.900, 2.563, 0; 0.506,  0.561, 0.707, 1.101, 3.196];
    fm = [1, 0, 0, 0, 0; 1, 1, 0, 0, 0; 1, 1, 1, 0, 0; 1, 1, 1, 1, 0; 1, 1, 1, 1, 1];  
   errFilt = 0;
end

if strcmpi(filter, 'bessel')   
    qs = [0.577, 0, 0, 0, 0; 0.522, 0.806, 0, 0, 0; 0.510, 0.611, 1.024, 0, 0; 0.506, 0.560, 0.711, 1.225, 0; 0.504, 0.538, 0.620, 0.810, 1.416];    
    fm = [1.274, 0, 0, 0, 0; 1.432, 1.606, 0, 0, 0; 1.607, 1.692, 1.908, 0, 0; 1.781, 1.835, 1.956, 2.192, 0; 1.933, 1.968, 2.048, 2.190, 2.435];    
   errFilt = 0;
end

if errFilt
    error('Specified filter not recognised'); % abort if weighting spec. not found
    dasOut.dtype = 0; % make created data structure invalid
    return
end

if strcmpi(mode, 'lowpass')
    dasOut.y = dasIn.y;
    %if poles==1
    %    dasOut.y = Lowpass12(dasOut.y, srate, fc, fc, 1); 
    %end
    for k=1: poles/2;
        dasOut.y = Lowpass02(dasOut.y, srate, fc * fm(poles/2, k), qs(poles/2, k));       
    end
   
    if srate < fc*4
       errSr = 1;
    end
end    

if strcmpi(mode, 'highpass')
    dasOut.y = dasIn.y;
    %if poles==1
    %    dasOut.y = Highpass12(dasOut.y, srate, fc, fc, 1); 
    %end
    for k=1: poles/2;
        dasOut.y = Highpass02(dasOut.y, srate, fc / fm(poles/2, k), qs(poles/2, k));       
    end
end    

return

% ================================================
% two pole highpass weighting filter
function [outarray] = Highpass02(inarray, srate, fnp, qp, scale)

if nargin < 5, scale = 1; end

wnp	    = 2 * pi * fnp;
c 		= wnp / tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= c * c * scale / a1;
b(2)	= -2 * c * c * scale / a1;
b(3)	= c * c * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

% ================================================
% two pole lowpass weighting filter
function [outarray] = Lowpass02(inarray, srate, fnp, qp, scale)

if nargin < 5, scale = 1; end

wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= wnp * wnp * scale / a1;
b(2)	= 2 * wnp * wnp * scale / a1;
b(3)	= wnp * wnp * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

% ================================================
% a-v transition weighting filter
function [outarray] = Lowpass12(inarray, srate, fnz, fnp, qp, scale)

if nargin < 6, scale = 1; end

wnz	    = 2 * pi * fnz;
wnp	    = 2 * pi * fnp;
c 		= wnp / tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= (wnz + c) * wnp * wnp * scale / (wnz * a1);
b(2)	= (2 * wnz) * wnp * wnp * scale / (wnz * a1);
b(3)	= (wnz - c) * wnp * wnp * scale / (wnz * a1);
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

