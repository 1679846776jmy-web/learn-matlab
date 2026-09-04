function mustExist = checkPathExists(pathValue, description)
%CHECKPATHEXISTS Check whether a file or folder exists and print a clear message.
%
% mustExist = fusionlearn.utils.checkPathExists(pathValue, description)

arguments
    pathValue (1,1) string
    description (1,1) string = "path"
end

mustExist = isfile(pathValue) || isfolder(pathValue);

if mustExist
    fprintf("[OK] %s exists: %s\n", description, pathValue);
else
    fprintf("[Missing] %s does not exist: %s\n", description, pathValue);
end
end

