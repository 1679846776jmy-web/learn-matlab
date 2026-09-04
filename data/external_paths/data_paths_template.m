function paths = data_paths_template()
%DATA_PATHS_TEMPLATE External data path template for local fusion datasets.
%
% Keep large or private experimental data outside this learning library.
% Copy this file to data_paths_local.m if you need machine-specific paths.

paths = struct();
paths.efitRawDir = "";
paths.efitMatDir = "";
paths.dbsMatFile = "";
end
