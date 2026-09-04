function rootDir = startup_learning()
%STARTUP_LEARNING Initialize paths for the MATLAB fusion learning library.
%
% Run this file from the repository root before opening the chapter files.

rootDir = fileparts(mfilename("fullpath"));

addpath(rootDir);
addpath(fullfile(rootDir, "functions"));
addpath(fullfile(rootDir, "data", "external_paths"));

fprintf("\nMATLAB fusion learning library is ready.\n");
fprintf("Root: %s\n", rootDir);
fprintf("Chapters: %s\n", fullfile(rootDir, "chapters"));
fprintf("Functions: %s\n", fullfile(rootDir, "functions", "+fusionlearn"));

try
    v = ver;
    fprintf("MATLAB version: %s\n", version);
    fprintf("Installed products detected: %d\n", numel(v));
catch
    fprintf("MATLAB version information is unavailable.\n");
end

fprintf("Next step: open chapters/Ch00_如何使用这套讲义.mlx\n\n");
end

