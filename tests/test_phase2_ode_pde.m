%TEST_PHASE2_ODE_PDE Checks for ODE and PDE teaching helpers.

params = struct();
params.nTarget20 = 0.8;
params.tauParticle_s = 0.08;
params.edgeTe_keV = 0.12;
params.heatingGain_keV = 2.4;
params.heatingRamp_s = 0.04;
params.tauEnergy_s = 0.05;
params.radiationCoeff_per_s = 0.18;
params.densityFloor20 = 0.05;

y0 = [0.25; 0.18];
[time_s, state] = ode45(@(t, y) fusionlearn.plasma.toyZeroDPlasmaRhs(t, y, params), ...
    [0 0.25], y0);

assert(numel(time_s) == size(state, 1));
assert(all(isfinite(state), "all"));
assert(state(end, 1) > state(1, 1));
assert(state(end, 1) < params.nTarget20 + 0.05);
assert(state(end, 2) > state(1, 2));

x = linspace(-1, 1, 101).';
dx = x(2) - x(1);
chi = 0.06;
dt = fusionlearn.math.explicitDiffusionStableDt(dx, chi, 0.8);
assert(chi*dt/dx^2 <= 0.5);

u0 = exp(-25*x.^2);
[u1, stabilityNumber] = fusionlearn.math.explicitDiffusion1DStep(u0, dx, dt, chi, 0);
assert(stabilityNumber <= 0.5);
assert(all(isfinite(u1)));
assert(max(u1) <= max(u0));
assert(u1(1) == 0 && u1(end) == 0);

tooLargeDt = 1.1 * dx^2 / (2 * chi);
didError = false;
try
    fusionlearn.math.explicitDiffusion1DStep(u0, dx, tooLargeDt, chi, 0);
catch ME
    didError = strcmp(ME.identifier, "fusionlearn:UnstableTimeStep");
end
assert(didError);

fprintf("test_phase2_ode_pde passed.\n");
