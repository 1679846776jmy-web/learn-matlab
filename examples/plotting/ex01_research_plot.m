%EX01_RESEARCH_PLOT Make a simple research-style signal plot.

clear; clc; close all;
learningRoot = fileparts(fileparts(fileparts(mfilename("fullpath"))));
addpath(learningRoot);
addpath(fullfile(learningRoot, "functions"));
addpath(fullfile(learningRoot, "data", "external_paths"));
startup_learning;

demo = fusionlearn.io.makeDemoSignal("DurationMs", 12, "SampleRateHz", 50000);
signal_zero_mean = demo.signal - mean(demo.signal);

fusionlearn.plot.plotSignalOverview( ...
    demo.time_ms, signal_zero_mean, ...
    "TimeUnit", "ms", ...
    "SignalName", "zero-mean signal", ...
    "SignalUnit", "a.u.");

assert(abs(mean(signal_zero_mean)) < 1e-12);
