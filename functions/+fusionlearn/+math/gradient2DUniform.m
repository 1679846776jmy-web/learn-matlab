function [dFdx, dFdy] = gradient2DUniform(x, y, F)
%GRADIENT2DUNIFORM Estimate partial derivatives on a uniform 2-D grid.
%
% x corresponds to columns of F, and y corresponds to rows of F. This is the
% common layout produced by [X,Y] = meshgrid(x,y).

arguments
    x (1,:) double
    y (1,:) double
    F (:,:) double
end

if size(F, 2) ~= numel(x) || size(F, 1) ~= numel(y)
    error("fusionlearn:GridSizeMismatch", ...
        "F must have size [numel(y), numel(x)] for meshgrid-style data.");
end
if numel(x) < 3 || numel(y) < 3
    error("fusionlearn:NotEnoughPoints", "x and y must each contain at least three points.");
end

dx = mean(diff(x));
dy = mean(diff(y));

if max(abs(diff(x) - dx)) > 1e-10 * max(1, abs(dx))
    error("fusionlearn:NonUniformGrid", "x must be uniformly spaced.");
end
if max(abs(diff(y) - dy)) > 1e-10 * max(1, abs(dy))
    error("fusionlearn:NonUniformGrid", "y must be uniformly spaced.");
end

[dFdx, dFdy] = gradient(F, dx, dy);
end
