%hvleq - issue 1.1 (30/07/10) - HVLab HRV Toolbox
%------------------------------------------------
%[Leq, peak, duration] = hvleq(datastruct, wtg, ref)
%  Displays Leq (equivalent continuous sound level) and peak levels of 
%  sound pressure data 
%    Leq         = row array containing Leq of data channels
%    peak	     = row array containing maxima of data channels
%    duration    = row array containing duration of data (s)
%    datastruct	 = name of workspace data structure array containing sound
%                  pressure data in Pa
%    wtg         = frequency weighting: 'a', 'c', 'none' (default)
%    ref         = reference level (defaults to 2 * 10^-5 Pa) 
%-------------------------------------------------------------------------
%WARNING this function has not yet been formally tested and should be used 
%with caution
%-------------------------------------------------------------------------

% written by Chris Lewis, September 2009
% Untested message added by Chris Lewis, July 2010

function [leq, peakval, duration] = hvleq(dasInarr, strWtg, Ref)

error(HVFUNSTART('STATISTICS OF DATA STRUCTURE', dasInarr)); % show header and abort if input is not a valid structure
if nargin < 3, Ref = 0.00002; end 
if nargin < 2, strWtg = 'none'; end 
fprintf(1, '*************************************************************************\n');
fprintf(1, 'WARNING this function has not yet been formally tested and should be used\n');
fprintf(1, 'with caution\n');
fprintf(1, '*************************************************************************\n');

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); 
        [leq(k), peakval(k), duration(k)] = LEQ(dasInarr(k), strWtg, Ref); % compute stats
    end
end
return
% =====================================================
% compute statistics of single workspace data structure
function [sd, peak, xlen] = LEQ(dasIn, wtg, ref)

xlen = max(dasIn.x);
srate = 1 / dasIn.x(2)-dasIn.x(1);
HVFUNPAR('limit of x-axis', xlen, dasIn.xunit);
HVFUNPAR('frequency weighting', wtg);

switch wtg
    case 'a'
        [B,A] = adsgn(srate);
        ydata = filter(B, A, dasIn.y);
    case 'c'
        [B,A] = cdsgn(srate);
        ydata = filter(B, A, dasIn.y);
    case 'none'
        ydata = dasIn.y;
    otherwise
        error('weighting-type not recognised')
end

sd = 20 .* log10(std(ydata,1)./ref);
maxval = max(ydata);
minval = max(ydata);
peak = 20 .* log10(max(maxval, -minval)./ref);
HVFUNPAR('r.m.s. value', sd, 'dB');
HVFUNPAR('maximum value', peak, 'dB');

return

%==========================
function [B,A] = adsgn(Fs); 
% ADSGN  Design of a A-weighting filter.
%    [B,A] = ADSGN(Fs) designs a digital A-weighting filter for 
%    sampling frequency Fs. Usage: Y = FILTER(B,A,X). 
%    Warning: Fs should normally be higher than 20 kHz. For example, 
%    Fs = 48000 yields a class 1-compliant filter.
%
%    Requires the Signal Processing Toolbox. 
%
%    See also ASPEC, CDSGN, CSPEC. 

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 20, 1997, 10:00am.

% References: 
%    [1] IEC/CD 1672: Electroacoustics-Sound Level Meters, Nov. 1996. 


% Definition of analog A-weighting filter according to IEC/CD 1672.
f1 = 20.598997; 
f2 = 107.65265;
f3 = 737.86223;
f4 = 12194.217;
A1000 = 1.9997;
pi = 3.14159265358979;
NUMs = [ (2*pi*f4)^2*(10^(A1000/20)) 0 0 0 0 ];
DENs = conv([1 +4*pi*f4 (2*pi*f4)^2],[1 +4*pi*f1 (2*pi*f1)^2]); 
DENs = conv(conv(DENs,[1 2*pi*f3]),[1 2*pi*f2]);

% Use the bilinear transformation to get the digital filter. 
[B,A] = bilinear(NUMs, DENs, Fs); 

return

%==========================
function [B,A] = cdsgn(Fs); 
% CDSGN  Design of a A-weighting filter.
%    [B,A] = CDSGN(Fs) designs a digital A-weighting filter for 
%    sampling frequency Fs. Usage: Y = FILTER(B,A,X). 
%    Warning: Fs should normally be higher than 20 kHz. For example, 
%    Fs = 48000 yields a class 1-compliant filter.
%
%    Requires the Signal Processing Toolbox. 
%
%    See also CSPEC, ADSGN, ASPEC. 

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 20, 1997, 10:10am.

% References: 
%    [1] IEC/CD 1672: Electroacoustics-Sound Level Meters, Nov. 1996. 


% Definition of analog C-weighting filter according to IEC/CD 1672.
f1 = 20.598997; 
f4 = 12194.217;
C1000 = 0.0619;
pi = 3.14159265358979;
NUMs = [ (2*pi*f4)^2*(10^(C1000/20)) 0 0 ];
DENs = conv([1 +4*pi*f4 (2*pi*f4)^2],[1 +4*pi*f1 (2*pi*f1)^2]); 

% Use the bilinear transformation to get the digital filter. 
[B,A] = bilinear(NUMs, DENs, Fs); 

