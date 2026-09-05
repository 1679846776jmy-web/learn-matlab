%TEST_PHASE2_INTRO Checks for the first numerical-methods package.

n = 101;
x = linspace(0, 1, n).';
dx = x(2) - x(1);
D2 = fusionlearn.math.makeSecondDerivativeMatrix(n, dx, "interior");
assert(isequal(size(D2), [n n]));
assert(issparse(D2));

y = sin(pi*x);
d2y = D2 * y;
expected = -pi^2 * sin(pi*x);
interior = 2:n-1;
assert(max(abs(d2y(interior) - expected(interior))) < 1e-2);

xInt = linspace(0, pi, 1001).';
yInt = sin(xInt);
areaValue = fusionlearn.math.integrateProfileTrapz(xInt, yInt);
assert(abs(areaValue - 2) < 1e-5);

xQuery = linspace(0, pi, 2001).';
yQuery = fusionlearn.math.interpolateProfile1D(xInt, yInt, xQuery, "linear");
assert(numel(yQuery) == numel(xQuery));
assert(all(isfinite(yQuery)));

gridX = linspace(-1, 1, 51);
gridY = linspace(-1, 1, 61);
[XX, YY] = meshgrid(gridX, gridY);
F = XX.^2 + YY.^2;
[dFdx, dFdy] = fusionlearn.math.gradient2DUniform(gridX, gridY, F);
assert(max(abs(dFdx(:) - 2*XX(:))) < 0.05);
assert(max(abs(dFdy(:) - 2*YY(:))) < 0.05);

fprintf("test_phase2_intro passed.\n");

