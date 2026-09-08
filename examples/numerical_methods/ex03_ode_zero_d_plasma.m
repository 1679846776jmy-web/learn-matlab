%EX03_ODE_ZERO_D_PLASMA Solve a teaching zero-dimensional plasma ODE model.

clear; clc; close all;
learningRoot = fileparts(fileparts(fileparts(mfilename("fullpath"))));
addpath(learningRoot);
addpath(fullfile(learningRoot, "functions"));
addpath(fullfile(learningRoot, "data", "external_paths"));
startup_learning;

params = struct();
params.nTarget20 = 0.8;
params.tauParticle_s = 0.08;
params.edgeTe_keV = 0.12;
params.heatingGain_keV = 2.4;
params.heatingRamp_s = 0.04;
params.tauEnergy_s = 0.05;
params.radiationCoeff_per_s = 0.18;
params.densityFloor20 = 0.05;

tspan = [0 0.25];
y0 = [0.25; 0.18];

opts = odeset("RelTol", 1e-6, "AbsTol", 1e-8);
[time_s, state] = ode45(@(t, y) fusionlearn.plasma.toyZeroDPlasmaRhs(t, y, params), ...
    tspan, y0, opts);

figure("Color", "w");
tiledlayout(2, 1);

nexttile;
plot(1e3*time_s, state(:,1), "LineWidth", 1.3);
xlabel("Time (ms)");
ylabel("n_e (10^{20} m^{-3})");
title("Toy density evolution");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

nexttile;
plot(1e3*time_s, state(:,2), "LineWidth", 1.3);
xlabel("Time (ms)");
ylabel("T_e (keV)");
title("Toy temperature evolution");
grid on;
fusionlearn.plot.applyResearchStyle(gca);
