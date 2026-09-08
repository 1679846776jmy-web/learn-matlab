%EX04_DIFFUSION_TRANSPORT_1D Simulate a teaching one-dimensional diffusion model.

clear; clc; close all;
learningRoot = fileparts(fileparts(fileparts(mfilename("fullpath"))));
addpath(learningRoot);
addpath(fullfile(learningRoot, "functions"));
addpath(fullfile(learningRoot, "data", "external_paths"));
startup_learning;

x = linspace(-1, 1, 121).';
dx = x(2) - x(1);
chi = 0.08;
dt = fusionlearn.math.explicitDiffusionStableDt(dx, chi, 0.8);
nSteps = 160;

u = exp(-30*x.^2);
snapshotSteps = [0 20 80 160];
snapshots = zeros(numel(x), numel(snapshotSteps));
snapshots(:,1) = u;

for step = 1:nSteps
    u = fusionlearn.math.explicitDiffusion1DStep(u, dx, dt, chi, 0);
    idx = find(snapshotSteps == step, 1);
    if ~isempty(idx)
        snapshots(:,idx) = u;
    end
end

figure("Color", "w");
plot(x, snapshots, "LineWidth", 1.2);
xlabel("x");
ylabel("u");
title("Explicit 1-D diffusion");
legend("step 0", "step 20", "step 80", "step 160", "Location", "best");
grid on;
fusionlearn.plot.applyResearchStyle(gca);
