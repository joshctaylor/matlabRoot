
% by Tolga Birdal
% Q is an Mx4 matrix of quaternions. Qavg is the average quaternion
% Based on 
% Markley, F. Landis, Yang Cheng, John Lucas Crassidis, and Yaakov Oshman. 
% "Averaging quaternions." Journal of Guidance, Control, and Dynamics 30, 
% no. 4 (2007): 1193-1197.
%% 24/10/2017 updated to skip NaNs - Josh C Taylor
function [Qavg]=avg_quaternion_markley(Q)

% Form the symmetric accumulator matrix
A = zeros(4,4);
M = size(Q,1);

for i=1:M
    if ~any(isnan(Q(i,:))) %% skip over any NaNs
        q = Q(i,:)';
        A = q*q'+A; % rank 1 update
    end
end

% scale
A=(1.0/M)*A;

% Get the eigenvector corresponding to largest eigen value
[Qavg, Eval] = eigs(A,1);

end
