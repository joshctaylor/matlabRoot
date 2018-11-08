%hvweight - issue 1.2 (02/02/09) - HVLab HRV Toolbox
%---------------------------------------------------
%[weightedTH]	= 	hvweight (unwtdTH, wname, nublim)
% Applies a specified frequency weighting to time history(s) in an HVLab 
% data structure
%
% weightedTH	= 	HVLab data structure containing weighted time history 
%                   data
% unwtdTH       =	HVLab data structure containing unweighted time history 
%                   data
% wname         = 	lower case string describing desired weighting function 
%                   (e.g. 'wk')
% nublim        =	‘no upper band-limit’ flag: if set, upper band limit 
%                   filter is not applied to weightings Wb to Wm (defaults
%                   to 0)
%
%Available weightings:
%---------------------
% ‘wb’, ‘wc’, ‘wd’, ‘we’, ‘wf’, ‘wg’, ‘wh’, ‘wj’, ‘wk’, ‘wm’ as defined in:
% International Organization for Standardization (1999) Human response to 
% vibration – Measuring instrumentation. ISO 8041:1994.
%
%Examples:
%---------
% [weightedTH] = hvweight (unwtdTH, ‘wk’) 
%                returns unwtdTH filtered by frequency weighting Wk (ISO 2631-1:1997).
%
% [weightedTH] = hvweight (unwtdTH, ‘wb’, 1) 
%                returns unwtdTH filtered by frequency weighting Wb (ISO 2631-1:1997) 
%                with no upper band-limit, for application to data that has already 
%                been low-pass filtered at 100 Hz (e.g. by an anti-aliasing filter 
%                before digitisation).

% Written by Chris Lewis, October 2001
% Modified September 2002 to include standard exception handling
% Modified CHL 15/10/2002 to correct scaling problem in Wb
% Modified TPG 8/1/2003 to update function name to 'hvweight' in the function help
% Modified CHL 16/03/06 to remove seat test signals
% Modified CHL 16/03/06 to make behaviour and error messages with low srate consistent with HVLab_DOS
% Modified CHL 29/02/2007 to bring HELP in line with technical manual
% Modified CHL 02/02/2009 to update HELP header

function [dasOutarr] = hvweight(dasInarr, strWtg, nubl)

error(HVFUNSTART(['FREQUENCY WEIGHT DATA BY ', strWtg, ' WEIGHTING'], dasInarr)); % show header and abort if input is not a valid structure
if nargin < 3, nubl = 0; end;

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = FWEIGHT(dasInarr(k), strWtg, nubl); % apply weighting
    end
end

return
% =========================================================================
% frequency weight a single workspace data structure
function [dasOut] = FWEIGHT(dasIn, wtg, flgUbl)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
dasOut	= HVMAKESTRUCT([wtg, ' weighted ', dasIn.title], dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
xincr   = dasIn.x(2) - dasIn.x(1);
srate   = 1 / xincr;
qc	    = 1 / sqrt(2);
HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('number of samples', length(dasIn.y));

% Implement weighting filters
% ---------------------------
errWtg = 1;

if strcmpi(wtg, 'wb')
   nubl = CheckSR(srate, 100, 16, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.4, qc);
   %dasOut.y = Allpass22(dasOut.y, srate, 2.5, 0.9, 4, 0.95, (1/1.024)); % as in 8041:2002 which is in error
   dasOut.y = Allpass22(dasOut.y, srate, 2.5, 0.9, 4, 0.95, 1.024); % which is equivalent to BS 6841
   dasOut.y = Lowpass12(dasOut.y, srate, 16, 16, 0.55);
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'wc')
   nubl = CheckSR(srate, 100, 8, flgUbl); 
   dasOut.y = Highpass02(dasIn.y, srate, 0.4, qc);
   dasOut.y = Lowpass12(dasOut.y, srate, 8, 8, 0.63);
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'wd')
   nubl = CheckSR(srate, 100, 2, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.4, qc);
   dasOut.y = Lowpass12(dasOut.y, srate, 2, 2, 0.63);
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'we')
   nubl = CheckSR(srate, 100, 1, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.4, qc);
   dasOut.y = Lowpass12(dasOut.y, srate, 1, 1, 0.63);
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'wf')
   nubl = CheckSR(srate, 0.63, 0.25, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.08, qc);
   dasOut.y = Lowpass02(dasOut.y, srate, 0.25, 0.86); % equivalent to Lowpass12(dasOut.y, srate, 1000, 0.25, 0.86); where 1000 == infinity
   %dasOut.y = Allpass22(dasOut.y, srate, 0.0625, 0.8, 0.1, 0.8); % as in 8041:2002 and 2631-1:1997
   dasOut.y = Allpass22(dasOut.y, srate, 0.0625, 0.8, 0.1, 0.8, 1.024); % which is equivalent to BS 6841
   dasOut.y = Lowpass02(dasOut.y, srate, 0.63, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'wg')
   nubl = CheckSR(srate, 100, 5.3, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.8, qc);
   dasOut.y = Lowpass12(dasOut.y, srate, 1.5, 5.3, 0.68, 0.42);
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'wh')
   nubl = CheckSR(srate, 1258.93, 15.915, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 6.31, qc);
   dasOut.y = Lowpass12(dasOut.y, srate, 15.915, 15.915, 0.64);
   dasOut.y = Lowpass02(dasOut.y, srate, 1258.93, qc, 1.0, nubl); 
   errWtg = 0;
