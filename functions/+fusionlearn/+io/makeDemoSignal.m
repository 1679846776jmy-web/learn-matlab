function data = makeDemoSignal(varargin)
%MAKEDEMOSIGNAL Create a small reproducible synthetic diagnostic signal.

p = inputParser;
addParameter(p, "DurationMs", 20);
addParameter(p, "SampleRateHz", 100000);
addParameter(p, "MainFrequencyHz", 12000);
addParameter(p, "NoiseLevel", 0.12);
parse(p, varargin{:});

duration_s = p.Results.DurationMs / 1000;
fs = p.Results.SampleRateHz;
time_s = (0:1/fs:duration_s).';

rng(7);
slowTrend = 0.25 * sin(2*pi*400*time_s);
mainWave = sin(2*pi*p.Results.MainFrequencyHz*time_s);
secondaryWave = 0.35 * sin(2*pi*22000*time_s + 0.4);
noise = p.Results.NoiseLevel * randn(size(time_s));
signal = slowTrend + mainWave + secondaryWave + noise;

data = struct();
data.time_s = time_s;
data.time_ms = time_s * 1000;
data.signal = signal;
data.sampleRate_Hz = fs;
data.description = "Synthetic fluctuation signal for MATLAB learning";
end

