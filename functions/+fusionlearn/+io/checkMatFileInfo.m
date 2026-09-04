function info = checkMatFileInfo(filePath)
%CHECKMATFILEINFO Inspect variables stored in a MAT file without loading all data.
%
% info = fusionlearn.io.checkMatFileInfo(filePath)

arguments
    filePath (1,1) string
end

if ~isfile(filePath)
    error("fusionlearn:FileNotFound", "MAT file not found: %s", filePath);
end

info = whos("-file", filePath);

fprintf("MAT file: %s\n", filePath);
fprintf("Variables: %d\n", numel(info));
for k = 1:numel(info)
    sizeText = join(string(info(k).size), " x ");
    fprintf("  %-24s %-12s %12d bytes  [%s]\n", ...
        info(k).name, info(k).class, info(k).bytes, sizeText);
end
end

