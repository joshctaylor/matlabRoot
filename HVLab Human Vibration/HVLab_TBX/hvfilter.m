%hvfilter - issue 2.3 (04/12/09) - HVLab HRV Toolbox
%---------------------------------------------------
%[outdata] = hvfilter(indata, filter-type, fc, npoles)
% Applies the specified filter to time histories in an HVLab data structure
%
%   outdata     = data structure array containing filtered time history
%                 history data   
%   indata      = data structure array containing unfiltered time history 
%                 data   
%   filter-type = optional string describing filter type: if this
%                 argument is not specified filter defaults to 'lobutter' 
%   fc          = cut-off frequency (-3dB point) in Hz defaults to
%                 HV.LOWPASS or HV.HIGHPASS
%   npoles      = number of poles (integer between 1 and 8): defaults to
%                 HV.FILTERPOLES
%
%Available filter types:
%-----------------------
%   ‘lobutter’ 	 = low-pass Butterworth filter
%   ‘lozp’       = low-pass zero-phase Butterworth filter
%   ‘hibutter’ 	 = high-pass Butterworth filter
%   ‘hizp’       = high-pass zero-phase Butterworth filter
%   ‘3rd-octave’ = one-third-octave band filter
%   ‘octave’     = one-octave band filter
%
%Restrictions:
%-----------------------------------
% The input data must be a real (dtype = 1) time-history.
%
% This function uses the MATLAB functions butter and filter, which can
% give unpredictable results with very low cut-off frequencies and a high
% no. of poles due to rounding problems.  For best results the sampling
% rate of the input data must be in the range fc/200 to fc/5 and the no. of
% poles should be less than 6. Re-sampling of the input data will be
% necessary to filter at lower or higher cut-off frequencies. The
% alternative functions hvhibutter and hvlobutter decimate the filters into
% complex pole pairs, using a direct implementation of the bilinear z
% transform, which provides more reliable high and low-pass Butterworth
% filters with very low cut-off frequencies and a high number (up to 10) of
% poles.
%
% If the filter type is 'lozp' or 'hizp', the data is filtered both
% forwards and in reverse, resulting in a zero-phase filter with an
% attenuation of 6dB at fc and a slope of -12dB*poles per octave (twice
% that of a regular Butterworth filter)
%
%Examples:
%---------
%[fdata] = hvfilter (mydata, 'hibutter') 
% returns a new HVLab data structure, fdata, containing the time
% history data from data structure mydata, after passing through a
% high-pass Butterworth filter. The cut-off frequency and filter order are 
% set to the current values of HV.HIGHPASS and HV.FILTERPOLES respectively
%
%[fdata] = hvfilter (mydata, 'lobutter', 0.5, 5) 
% filters the time history data from data structure mydata, by a
% five-pole (30 dB per octave) Butterworth filter with a highpass cut-off
% of 0.5 Hz

% Written by Chris Lewis, February 2004
% modified by Chris Lewis, April 2009 to add band-pass and zero-phase filters 
% modified by Chris Lewis, August 2009 to fix bug with default cut-off values 
% Help notes revised by Chris Lewis, December 2009 

function [dasOutarr] = hvfilter(dasInarr, strFilter, fFc, iPoles)

global HV;
if nargin < 2, strFilter = 'lobutter'; end
if nargin < 3
    if or(strcmpi(strFilter, 'hibutter'), strcmpi(strFilter, 'hizp'))
        fFc = HV.HIGHPASS;
    else
        fFc = HV.LOWPASS;
    end
end
if nargin < 4, iPoles = HV.FILTERPOLES; end

