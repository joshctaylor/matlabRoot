%hvtestsignal - issue 2.1 (14/07/10) - HVLab HRV Toolbox
%-------------------------------------------------------
%[outdata] = hvtestsignal(test_signal, duration, increment, taperlen)
% Generates test signals specified in seat and glove testing standards
%
%		outdata     = new data structure containing test signal
%		test_signal	= string describing test signal (e.g. 'em1')
%       duration    = duration in s (defaults to HV.DURATION)
%       increment   = sampling increment in s (defaults to HV.TINCREMENT)
%       taperlen    = length of optional taper to be applied to each end of
%                     the signal (in s: defaults to 0.5)
%
%Available test_signals:
%-----------------------
% ‘em1’, ‘em2’, ‘em3’, ‘em4’, ‘em5’, ‘em6’, ‘em7’, ‘em8’, ‘em9’ as defined in:
%   EN ISO 7096:2000 Earth-moving machinery – Laboratory evaluation of
%   operator seat vibration.
% ‘it1’, ‘it2’, ‘it3’, ‘it4’ as defined in:
%   EN 13490:2001 Mechanical vibration - Industrial trucks - Laboratory
%   evaluation and specification of operator seat vibration.
% ‘ag1’, ‘ag2’, ‘ag3’ as defined in:
%   BS ISO 5007:2003 Agricultural wheeled tractors – Operator's seat -
%   Laboratory measurement of transmitted vibration.
% ‘L’, ‘M’, ‘H’ as defined in:
%   BS EN ISO 10819:1997 Mechanical vibration and shock – Hand-arm
%   vibration – Method for the measurement and evaluation of the vibration
%   transmissibility of gloves at the palm of the hand.
%

% written by Chris Lewis, Apr 2009
% revised by Chris Lewis, Nov 2009 to add taper and fix scaling inaccuracy
% revised by Chris Lewis, Jul 2010 to increase minimum srate for glove testing to 6500 s/s

function [dasOut] = hvtestsignal(strTest, xduration, xincr, taperlen)

error(HVFUNSTART(['GENERATE ', strTest, ' TEST SIGNAL'])); % show header and abort if input is not a valid structure

global HV; %allow access to global parameter structure
if nargin < 2; xduration = HV.DURATION; end
if nargin < 3; xincr = HV.TINCREMENT; end
if nargin < 4; taperlen = 0.5; end
if strcmpi(strTest, 'L') | strcmpi(strTest, 'M') | strcmpi(strTest, 'R') | strcmpi(strTest, 'H')
    if xincr > 1 / 6500;
    	error('Sampling rate must be at least 6500 s/s for glove testing');
    end
else
    if xincr > 1 / 100;
    	error('Sampling rate must be at least 100 s/s for seat testing');
    end
end
dasNew = HVSIGNAL('random', [strTest ' test signal'], 'm/s²', 's', xduration, 1, xincr);
dasOut = FWEIGHT(dasNew, strTest, xincr, taperlen);
return

%=================================
%apply frequency weighting filters
function [dasOut] = FWEIGHT(dasIn, wtg, xincr, taperlen)

dasOut = dasIn;
srate = 1/xincr;
errWtg = 1;
errSr = 0;

if strcmpi(wtg, 'em1')
   dasOut.y = HP(dasIn.y, srate, 4, 1.5);
   dasOut.y = LP(dasOut.y, srate, 4, 2.5);
   dasOut.y = dasOut.y * 1.71 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;

if strcmpi(wtg, 'em2')
   dasOut.y = HP(dasIn.y, srate, 4, 1.5);
   dasOut.y = LP(dasOut.y, srate, 4, 3.0);
   dasOut.y = dasOut.y * 2.05 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;

if strcmpi(wtg, 'em3')
   dasOut.y = HP(dasIn.y, srate, 4, 1.5);
   dasOut.y = LP(dasOut.y, srate, 4, 3.0);
   dasOut.y = dasOut.y * 1.73 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;

if strcmpi(wtg, 'em4')
   dasOut.y = HP(dasIn.y, srate, 4, 1.5);
   dasOut.y = LP(dasOut.y, srate, 4, 3.0);
   dasOut.y = dasOut.y * 0.96 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;

