%RUN_ALL_TESTS Run the learning library checks.

fprintf("\nRunning MATLAB fusion learning tests...\n");

rootDir = fileparts(fileparts(mfilename("fullpath")));
addpath(rootDir);
addpath(fullfile(rootDir, "functions"));
addpath(fullfile(rootDir, "data", "external_paths"));

run(fullfile(rootDir, "tests", "test_phase1_basics.m"));
run(fullfile(rootDir, "tests", "test_phase2_intro.m"));
run(fullfile(rootDir, "tests", "test_phase2_ode_pde.m"));

fprintf("All available tests passed.\n\n");
