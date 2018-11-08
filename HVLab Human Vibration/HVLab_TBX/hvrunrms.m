%hvrunrms - issue 1.0 (16/03/09) - HVLab HRV Toolbox
%---------------------------------------------------
%[outdata, mtv] = hvrunrms(indata, time-constant)
% Returns the running root-mean-square average of successive points in a
% data set and the maximum transient value, using an exponential window
%
% outdata       = new HVLab data structure containing the averaged data
% mtv           = maximum transient value of input data
% indata        = HVLab data structure containing data to be averaged
% time-constant = time constant of exponential averaging (s) - if this
%                 argument is not present time-constant defaults to 1.0 s
%Restrictions:
%-------------
% The input data must all be a real (dtype = 1) time history.
%
% To compute the running r.m.s. average using a rectangular window use
% the function "hvrunaverage".
%

% function written CHL 16/03/2009

function [dasOutarr, mtv] = hvrunrms(dasInarr, tau)

if nargin < 2; tau = 1.0; end;

error(HVFUNSTART('EXPONENTIAL RUNNING R.M.S. AVERAGE', dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not real
        [dasOutarr(k), mtv(k)] = RUNRMS(dasInarr(k), tau); % apply integral
    end
end
return
% =========================================================================
% running r.m.s. average of a single workspace data structure
function [dasOut, mtv] = RUNRMS(dasIn, tau)

global HV; %allow access to global parameter structure

% Create output data structure
dscrn = ['running r.m.s. average of ', dasIn.title];
dasOut	= HVMAKESTRUCT(dscrn, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);

srate = 1 / (dasIn.x(2) - dasIn.x(1));
wn = 1 / tau;
dasOut.y(:,1) = sqrt(Lowpass12(dasIn.y.^2, srate, wn, wn, 0.5));
mtv = max(dasOut.y);
HVFUNPAR('maximum transient value', mtv, dasIn.yunit)
return
% ================================================
% a-v transition weighting filter
function [outarray] = Lowpass12(inarray, srate, wnz, wnp, qp)

scale = 1.0;
% wnz	    = 2 * pi * fnz;
% wnp	    = 2 * pi * fnp;
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
