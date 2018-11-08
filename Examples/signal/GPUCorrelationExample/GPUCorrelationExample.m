%% Accelerating Correlation with GPUs
% This example shows how a GPU can be used to accelerate cross-correlation.
% Many correlation problems involve large data sets and can be solved much
% faster using a GPU. To use this example, you must have a Parallel
% Computing Toolbox(TM) user license and a CUDA-enabled NVIDIA GPU with
% compute capability 1.3 or above.

%   Copyright 2012-2013 The MathWorks, Inc.

%% Introduction
% To execute this example, you must have a GPU with a ComputeCapability of
% 1.3 or greater.  You access the GPU using the Parallel Computing Toolbox
% product. First, it is important to know basic information about the GPU
% in your machine.

fprintf('Benchmarking GPU-accelerated Cross-Correlation.\n');

if ~(parallel.gpu.GPUDevice.isAvailable)
    fprintf(['\n\t**GPU does not have a compute capability of 1.3 or ' ...
             'greater. Stopping.**\n']);
    return;
else
    dev = gpuDevice;
    fprintf(...
    'GPU detected (%s, %d multiprocessors, Compute Capability %s)',...
    dev.Name, dev.MultiprocessorCount, dev.ComputeCapability);
end



%% Benchmarking Functions
% Because code written for the CPU can be ported to run on the GPU, a
% single function can be used to benchmark both the CPU and GPU. However,
% because code on the GPU executes asynchronously from the CPU, special
% precaution should be taken when measuring performance. Before measuring
% the time taken to execute a function, ensure that all GPU processing has
% finished by executing the 'wait' method on the device. This extra call
% will have no effect on the CPU performance.
%
% This example benchmarks three different types of cross-correlation.

%% Benchmark Simple Cross-Correlation
% For the first case, two vectors of equal size are cross-correlated
% using the syntax xcorr(u,v). The ratio of CPU execution time to GPU
% execution time is plotted against the size of the vectors.

fprintf('\n\n *** Benchmarking vector-vector cross-correlation*** \n\n');
fprintf('Benchmarking function :\n');
type('benchXcorrVec');
fprintf('\n\n');

sizes = [2000 1e4 1e5 5e5 1e6]; 
tc = zeros(1,numel(sizes));
tg = zeros(1,numel(sizes));
numruns = 10;

for s=1:numel(sizes);
    fprintf('Running xcorr of %d elements...\n', sizes(s));
    delchar = repmat('\b', 1,numruns);
    
    a = rand(sizes(s),1);
    b = rand(sizes(s),1);
    tc(s) = benchXcorrVec(a, b, numruns);
    fprintf([delchar '\t\tCPU  time : %.2f ms\n'], 1000*tc(s));
    tg(s) = benchXcorrVec(gpuArray(a), gpuArray(b), numruns);
    fprintf([delchar '\t\tGPU time :  %.2f ms\n'], 1000*tg(s));
end

%Plot the results
fig = figure;
ax = axes('parent', fig);
semilogx(ax, sizes, tc./tg, 'r*-');
ylabel(ax, 'Speedup');
xlabel(ax, 'Vector size');
title(ax, 'GPU Acceleration of XCORR');
drawnow;


%% Benchmarking Matrix Column Cross-Correlation
% For the second case, the columns of a matrix A are pairwise
% cross-correlated to produce a large matrix output of all correlations
% using the syntax xcorr(A). The ratio of CPU execution time to GPU
% execution time is plotted against the size of the matrix A.

fprintf('\n\n *** Benchmarking matrix column cross-correlation*** \n\n');
fprintf('Benchmarking function :\n');
type('benchXcorrMatrix');
fprintf('\n\n');

sizes = floor(linspace(0,100, 11));
sizes(1) = [];
tc = zeros(1,numel(sizes));
tg = zeros(1,numel(sizes));
numruns = 10;

for s=1:numel(sizes);
    fprintf('Running xcorr (matrix) of a %d x %d matrix...\n', sizes(s), sizes(s));
    delchar = repmat('\b', 1,numruns);
    
    a = rand(sizes(s));
    tc(s) = benchXcorrMatrix(a, numruns);
    fprintf([delchar '\t\tCPU  time : %.2f ms\n'], 1000*tc(s));
    tg(s) = benchXcorrMatrix(gpuArray(a), numruns);
    fprintf([delchar '\t\tGPU time :  %.2f ms\n'], 1000*tg(s));
end

%Plot the results
fig = figure;
ax = axes('parent', fig);
plot(ax, sizes.^2, tc./tg, 'r*-');
ylabel(ax, 'Speedup');
xlabel(ax, 'Matrix Elements');
title(ax, 'GPU Acceleration of XCORR (Matrix)');
drawnow;


%% Benchmarking Two-Dimensional Cross-Correlation
% For the final case, two matrices, X and Y, are cross correlated using
% xcorr2(X,Y). X is fixed in size while Y is allowed to vary. The
% speedup is plotted against the size of the second matrix.

fprintf('\n\n *** Benchmarking 2-D cross-correlation*** \n\n');
fprintf('Benchmarking function :\n');
type('benchXcorr2');
fprintf('\n\n');

sizes = [100, 200, 500, 1000, 1500, 2000];
tc = zeros(1,numel(sizes));
tg = zeros(1,numel(sizes));
numruns = 4;
a = rand(100);
  
for s=1:numel(sizes);
    fprintf('Running xcorr2 of a 100x100 matrix and %d x %d matrix...\n', sizes(s), sizes(s));
    delchar = repmat('\b', 1,numruns);
    
    b = rand(sizes(s));
    tc(s) = benchXcorr2(a, b, numruns);
    fprintf([delchar '\t\tCPU  time : %.2f ms\n'], 1000*tc(s));
    tg(s) = benchXcorr2(gpuArray(a), gpuArray(b), numruns);
    fprintf([delchar '\t\tGPU time :  %.2f ms\n'], 1000*tg(s));
end

%Plot the results
fig = figure;
ax =axes('parent', fig);
semilogx(ax, sizes.^2, tc./tg, 'r*-');
ylabel(ax, 'Speedup');
xlabel(ax, 'Matrix Elements');
title(ax, 'GPU Acceleration of XCORR2');
drawnow;

fprintf('\n\nBenchmarking completed.\n\n');



%% Other GPU Accelerated Signal Processing Functions
% There are several other signal processing functions that can be run on
% the GPU. These functions include fft, ifft, conv, filter, fftfilt, and
% more. In some cases, you can achieve large acceleration relative to the
% CPU. For a full list of GPU accelerated signal processing functions
% <matlab:help('tocsiggpu') see the "GPU Acceleration" section> in the
% Signal Processing Toolbox (TM) table of contents.
