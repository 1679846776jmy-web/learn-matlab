function fig = plotSignalOverview(timeValue, signalValue, options)
%PLOTSIGNALOVERVIEW Plot a time trace and a simple amplitude histogram.

arguments
    timeValue (:,1) double
    signalValue (:,1) double
    options.TimeUnit (1,1) string = "ms"
    options.SignalName (1,1) string = "signal"
    options.SignalUnit (1,1) string = "a.u."
end

if numel(timeValue) ~= numel(signalValue)
    error("fusionlearn:SizeMismatch", "timeValue and signalValue must have the same length.");
end

fig = figure("Color", "w");
tiledlayout(fig, 2, 1, "TileSpacing", "compact");

nexttile;
plot(timeValue, signalValue, "LineWidth", 1.1);
xlabel("Time (" + options.TimeUnit + ")");
ylabel(options.SignalName + " (" + options.SignalUnit + ")");
title("Time trace");
fusionlearn.plot.applyResearchStyle(gca);

nexttile;
histogram(signalValue, 40);
xlabel(options.SignalName + " (" + options.SignalUnit + ")");
ylabel("Counts");
title("Amplitude distribution");
fusionlearn.plot.applyResearchStyle(gca);
end

