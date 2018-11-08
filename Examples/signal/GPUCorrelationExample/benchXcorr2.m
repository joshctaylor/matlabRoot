function t = benchXcorr2(X, Y, numruns)
%Used to benchmark xcorr2 on the CPU and GPU.

%   Copyright 2012 The MathWorks, Inc.
 
    timevec = zeros(1,numruns);
    gdev = gpuDevice;
    for ii=1:numruns,
        ts = tic;
        o = xcorr2(X,Y); %#ok<NASGU>
        wait(gdev)
        timevec(ii) = toc(ts);
        fprintf('.');
    end
    t = min(timevec);
end