function D2 = makeSecondDerivativeMatrix(n, dx, boundaryType)
%MAKESECONDDERIVATIVEMATRIX Build a 1-D second-derivative matrix.
%
% D2 approximates d2u/dx2 on a uniform grid. The default boundary treatment
% is Dirichlet-like for teaching: boundary rows are set to identity.

arguments
    n (1,1) double {mustBeInteger, mustBeGreaterThanOrEqual(n, 3)}
    dx (1,1) double {mustBePositive}
    boundaryType (1,1) string = "dirichlet"
end

mainDiagonal = -2 * ones(n, 1);
offDiagonal = ones(n, 1);
D2 = spdiags([offDiagonal mainDiagonal offDiagonal], -1:1, n, n) / dx^2;

switch lower(boundaryType)
    case "dirichlet"
        D2(1, :) = 0;
        D2(1, 1) = 1;
        D2(end, :) = 0;
        D2(end, end) = 1;
    case "interior"
        % Keep the finite-difference stencil on all available rows.
    otherwise
        error("fusionlearn:UnknownBoundaryType", ...
            "Unsupported boundaryType: %s. Use 'dirichlet' or 'interior'.", boundaryType);
end
end

