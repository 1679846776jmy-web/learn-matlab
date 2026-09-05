%EX01_MATRIX_DERIVATIVE_OPERATOR Build and test a finite-difference matrix.

clear; clc; close all;
startup_learning;

n = 101;
x = linspace(0, 1, n).';
dx = x(2) - x(1);

D2 = fusionlearn.math.makeSecondDerivativeMatrix(n, dx, "interior");
y = sin(pi*x);
d2y_numeric = D2 * y;
d2y_exact = -pi^2 * sin(pi*x);

interior = 2:n-1;
maxError = max(abs(d2y_numeric(interior) - d2y_exact(interior)));
fprintf("Max interior error = %.3e\n", maxError);

figure("Color", "w");
plot(x, d2y_exact, "k-", "LineWidth", 1.2);
hold on;
plot(x, d2y_numeric, "r--", "LineWidth", 1.1);
xlabel("x");
ylabel("d^2y/dx^2");
title("Second derivative matrix check");
legend("Exact", "Numerical");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

assert(maxError < 1e-2);

