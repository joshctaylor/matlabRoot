% function to list the children of a particular type from a parent. Beware
% the string length
%
% function [handlelist]=HVGETOBTYPE(parent_handle,target_type);
% 
% Written TPG 15/6/2004 for use with HVGRAPHMENU

function [handlelist]=HVGETOBTYPE(parent_handle,target_type);

hlist=get(parent_handle,'children');
count1=1;
for q=1:length(hlist);
    obtype=get(hlist(q),'type');
    if obtype(1:length(target_type))==target_type;
        handlelist(count1)=hlist(q);
        count1=count1+1;
    end
end 
% if no matches are found
if ~exist('handlelist');
    handlelist=-1;
end