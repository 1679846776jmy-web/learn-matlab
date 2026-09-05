function yQuery = interpolateProfile1D(x, y, xQuery, method)
%INTERPOLATEPROFILE1D Interpolate a one-dimensional profile.

arguments
    x (:,1) double
    y (:,1) double
    xQuery (:,1) double
    method (1,1) string = "linear"
end

if numel(x) ~= numel(y)
    error("fusionlearn:SizeMismatch", "x and y must have the same length.");
end
if any(diff(x) <= 0)
    error("fusionlearn:NonMonotonicGrid", "x must be strictly increasing.");
end

yQuery = interp1(x, y, xQuery, method, "extrap");
end