end;

if strcmpi(wtg, 'wj')
   nubl = CheckSR(srate, 100, 5.32, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.4, qc);
   dasOut.y = Allpass22(dasOut.y, srate, 3.75, 0.91, 5.32, 0.91);
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'wk')
   nubl = CheckSR(srate, 100, 12.5, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.4, qc);
   dasOut.y = Lowpass12(dasOut.y, srate, 12.5, 12.5, 0.63);
   dasOut.y = Allpass22(dasOut.y, srate, 2.37, 0.91, 3.35, 0.91);
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if strcmpi(wtg, 'wm')
   nubl = CheckSR(srate, 100, 5.684, flgUbl);   
   dasOut.y = Highpass02(dasIn.y, srate, 0.79, qc);
   dasOut.y = Lowpass12(dasOut.y, srate, 5.684, 5.684, 0.5); % equivalent to 'Lowpass01'
   dasOut.y = Lowpass02(dasOut.y, srate, 100, qc, 1.0, nubl);
   errWtg = 0;
end;

if errWtg
    dasOut.dtype = 0; % make created data structure invalid
    error('Specified weighting not recognised'); % abort if weighting spec. not found
    return
end
return

% ================================================
% two pole highpass weighting filter
function [outarray] = Highpass02(inarray, srate, fnp, qp, scale)

if nargin < 5, scale = 1.0; end

wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
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
function [outarray] = Lowpass02(inarray, srate, fnp, qp, scale, bypass)

if nargin < 6, bypass = 0; end
if nargin < 5, scale = 1.0; end

wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= wnp * wnp * scale / a1;
b(2)	= 2 * wnp * wnp * scale / a1;
b(3)	= wnp * wnp * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

if bypass
    outarray = inarray;
else
    outarray = filter(b, a, inarray);
end  
return

% ================================================
% a-v transition weighting filter
function [outarray] = Lowpass12(inarray, srate, fnz, fnp, qp, scale)

if nargin < 6, scale = 1.0; end

wnz	    = 2 * pi * fnz;
wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= (wnz + c) * wnp * wnp * scale / (wnz * a1);
b(2)	= (2 * wnz) * wnp * wnp * scale / (wnz * a1);
b(3)	= (wnz - c) * wnp * wnp * scale / (wnz * a1);
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

% ================================================
% allpass weighting filter (upward step)
function [outarray] = Allpass22(inarray, srate, fnz, qz, fnp, qp, scale)

if nargin < 7, scale = 1.0; end

wnz	    = 2 * pi * fnz;
wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= (c * c + (wnz * c / qz) + wnz * wnz) * scale / a1;
b(2)	= (2 * wnz * wnz - 2 * c * c) * scale / a1;
b(3)	= (c * c - (wnz * c / qz) + wnz * wnz) * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

% ================================================
% check sampling rate is not loo low
function [nubl] = CheckSR(srate, bandlimit, ftrans, ubl_off)

nubl = ubl_off;
if srate < (ftrans * 5), error('Sampling rate too low'); end % abort sampling rate is too low
if srate < (bandlimit * 4), nubl = 1; end % cancel upper bandlimit filter
if srate < (bandlimit * 2.5)
    HVFUNPAR('WARNING: With the current sampling rate the output will be attenuated') 
    HVFUNPAR('at higher frequencies by the following approximate amounts -') 
    HVFUNPAR('  sampling rate/3: 30%')
    HVFUNPAR('  sampling rate/4: 15%')
    HVFUNPAR('  sampling rate/5: 10%')
    HVFUNPAR('  sampling rate/6: 7%')
    HVFUNPAR('  sampling rate/7: 5%')
    HVFUNPAR('  sampling rate/8: 3%')
end
return
