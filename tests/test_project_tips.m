%% Verify the Ch11 standalone RK3 project from the course test runner.

testDir = fileparts(mfilename("fullpath"));
rootDir = fileparts(testDir);
projectRoot = fullfile(rootDir, "examples", "project_tips", ...
    "rk3_pde_project");
configDir = fullfile(projectRoot, "config");
sourceDir = fullfile(projectRoot, "src");

assert(isfile(fullfile(projectRoot, "main_run_case.m")));
assert(isfile(fullfile(configDir, "defaultConfig.m")));
addpath(configDir);
addpath(sourceDir);
pathCleanup = onCleanup(@() cleanupProjectTipsPaths(configDir, sourceDir));

cfg = defaultConfig();
[x_m, dx_m] = rk3pde.buildGrid(cfg);
u0 = rk3pde.initialCondition(x_m, cfg);
dt_s = rk3pde.stableTimeStep(dx_m, cfg);
rhsFunction = @(state) rk3pde.rhsAdvectionDiffusion(state, dx_m, cfg);
u1 = rk3pde.stepSSPRK3(u0, dt_s, rhsFunction);

assert(isequal(size(u1), size(u0)));
assert(all(isfinite(u1)));
assert(abs(sum(u1) - sum(u0)) < 1e-10);

fprintf("test_project_tips passed\n");

function cleanupProjectTipsPaths(configDir, sourceDir)
rmpath(configDir);
rmpath(sourceDir);
end
