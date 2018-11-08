% hvchancompress		
%  [newstructure,nchans,chanindex]= hvchancompress(struct)
% Examines and HVLab data structure and returns the number of channels, 
% their index numbers, and a new structure with any empty channels removed
% struct        = an HVLab data structure that may contain missing channels, 
%                  e.g. struct(1), struct(2) and struct (4) might contain data
% newstructure  = 'Struct' with any gaps removed. Using the example above, 
%                  newstructure(1) and (2) would be the same as struct(1) and (2)
%                  but struct(4) would be moved down to newstructure(3)
% nchans        = the numebr of channels in struct
% chanindex     = the locations of the channels in struct (using the example above
%                 chanindex=[1,2,4]
% function written by TPG 22-5-2002 for use by hvgraph
% modified TPG 23-12-2003 to check input arguments


function [chans,nchans,chanind]= hvchancompress(chanswithgaps)

% check data is a structure
if (HVCHECKARGUMENT('d',chanswithgaps,'Dataset passed to hvchancompress'))
    return
end
% Message to the user
HVFUNPAR('Restructuring the dataset to remove any empty channels')
% get the number of channels and ignore any channels without any data in them
nchans=0;
for q=1:length(chanswithgaps);
    % check if it might be a channel by looking for 'y' and 'dtype' and 'dxvar' fields
    if and(and(isfield(chanswithgaps(q),'y'),isfield(chanswithgaps(q),'dtype')),isfield(chanswithgaps(q),'dxvar'));
        % add a channel if data.y is longer than zero samples
        if length(chanswithgaps(q).y>0)
            nchans=nchans+1;
            chanind(nchans)=q;
            chans(nchans)=chanswithgaps(q);
        end
    end
end % end of get channels loop
