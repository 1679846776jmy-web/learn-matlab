%% Run one RK3 advection-diffusion case

clear; clc; close all;
projectRoot = fileparts(mfilename("fullpath"));
addpath(fullfile(projectRoot, "config"));
addpath(fullfile(projectRoot, "src"));

cfg = defaultConfig();
[x_m, dx_m] = rk3pde.buildGrid(cfg);
uInitial = rk3pde.initialCondition(x_m, cfg);
u = uInitial;

estimatedDt_s = rk3pde.stableTimeStep(dx_m, cfg);
nSteps = ceil(cfg.finalTime_s / estimatedDt_s);
dt_s = cfg.finalTime_s / nSteps;
rhsFunction = @(state) rk3pde.rhsAdvectionDiffusion(state, dx_m, cfg);

for stepIndex = 1:nSteps
    u = rk3pde.stepSSPRK3(u, dt_s, rhsFunction);
end

massChange = dx_m * (sum(u) - sum(uInitial));
fprintf("Completed %d RK3 steps with dt = %.4g s.\n", nSteps, dt_s);
fprintf("Discrete mass change = %.3e.\n", massChange);

fig = rk3pde.plotSolution(x_m, uInitial, u, cfg.finalTime_s);

if cfg.saveFigure
    outputDir = fullfile(projectRoot, "outputs");
    if ~isfolder(outputDir)
        mkdir(outputDir);
    end
    exportgraphics(fig, fullfile(outputDir, cfg.outputFileName), ...
        "Resolution", 180);
end
