%% Tests for the standalone RK3 PDE project

testDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(testDir);
configDir = fullfile(projectRoot, "config");
sourceDir = fullfile(projectRoot, "src");
addpath(configDir);
addpath(sourceDir);
pathCleanup = onCleanup(@() cleanupProjectPaths(configDir, sourceDir));

cfg = defaultConfig();
[x_m, dx_m] = rk3pde.buildGrid(cfg);
assert(numel(x_m) == cfg.nCells);
assert(abs(dx_m*cfg.nCells - cfg.domainLength_m) < 10*eps);

constantState = ones(cfg.nCells, 1);
constantRhs = rk3pde.rhsAdvectionDiffusion(constantState, dx_m, cfg);
assert(max(abs(constantRhs)) < 1e-12);

u0 = rk3pde.initialCondition(x_m, cfg);
dt_s = rk3pde.stableTimeStep(dx_m, cfg);
rhsFunction = @(state) rk3pde.rhsAdvectionDiffusion(state, dx_m, cfg);
u1 = rk3pde.stepSSPRK3(u0, dt_s, rhsFunction);

assert(all(isfinite(u1)));
assert(abs(sum(u1) - sum(u0)) < 1e-10);
assert(max(u1) <= max(u0) + 1e-10);

fprintf("test_rk3_project passed\n");

function cleanupProjectPaths(configDir, sourceDir)
rmpath(configDir);
rmpath(sourceDir);
end
