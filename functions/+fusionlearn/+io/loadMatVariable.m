function value = loadMatVariable(filePath, variableName)
%LOADMATVARIABLE Load one named variable from a MAT file.

arguments
    filePath (1,1) string
    variableName (1,1) string
end

if ~isfile(filePath)
    error("fusionlearn:FileNotFound", "MAT file not found: %s", filePath);
end

names = string({whos("-file", filePath).name});
if ~any(names == variableName)
    error("fusionlearn:MissingVariable", ...
        "Variable '%s' was not found in %s.", variableName, filePath);
end

loaded = load(filePath, variableName);
value = loaded.(variableName);
end

