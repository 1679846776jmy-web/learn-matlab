function result = integrateProfileTrapz(x, y)
%INTEGRATEPROFILETRAPZ Integrate a 1-D profile using the trapezoidal rule.

arguments
    x (:,1) double
    y (:,1) double
end

if numel(x) ~= numel(y)
    error("fusionlearn:SizeMismatch", "x and y must have the same length.");
end
if any(diff(x) <= 0)
    error("fusionlearn:NonMonotonicGrid", "x must be strictly increasing.");
end

result = trapz(x, y);
end

