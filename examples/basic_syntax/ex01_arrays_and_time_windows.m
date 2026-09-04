%EX01_ARRAYS_AND_TIME_WINDOWS Basic arrays and logical indexing.

clear; clc; close all;
startup_learning;

demo = fusionlearn.io.makeDemoSignal("DurationMs", 20, "SampleRateHz", 100000);

timeWindow = demo.time_ms >= 8 & demo.time_ms <= 12;
time_cut = demo.time_ms(timeWindow);
signal_cut = demo.signal(timeWindow);

figure("Color", "w");
plot(demo.time_ms, demo.signal, "Color", [0.75 0.75 0.75]);
hold on;
plot(time_cut, signal_cut, "r", "LineWidth", 1.2);
xlabel("Time (ms)");
ylabel("Signal (a.u.)");
title("Select a time window using logical indexing");
legend("Full signal", "Selected window");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

assert(numel(time_cut) == numel(signal_cut));
assert(all(time_cut >= 8 & time_cut <= 12));