if strcmpi(wtg, 'em5')
   dasOut.y = HP(dasIn.y, srate, 4, 1.5);
   dasOut.y = LP(dasOut.y, srate, 1, 3.5);
   dasOut.y = dasOut.y * 1.94 / bandrms(dasOut.y, srate, 0.89, 17.78);
   errWtg = 0;
end;

if strcmpi(wtg, 'em6')
   dasOut.y = HP(dasIn.y, srate, 2, 6.5);
   dasOut.y = LP(dasOut.y, srate, 2, 9.0); 
   dasOut.y = dasOut.y * 1.65 / bandrms(dasOut.y, srate, 0.89, 17.78);
   errWtg = 0;
end;

if strcmpi(wtg, 'em7')
   dasOut.y = HP(dasIn.y, srate, 8, 3.0);
   dasOut.y = LP(dasOut.y, srate, 8, 3.5);
   dasOut.y = dasOut.y * 2.36 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;

if strcmpi(wtg, 'em8')
   dasOut.y = HP(dasIn.y, srate, 4, 3.0);
   dasOut.y = LP(dasOut.y, srate, 2, 3.0);
   dasOut.y = dasOut.y * 1.05 / bandrms(dasOut.y, srate, 0.89, 17.78);
   errWtg = 0;
end;

if strcmpi(wtg, 'em9')
   dasOut.y = HP(dasIn.y, srate, 4, 3.5);
   dasOut.y = LP(dasOut.y, srate, 2, 4.0);
   dasOut.y = dasOut.y * 1.63 / bandrms(dasOut.y, srate, 0.89, 17.78);
   errWtg = 0;
end;

if strcmpi(wtg, 'it1')
   dasOut.y = HP(dasIn.y, srate, 4, 4.5);
   dasOut.y = LP(dasOut.y, srate, 2, 5.0);
   dasOut.y = dasOut.y * 1.58 / bandrms(dasOut.y, srate, 0.89, 17.78);
   errWtg = 0;
end;

if strcmpi(wtg, 'it2')
   dasOut.y = HP(dasIn.y, srate, 4, 3.0);
   dasOut.y = LP(dasOut.y, srate, 2, 3.0);
   dasOut.y = dasOut.y * 1.05 / bandrms(dasOut.y, srate, 0.89, 17.78);
   errWtg = 0;
end;

if strcmpi(wtg, 'it3')
   dasOut.y = HP(dasIn.y, srate, 4, 1.5);
   dasOut.y = LP(dasOut.y, srate, 4, 3.0);
   dasOut.y = dasOut.y * 0.96 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;

if strcmpi(wtg, 'it4')
   dasOut.y = HP(dasIn.y, srate, 4, 1.5);
   dasOut.y = LP(dasOut.y, srate, 4, 3.0);
   dasOut.y = dasOut.y * 1.59 / bandrms(dasOut.y, srate, 0.89, 17.78);
   errWtg = 0;
end;

if strcmpi(wtg, 'ag1')
   dasOut.y = HP(dasIn.y, srate, 8, 3.0);
   dasOut.y = LP(dasOut.y, srate, 8, 3.5);
   dasOut.y = dasOut.y * 2.26 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;
   
if strcmpi(wtg, 'ag2')
   dasOut.y = HP(dasIn.y, srate, 8, 2.1);
   dasOut.y = LP(dasOut.y, srate, 8, 2.6);
   dasOut.y = dasOut.y * 1.94 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;
   
if strcmpi(wtg, 'ag3')
   dasOut.y = HP(dasIn.y, srate, 8, 1.95);
   dasOut.y = LP(dasOut.y, srate, 8, 2.45);
   dasOut.y = dasOut.y * 1.74 / bandrms(dasOut.y, srate, 0.89, 11.22);
   errWtg = 0;
end;

if strcmpi(wtg, 'L') 
   dasOut.y = HP(dasIn.y, srate, 2, 8.0);
   dasOut.y = LP(dasOut.y, srate, 2, 31.5);
   dasOut.y = dasOut.y * 3.4 / whrms(dasOut.y, srate); 
   errWtg = 0;
end;

