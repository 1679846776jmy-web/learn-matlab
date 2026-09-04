%TEST_PHASE1_BASICS Basic checks for the first learning package.

data = fusionlearn.io.makeDemoSignal("DurationMs", 5, "SampleRateHz", 10000);
assert(isfield(data, "time_ms"));
assert(isfield(data, "signal"));
assert(numel(data.time_ms) == numel(data.signal));
assert(all(diff(data.time_ms) > 0));

x = linspace(0, 2*pi, 1001).';
y = sin(x);
dydx = fusionlearn.math.centralDifference1D(x, y);
maxError = max(abs(dydx(2:end-1) - cos(x(2:end-1))));
assert(maxError < 1e-4);

tmpFile = fullfile(tempdir, "fusionlearn_test_signal.mat");
save(tmpFile, "data");
info = fusionlearn.io.checkMatFileInfo(tmpFile);
assert(any(strcmp({info.name}, "data")));
loaded = fusionlearn.io.loadMatVariable(tmpFile, "data");
assert(isequal(size(loaded.signal), size(data.signal)));

fprintf("test_phase1_basics passed.\n");

