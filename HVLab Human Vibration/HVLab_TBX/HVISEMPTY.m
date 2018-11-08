%HVISEMPTY
% [flag] = HVISEMPTY(iChnl, dasIn_1, dasIn_2, ... dasIn_N)
% where flag == TRUE if one or more of workspace data structures 'dasIn_n' are empty.
% If iChnl > 0, iChnl is used to identify the channel currently being processed.
% Written by Chris Lewis, August 2002
%
function [iFlag] = HVISEMPTY(iChnl, varargin)

iFlag = 0;
for k = 1:length(varargin)
    if or(isempty(varargin{k}.y), isempty(varargin{k}.dtype)); iFlag = 1; end
end

global HV; % allow access to global parameter structure
if and(HV.MESSAGES, iChnl > 0); 
    fprintf(1, 'Channel %d:', iChnl); % identify channel being processed if iChnl > 0
    if length(varargin{1}.title) > 0
        tlen = min(30, length(varargin{1}.title));
        tstr = varargin{1}.title(1:tlen);
        fprintf(1, [' ', tstr]); % identify channel being processed if iChnl > 0
        if length(varargin{1}.title) > 30; fprintf(1, '...'); end
    end
    fprintf(1, '\n');

end 
if and(HV.MESSAGES, iFlag); fprintf(1, '\tinput data structure is empty\n'); end

return;
