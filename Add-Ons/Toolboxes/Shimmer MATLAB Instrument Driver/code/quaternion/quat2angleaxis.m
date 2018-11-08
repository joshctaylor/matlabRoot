function [angle,axis] = quat2angleaxis(q)

%QUAT2ANGLEAXIS - rotates the vector, v, by the quaternion, q.
%
%  QUAT2ANGLEAXIS(Q) converts the quaternion to angle-axis format. 
%
%  SYNOPSIS: quat2angleaxis(q)
%
%  INPUT: q - input quaternion
%  OUTPUT: angle - angle of rotation
%  OUTPUT: axis - axis of rotation
%
%  EXAMPLE: [angle, axis] = quat2angleaxis([0.5,0.5,0.5,0.5])


if size(q,2)~=4
    disp('Error: input array must be of dimension mx4.');
else
    numSamples = size(q,1);
    angle = zeros(numSamples,1);
    axis = zeros(numSamples,3);
    for n = 1:numSamples
        angle(n,:) =  2*atan2(sqrt(sum(q(n,2:4).^2)),q(1));
        axis(n,:) = q(n,2:4)/sin(angle(n,:)/2);
    end
end

