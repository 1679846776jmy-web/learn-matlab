%EX02_INTEGRAL_GRADIENT_INTERPOLATION Practice integration, gradients, and interpolation.

clear; clc; close all;
startup_learning;

x = linspace(0, pi, 101).';
y = sin(x);
integralValue = fusionlearn.math.integrateProfileTrapz(x, y);
fprintf("Integral of sin(x) from 0 to pi ~= %.6f\n", integralValue);
assert(abs(integralValue - 2) < 1e-3);

xQuery = linspace(0, pi, 301).';
yQuery = fusionlearn.math.interpolateProfile1D(x, y, xQuery, "pchip");

figure("Color", "w");
plot(x, y, "ko", "MarkerSize", 4);
hold on;
plot(xQuery, yQuery, "b-", "LineWidth", 1.2);
xlabel("x");
ylabel("sin(x)");
title("Profile interpolation");
legend("Original grid", "Interpolated profile");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

rx = linspace(-1, 1, 81);
zy = linspace(-1, 1, 91);
[RR, ZZ] = meshgrid(rx, zy);
F = RR.^2 + 2*ZZ.^2;
[dFdr, dFdz] = fusionlearn.math.gradient2DUniform(rx, zy, F);

assert(max(abs(dFdr(:) - 2*RR(:))) < 0.05);
assert(max(abs(dFdz(:) - 4*ZZ(:))) < 0.1);

