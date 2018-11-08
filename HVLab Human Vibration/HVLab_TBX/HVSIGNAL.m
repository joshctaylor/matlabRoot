%HVSIGNAL - issue 2.3 (29/07/10) - HVLab HRV Toolbox 
%----------------------------------------------------
%[signal] = hvsignal(type, title, yunit, xunit, duration, magnitude, 
%                              increment, frequency1, frequency2, taperlen)
%  Creates a sinusoidal or random signal in an HVLab data structure
%    signal		 = workspace data structure
%    type   	 = string describing type of signal ('sine','sweep','random')
%    title  	 = optional description of the data (string)
%    yunit  	 = optional units of y-axis scale (defaults to 'm/s^2')									
%    xunit  	 = optional units of x-axis scale (defaults to 's')
%    increment   = optional time increment (defaults to HV.TINCREMENT)
%    magnitude   = optional r.m.s. magnitude (defaults to HV.AMPLITUDE)
%    duration    = optional duration in s (defaults to HV.DURATION)
%    frequency1  = frequency (if type = 'sine'),
%                  initial sweep frequency (if type = 'sweep'), or
%                  lower band-limit (if type = 'random') 
%                  in Hz (defaults to 1)
%    frequency2  = final sweep frequency in Hz (if type = 'sweep'),
%                  upper band-limit (if type = 'random') 
%                  in Hz (defaults to sample_rate/5)
%    taperlen    = length of optional taper to be applied to each end of
%                  the signal (in x-axis units)
%

% written by Chris Lewis, October 2002
% Modified by CHRG, 10/01/06 to allow HVSWEEP to work properly
% Modified by CHL, 10/01/07 to include error msg if increment >= duration
% Modified by CHL, 11/02/08 to include error msg if increment >= duration/2
% Modified by CHL, 23/08/09 to scale signal to r.m.s. magnitude instead of 
%                  peak amplitude, and include a end-taper option
% Modified by CHL, 11/03/10 to fix a problem that could result in different 
%                  numbers of samples in the x and y data fields 
% Modified by CHL, 12/04/10 to finally fix a problem that could result in 
%                  different numbers of samples in the x and y data fields 
% Modified by CHL, 29/07/10 to fix a problem that caused tapers to be  
%                  incorrectly applied at the end of a signal 

function [dasNew] = HVSIGNAL(str, title, yunit, xunit, xlimit, magnitude, xincr, frequency1, frequency2, taperlen)

global HV; %allow access to global parameter structure
if nargin < 2; title = []; end
if nargin < 3; yunit = 'm/s^2'; end
if nargin < 4; xunit = 's'; end
if nargin < 5; xlimit = HV.DURATION; end
if nargin < 6; magnitude = HV.AMPLITUDE; end
if nargin < 7; xincr = HV.TINCREMENT; end
if nargin < 8; frequency1 = 1; end
if nargin < 9; frequency2 = 1/(xincr*5); end
if nargin < 10; taperlen = 0; end
if xincr > xlimit/2; error('Increment must be less than duration/2'); end

dasNew = HVMAKESTRUCT(title, yunit, xunit);
dasNew.x = (0: xincr: xlimit)';
dasNew.stats(1) = 1/xincr;
%dlen = round(1 + (xlimit / xincr)); %"fix" changed to "round" in version 2.1
dlen = length(dasNew.x); % ylen forced explicitely to xlen in version 2.2
HVFUNPAR('sampling increment', xincr, xunit);
HVFUNPAR('duration', xlimit, xunit);
switch str
    case 'random'
        if isempty(dasNew.title); dasNew.title = 'Random signal'; end
        datay = rand(dlen, 1) - 0.5;
        if frequency1 > 0; 
        	[datay] = HP(datay, 1/xincr, 6, frequency1);             
        end
        if frequency2 > 0; 
        	[datay] = LP(datay, 1/xincr, 6, frequency2);
        end
        dasNew.y = datay * magnitude / std(datay, 1);
    case 'sine'
        HVFUNPAR('frequency', frequency1, 'Hz');
        if isempty(dasNew.title); dasNew.title = [num2str(frequency1), ' Hz sinusoidal signal']; end
        dasNew.y = magnitude * sqrt(2) * sin(2 .* pi .* frequency1 .* dasNew.x);
    case 'sweep'
        HVFUNPAR('initial frequency', frequency1, 'Hz');
        HVFUNPAR('final frequency', frequency2, 'Hz');
        if isempty(dasNew.title)
            dasNew.title=['swept sinusoidal signal']; 
        end 
        dasNew.y = zeros(dlen, 1);
        var1 = 2*pi*xincr*frequency1;
        var2 = 2*pi*xincr*(frequency2-frequency1)/dlen;
        datax = zeros(1,dlen);
        for k = 1:dlen-1
            var1=var1 + var2;
            datax(k+1) = datax(k) + var1;
        end
        dasNew.y = magnitude * sqrt(2) * sin(datax)';        
    otherwise
        error('Unrecognised signal type');
end;
    
if taperlen > 0; 
    dasNew.y = TAPER(dasNew.y, taperlen, taperlen, xincr);             
end

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
for k = 1:poles/2;
	outarray = Lowpass02(outarray, srate, flp, q(poles/2, k));
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

return
