function [paths, sourceName] = getExternalDataPaths()
%GETEXTERNALDATAPATHS Load local external data paths when available.
%
% Public repositories should only contain data_paths_template.m. A private
% data_paths_local.m can be kept on one machine and is ignored by Git.

if exist("data_paths_local", "file") == 2
    paths = data_paths_local();
    sourceName = "data_paths_local";
else
    paths = data_paths_template();
    sourceName = "data_paths_template";
end
end

