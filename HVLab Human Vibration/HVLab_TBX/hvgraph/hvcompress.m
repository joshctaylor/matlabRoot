%hvcompress
%  [newstruct, nchans, chanindex]= hvchancompress(oldstruct)
%  examines an HVLAB data structure array and returns the number of channels, their index numbers
%  and a new data structure array with any empty channels removed
% written TPG 22/5/2002
% 
function [chans,nchans,chanind]= hvcompress(chanswithgaps)

% get the number of channels and ignore any channels without any data in them
nchans=0;
for q=1:length(chanswithgaps);
    % check if it might be a channel by looking for 'y' and 'dtype' and 'dxvar' fields
    if and(and(isfield(chanswithgaps(q),'y'),isfield(chanswithgaps(q),'dtype')), isfield(chanswithgaps(q),'dxvar'))
        % add a channel if data.y is longer than zero samples
        if length(chanswithgaps(q).y>0)
            nchans=nchans+1;
            chanind(nchans)=q;
            chans(nchans)=chanswithgaps(q);
        end
    end
end % end of get channels loop

return