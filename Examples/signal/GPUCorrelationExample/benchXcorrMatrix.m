function t = benchXcorrMatrix(A, numruns)
%Used to benchmark xcorr with Matrix input on CPU and GPU.
    
%   Copyright 2012 The MathWorks, Inc.

    timevec = zeros(1,numruns);
    gdev = gpuDevice;
    for ii=1:numruns,
        ts = tic;
        o = xcorr(A); %#ok<NASGU>
        wait(gdev)
        timevec(ii) = toc(ts);
        fprintf('.');
    end
    t = min(timevec);
end