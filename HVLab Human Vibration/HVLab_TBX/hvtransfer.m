%hvtransfer - issue 2.1 (30/01/07) HVLab HRV Toolbox
%---------------------------------------------------
%[transfer-function, coherency] = hvtransfer (system-input, system-output)
% Computes the transfer function(s) and coherency(s) between time histories
% in two HVLab data structures
%
% transfer-function	=	name of new HVLab data structure containing the system 
%                       transfer function
% coherency         =	name of new HVLab data structure containing the coherency 
%                       between the system input and output
% system-input      = 	name of HVLab data structure containing the input time 
%                       history applied to the system 
% system-output     = 	name of HVLab data structure containing the output time 
%                       history of the system 
%Examples:
%---------
%[Hxy] = hvtransfer (x, y) 
% returns a new HVLab data structure, Hxy, containing complex data (dtype = 2) 
% representing the transfer function(s) between the time histories in x and y. 
% The frequency increment of Hxy is less than or equal to HV.FINCREMENT.
%
%[Hxy, Cxy] = hvtransfer (x, y, 0.25) 
% returns (i) an HVLab data structure, Hxy, containing complex data (dtype = 2) 
% representing the transfer function(s) between the time histories in x and y 
% and (ii) an HVLab data structure, Cxy, containing real data (dtype = 1) 
% representing the coherency(s) between the time histories in x and y. The 
% frequency increment of the output functions is less than or equal to 0.25 Hz.

% Written by Chris Lewis, October 2001
% Modified CHL August 2002 to include standard exception handling
% Modified CHL 3/9/2002 to use HVMAKESTRUCT so as to ensure correct field order
% Modified CHL 5/5/2005 to default resolution as in DOS HVLab
% Modified CHL 29/1/2007 to bring HELP notes in line with technical manual
% Modified CHL 26/1/2010 to work with data sets having different lengths

function [dasTF, dasCoher] = hvtransfer(dasTH1, dasTH2, fIncr)

error(HVFUNSTART('TRANSFER FUNCTION EVALUATION', dasTH1, dasTH2)); % show header and abort if input is not a valid structure
global HV; % allow access to global parameter structure
if nargin < 3, fIncr = HV.FINCREMENT; end % default increment to global setting

for k = 1:length(dasTH1)
    if ~HVISEMPTY(k, dasTH1(k), dasTH2(k)) % return results only for non-empty channels
        error(HVISVALID(dasTH1(k), {'real', '~hz', '~xvar'})); % abort if input data is not in correct form
        % error(HVISVALID(dasTH2(k), {'real', '~hz', '~xvar', 'xaxis', 'length'}, dasTH1(k))); % abort if x-axes not same length 
        error(HVISVALID(dasTH2(k), {'real', '~hz', '~xvar'})); 
	    if nargout < 2
            [dasTF(k)] = TRANSFER(dasTH1(k), dasTH2(k), fIncr); % compute transfer function
        else
            [dasTF(k), dasCoher(k)] = TRANSFER(dasTH1(k), dasTH2(k), fIncr); % compute transfer function and coherency
        end
    end
end
return;
   
% =========================================================================
% compute psd of single workspace data structure
function [dasOut, dasCoh] = TRANSFER(dasIn1, dasIn2, fIncr)

global HV; % allow access to global parameter structure

% Create output data structures
% -----------------------------
if and(~isempty(dasIn1.title), ~isempty(dasIn2.title))
    tftitle = ['Transfer function between ', dasIn1.title, ' and ', dasIn2.title]; 
    cotitle	= ['Coherency between ', dasIn1.title, ' and ', dasIn2.title];
else
    tftitle = [];
    cotitle = [];
end
if strcmpi(dasIn1.xunit, 's')
   xunit = 'Hz';
else
   xunit = ['1/', dasIn1.xunit];
end
if strcmp(dasIn1.yunit, dasIn2.yunit)
   yunit = '';
else
   yunit = [dasIn2.yunit, '/', dasIn1.yunit];
end

dasOut = HVMAKESTRUCT(tftitle, yunit, xunit, 2, 0, dasIn2.stats); % transfer function is complex
if nargout > 1; dasCoh = HVMAKESTRUCT(cotitle, [], xunit, 1, 0, dasIn2.stats); end

% compute and display parameters
% ------------------------------
%dlen = length(dasIn1.y);
dlen = min(length(dasIn1.y), length(dasIn2.y));
dasIn1.y = dasIn1.y(1:dlen);
dasIn2.y = dasIn2.y(1:dlen); % truncate both data sets to length of shortest

xincr = dasIn1.x(2) - dasIn1.x(1);
srate = 1 / xincr;
if fIncr == 0
   n = 11; % where fft length (fftlen) = 2**n
else   
   n = fix(log2(srate / fIncr));
   n = min(n,11); % i.e. maximum length = 2048
   n = max(n,4); % i.e. minimum length = 16   
end
fftlen = 2^n; % fft length
outincr = srate / fftlen; % frequency increment of psd
nfft = 2 * ceil(dlen / fftlen); % no. of ffts to be evaluated
skip = fix(dlen / nfft); % samples skipped after start of previous fft window
noverlap = fftlen - skip; % fft overlap
dof = fix(nfft .* 2) ;
dasOut.stats(4) = dof;
strWin = 'hamming'; % default window
if or(strcmpi(HV.WINDOW, 'HANNING'), strcmpi(HV.WINDOW, 'HANN')); strWin = 'hann'; end
if or(strcmpi(HV.WINDOW, 'RECTANGULAR'), strcmpi(HV.WINDOW, 'BOXCAR')); strWin = 'boxcar'; end
if or(strcmpi(HV.WINDOW, 'TRIANGULAR'), strcmpi(HV.WINDOW, 'TRIANG')); strWin = 'triang'; end
if strcmpi(HV.WINDOW, 'BARTLETT'); strWin = 'bartlett'; end

HVFUNPAR('number of input samples', dlen);
HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('fft length', fftlen);
HVFUNPAR('specified resolution', fIncr, 'Hz');
HVFUNPAR('actual resolution', outincr, 'Hz');
HVFUNPAR('degrees of freedom', dof);
HVFUNPAR(['spectral window = ', strWin]);

% Compute Tranfer Function
% ------------------------
winhandle = str2func(strWin); % get handle to window function
window = feval(winhandle, fftlen); % generate spectral window
dasOut.y = tfe(dasIn1.y, dasIn2.y, fftlen, srate, window, noverlap);
%win = window(@hamming, fftlen);
%dasOut.y = tfe(dasIn1.y, dasIn2.y, fftlen, srate, win, noverlap);
outlen  = size(dasOut.y, 1); % return no. of samples in transfer function
outlimit = (outlen - 1) * outincr; % generate x-axis frequency scale
dasOut.x = (0: outincr: outlimit)';
dasOut.stats(4) = dof;
if nargout > 1
    Gio = CSD(dasIn1.y, dasIn2.y, fftlen, srate, window, noverlap);
    Gii = PSD(dasIn1.y, fftlen, srate, window, noverlap);
    Goo = PSD(dasIn2.y, fftlen, srate, window, noverlap);
    Gio = abs(Gio);
    dasCoh.y = (Gio .* Gio) ./ (Gii .* Goo);
    dasCoh.x = (0: outincr: outlimit)';
    dasCoh.stats(4) = dof;
end

return;
