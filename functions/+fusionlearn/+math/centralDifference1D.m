function dydx = centralDifference1D(x, y)
%CENTRALDIFFERENCE1D Estimate dy/dx on a one-dimensional grid.
%
% The first and last points use one-sided differences. Interior points use
% central differences. Use this for learning; gradient is better tested for
% production work.

arguments
    x (:,1) double
    y (:,1) double
end

if numel(x) ~= numel(y)
    error("fusionlearn:SizeMismatch", "x and y must have the same length.");
end
if numel(x) < 3
    error("fusionlearn:NotEnoughPoints", "At least three points are required.");
end
if any(diff(x) <= 0)
    error("fusionlearn:NonMonotonicGrid", "x must be strictly increasing.");
end

dydx = zeros(size(y));
dydx(1) = (y(2) - y(1)) / (x(2) - x(1));
dydx(end) = (y(end) - y(end-1)) / (x(end) - x(end-1));
dydx(2:end-1) = (y(3:end) - y(1:end-2)) ./ (x(3:end) - x(1:end-2));
end