error(HVFUNSTART(['APPLY ', strFilter, ' FILTER TO TIME HISTORY'], dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = FILTER(dasInarr(k), strFilter, fFc, iPoles); % apply filter
    end
end

return
%========================================
%filter a single workspace data structure
function [dasOut] = FILTER(dasIn, strfilter, fc, poles)

global HV; %allow access to global parameter structure

%Create output data structure
%----------------------------
dasOut	= HVMAKESTRUCT([strfilter, ' filtered ', dasIn.title], dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
xincr   = dasIn.x(2) - dasIn.x(1);
srate   = 1 / xincr;
if fc > srate/4
    error('Sampling rate too low for specified fc'); 
end
if fc < srate/500
    error('Sampling rate too high for specified fc'); 
end

HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('number of samples', length(dasIn.y));
if or(strcmpi(strfilter, '3rd-octave'), strcmpi(strfilter, 'octave'))
    HVFUNPAR('centre frequency', fc, 'Hz');
    poles = min(3, poles);
else
    HVFUNPAR('cut off frequency', fc, 'Hz');
    poles = min(10, poles);
end
HVFUNPAR('number of poles', poles);

%Implement filter
%----------------
switch strfilter
    case 'lobutter'
        [B, A] = butter(poles, fc./(srate./2));
    case 'hibutter'
        [B, A] = butter(poles, fc./(srate./2), 'high');
    case 'lozp'
        [B, A] = butter(poles, fc./(srate./2));
    case 'hizp'
        [B, A] = butter(poles, fc./(srate./2), 'high');
    case '3rd-octave'
        [B, A] = OCT3DSGN(fc, srate, poles);
    case 'octave'
        [B, A] = OCTDSGN(fc, srate, poles);
    otherwise
        error('filter-type not recognised')
end

if or(strcmpi(strfilter, 'lozp'), strcmpi(strfilter, 'hizp'))
    dasOut.y = filtfilt(B, A, dasIn.y); % apply the zero-phase filter
else
    dasOut.y = filter(B, A, dasIn.y);
end

return

%============================================
%OCT3DSGN Design of a one-third-octave filter
function [B, A] = OCT3DSGN(Fc, Fs, N); 
%    designs a digital 1/3-octave filter with 
%    center frequency Fc for sampling frequency Fs. 
%    The filter is designed according to the Order-N specification 
%    of the ANSI S1.1-1986 standard. Default value for N is 3. 
%    Warning: for meaningful design results, center frequency used
%    should preferably be in range Fs/200 < Fc < Fs/5.
%    Usage of the filter: Y = FILTER(B,A,X). 
% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 25, 1997, 2:00pm.

if (nargin > 3) | (nargin < 2)
  error('Invalid number of arguments.');
end
if (nargin == 2)
  N = 3; 
end
if (Fc > 0.88*(Fs/2))
  error('design not possible: check frequencies.');
end
  
% Design Butterworth 2Nth-order one-third-octave filter 
% Note: BUTTER is based on a bilinear transformation, as suggested in [1]. 
pi = 3.14159265358979;
f1 = Fc/(2^(1/6)); 
f2 = Fc*(2^(1/6)); 
Qr = Fc/(f2-f1); 
Qd = (pi/2/N)/(sin(pi/2/N))*Qr;
alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
W1 = Fc/(Fs/2)/alpha; 
W2 = Fc/(Fs/2)*alpha;
[B,A] = butter(N,[W1,W2]); 

return

%OCTDSGN  Design of an octave filter
%===================================
function [B,A] = OCTDSGN(Fc,Fs,N); 
%    designs a digital octave filter with 
%    center frequency Fc for sampling frequency Fs. 
%    The filter are designed according to the Order-N specification 
%    of the ANSI S1.1-1986 standard. Default value for N is 3. 
%    Warning: for meaningful design results, center values used
%    should preferably be in range Fs/200 < Fc < Fs/5.
%    Usage of the filter: Y = FILTER(B,A,X). 
% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 22, 1997, 9:00pm.

if (nargin > 3) | (nargin < 2)
  error('Invalid number of arguments.');
end
if (nargin == 2)
  N = 3; 
end
if (Fc > 0.70*(Fs/2))
  error('Design not possible. Check frequencies.');
end

% Design Butterworth 2Nth-order octave filter 
% Note: BUTTER is based on a bilinear transformation, as suggested in [1]. 
%W1 = Fc/(Fs/2)*sqrt(1/2);
%W2 = Fc/(Fs/2)*sqrt(2); 
pi = 3.14159265358979;
beta = pi/2/N/sin(pi/2/N); 
alpha = (1+sqrt(1+8*beta^2))/4/beta;
W1 = Fc/(Fs/2)*sqrt(1/2)/alpha; 
W2 = Fc/(Fs/2)*sqrt(2)*alpha;
[B,A] = butter(N,[W1,W2]); 

return