if strcmpi(wtg, 'M')
   dasOut.y = HP(dasIn.y, srate, 2, 31.5);
   dasOut.y = LP(dasOut.y, srate, 2, 200);
   dasOut.y = dasOut.y * 3.4 / whrms(dasOut.y, srate);
   errWtg = 0;
end;

if strcmpi(wtg, 'H')
   dasOut.y = HP(dasIn.y, srate, 2, 200);
   dasOut.y = LP(dasOut.y, srate, 2, 1000);
   dasOut.y = dasOut.y * 3.3 / whrms(dasOut.y, srate);
   errWtg = 0;
end;

if strcmpi(wtg, 'R')
   dasOut.y = HP(dasIn.y, srate, 2, 31.5);
   dasOut.y = LP(dasOut.y, srate, 2, 1000);
   dasOut.y = dasOut.y * 3.0 / whrms(dasOut.y, srate);
   errWtg = 0;
end;

if errWtg
    error('Specified weighting not recognised'); % abort if weighting spec. not found
    dasOut.dtype = 0; % make created data structure invalid
    return
end

if taperlen > 0; 
    dasOut.y = TAPER(dasOut.y, taperlen, taperlen, xincr);             
end

if errSr
    HVFUNPAR('WARNING: weighting will not be accurate at frequencies > SR/5');
end
return

% =================================================
% return r.m.s. magnitude in 'fhp' to 'flp' Hz band
function [rms] = bandrms(inarray, srate, fhp, flp)

q = [0.7071, 0, 0, 0, 0; 0.541, 1.306, 0, 0, 0; 0.518, 0.707, 1.932, 0, 0; 0.510,  0.601, 0.900, 2.563, 0; 0.506,  0.561, 0.707, 1.101, 3.196];
poles = 8;
for k = 1:poles/2
	inarray = Highpass02(inarray, srate, fhp, q(poles/2, k));       
	inarray = Lowpass02(inarray, srate, flp, q(poles/2, k));       
end  
rms = std(inarray, 1);
return

% =================================================
% return Wh-weighted r.m.s. magnitude
function [rms] = whrms(inarray, srate)

inarray = Lowpass12(inarray, srate, 15.915, 15.915, 0.64);
inarray = Lowpass02(inarray, srate, 1258.93, 1/sqrt(2), 1.0); 
rms = std(inarray, 1);
return

% ================================================
% highpass butterworth filter
function [outarray] = HP(inarray, srate, poles, fhp)

q = [0.7071, 0, 0, 0, 0; 0.541, 1.306, 0, 0, 0; 0.518, 0.707, 1.932, 0, 0; 0.510, 0.601, 0.900, 2.563, 0; 0.506,  0.561, 0.707, 1.101, 3.196];
outarray = inarray;
for k = 1:poles/2;
	outarray = Highpass02(outarray, srate, fhp, q(poles/2, k));       
end   
return

% ================================================
% lowpass butterworth filter
function [outarray] = LP(inarray, srate, poles, flp)

q = [0.7071, 0, 0, 0, 0; 0.541, 1.306, 0, 0, 0; 0.518, 0.707, 1.932, 0, 0; 0.510, 0.601, 0.900, 2.563, 0; 0.506,  0.561, 0.707, 1.101, 3.196];
outarray = inarray;
if poles == 1
    outarray = Lowpass12(outarray, srate, flp, flp, 0.5); 
else
    for k = 1:poles/2;
        outarray = Lowpass02(outarray, srate, flp, q(poles/2, k));       
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

% =========================================================================
% taper a single workspace data structure
function [dataOut] = TAPER(dataIn, tStart, tEnd, xincr)

nStart  = round(tStart / xincr);
nEnd    = round(tEnd / xincr);
if (nStart + nEnd) > length(dataIn)
    error('Length of data is less than specified taper lengths');
end
% generate taper functions
taperStart = (-(cos(pi.*([0:nStart-1]./(nStart-1)))-1)./2)';
taperEnd = (-(cos(pi.*([0:nEnd-1]./(nEnd-1)))-1)./2)';

% apply taper functions
dataOut = dataIn;
dataOut(1:nStart) = dataIn(1:nStart).*taperStart;
dataOut(length(dataOut)-nEnd+1:length(dataOut)) = dataIn(length(dataIn)-nEnd+1:length(dataIn)).*flipud(taperEnd);

return