%% Ch08 数值积分、微分、偏导与插值
% 本章目标 / Learning objectives
%
% 1. 会用 MATLAB 对离散数据做积分和微分。
% 2. 理解网格间距、边界点和数值误差。
% 3. 会在一维剖面和二维 R-Z 网格上做插值和偏导。
%
% Key terms:
% numerical integration, trapezoidal rule, derivative, finite difference,
% partial derivative, interpolation, gradient, grid spacing

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. 数值积分：trapz 与 integral
% trapz 用离散点积分。
% integral 用函数句柄做自适应积分。

x = linspace(0, pi, 101).';
y = sin(x);

area_trapz = fusionlearn.math.integrateProfileTrapz(x, y);
area_integral = integral(@(xx) sin(xx), 0, pi);

fprintf("trapz result    = %.8f\n", area_trapz);
fprintf("integral result = %.8f\n", area_integral);
fprintf("exact result    = %.8f\n", 2.0);

assert(abs(area_trapz - 2) < 1e-3);
assert(abs(area_integral - 2) < 1e-12);

%% 2. 累积积分：cumtrapz
% cumtrapz 能显示积分量如何沿着坐标逐渐累积。

cumulativeArea = cumtrapz(x, y);

figure("Color", "w");
plot(x, cumulativeArea, "LineWidth", 1.2);
xlabel("x");
ylabel("Cumulative integral");
title("Cumulative integral of sin(x)");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 3. 数值微分：diff、gradient 和中心差分
% diff 会让结果少一个点。
% gradient 尽量保持和原数组同样长度。

xFine = linspace(0, 2*pi, 1001).';
yFine = sin(xFine);

dy_dx_gradient = gradient(yFine, xFine);
dy_dx_custom = fusionlearn.math.centralDifference1D(xFine, yFine);
dy_dx_exact = cos(xFine);

interior = 2:numel(xFine)-1;
errGradient = max(abs(dy_dx_gradient(interior) - dy_dx_exact(interior)));
errCustom = max(abs(dy_dx_custom(interior) - dy_dx_exact(interior)));

fprintf("gradient error = %.3e\n", errGradient);
fprintf("custom central-difference error = %.3e\n", errCustom);

figure("Color", "w");
plot(xFine, dy_dx_exact, "k-", "LineWidth", 1.2);
hold on;
plot(xFine, dy_dx_custom, "r--", "LineWidth", 1.0);
xlabel("x");
ylabel("dy/dx");
title("Numerical derivative of sin(x)");
legend("Exact", "Central difference");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

assert(errCustom < 1e-4);

%% 4. 偏导数：二维网格上的 gradient
% 在 R-Z 平面中，经常需要计算 psi(R,Z) 的梯度。

R = linspace(1.0, 2.0, 101);
Z = linspace(-0.6, 0.6, 121);
[RR, ZZ] = meshgrid(R, Z);

R0 = 1.5;
kappa = 1.5;
psi = (RR - R0).^2 + (ZZ/kappa).^2;

[dPsi_dR, dPsi_dZ] = fusionlearn.math.gradient2DUniform(R, Z, psi);

figure("Color", "w");
contourf(RR, ZZ, psi, 30, "LineStyle", "none");
hold on;
skip = 1:10:numel(R);
skipZ = 1:10:numel(Z);
quiver(RR(skipZ, skip), ZZ(skipZ, skip), ...
    dPsi_dR(skipZ, skip), dPsi_dZ(skipZ, skip), "k");
colorbar;
xlabel("R (m)");
ylabel("Z (m)");
title("Toy flux and its gradient");
axis equal tight;
fusionlearn.plot.applyResearchStyle(gca);

%% 5. 一维插值
% 实验剖面经常来自不规则位置，需要插值到统一网格。

rho_sparse = linspace(0, 1, 12).';
temperature_sparse = 2.5*(1 - rho_sparse.^2) + 0.2;
rho_dense = linspace(0, 1, 101).';

temperature_linear = fusionlearn.math.interpolateProfile1D( ...
    rho_sparse, temperature_sparse, rho_dense, "linear");
temperature_pchip = fusionlearn.math.interpolateProfile1D( ...
    rho_sparse, temperature_sparse, rho_dense, "pchip");

figure("Color", "w");
plot(rho_sparse, temperature_sparse, "ko", "MarkerSize", 5);
hold on;
plot(rho_dense, temperature_linear, "b-", "LineWidth", 1.1);
plot(rho_dense, temperature_pchip, "r--", "LineWidth", 1.1);
xlabel("Normalized radius \rho");
ylabel("T_e (keV)");
title("Profile interpolation");
legend("Data", "Linear", "PCHIP");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 6. 常见错误 / Common mistakes
%
% 错误 1：忘记单位换算，例如 ms 和 s 混用。
% 错误 2：把 diff 的结果和原始 x 直接画在一起，长度不一致。
% 错误 3：不知道 gradient 在边界点使用单边近似。
% 错误 4：插值时没有确认 x 是否严格递增。

%% 7. 练习
%
% 练习 1：用 trapz 计算 0 到 1 上 x^2 的积分。
% 练习 2：把网格点数从 11 改到 1001，观察误差变化。
% 练习 3：用 centralDifference1D 计算 exp(-x) 的导数。
% 练习 4：构造 F = R.^2 + Z.^2，计算 dF/dR 和 dF/dZ。
% 练习 5：把稀疏温度剖面插值到 201 个点。
% 练习 6：故意打乱 x 的顺序，观察函数报错。
% 练习 7：用一句英文解释数值微分为什么容易放大噪声。

%% 8. 参考答案

x_ex = linspace(0, 1, 101).';
y_ex = x_ex.^2;
area_ex = fusionlearn.math.integrateProfileTrapz(x_ex, y_ex);
assert(abs(area_ex - 1/3) < 1e-4);

x_exp = linspace(0, 3, 1001).';
y_exp = exp(-x_exp);
dy_exp_numeric = fusionlearn.math.centralDifference1D(x_exp, y_exp);
dy_exp_exact = -exp(-x_exp);
assert(max(abs(dy_exp_numeric(2:end-1) - dy_exp_exact(2:end-1))) < 1e-5);

R_ex = linspace(-1, 1, 81);
Z_ex = linspace(-1, 1, 91);
[RR_ex, ZZ_ex] = meshgrid(R_ex, Z_ex);
F_ex = RR_ex.^2 + ZZ_ex.^2;
[dF_dR_ex, dF_dZ_ex] = fusionlearn.math.gradient2DUniform(R_ex, Z_ex, F_ex);
assert(max(abs(dF_dR_ex(:) - 2*RR_ex(:))) < 0.05);
assert(max(abs(dF_dZ_ex(:) - 2*ZZ_ex(:))) < 0.05);

rho_201 = linspace(0, 1, 201).';
temperature_201 = fusionlearn.math.interpolateProfile1D( ...
    rho_sparse, temperature_sparse, rho_201, "pchip");
assert(numel(temperature_201) == 201);

fprintf("Numerical differentiation can amplify noise because it measures local changes between nearby points.\n");

%% 9. 小测验 / Mini quiz
%
% 选择题 1：离散数据积分常用：
% A. trapz
% B. eig
% C. legend
% 答案：A
%
% 选择题 2：保持导数结果和原数组长度一致，常用：
% A. gradient
% B. diff
% C. mkdir
% 答案：A
%
% 选择题 3：一维插值常用：
% A. interp1
% B. spy
% C. close all
% 答案：A
%
% 选择题 4：二维 R-Z 网格偏导计算前必须确认：
% A. 矩阵尺寸和网格方向匹配
% B. 图标题足够长
% C. 文件名必须中文
% 答案：A
%
% 选择题 5：数值微分对噪声通常：
% A. 比积分更敏感
% B. 完全不敏感
% C. 自动消除噪声
% 答案：A

%% 10. 错题案例 / Debug the mistake
%
% 错题 1：diff 之后长度少一个点。

dy_diff = diff(yFine) ./ diff(xFine);
x_mid = 0.5 * (xFine(1:end-1) + xFine(2:end));
assert(numel(dy_diff) == numel(x_mid));
%
% 错题 2：插值坐标没有递增。

x_good = [0; 1; 2; 3];
y_good = [0; 1; 4; 9];
xq_good = (0:0.25:3).';
yq_good = fusionlearn.math.interpolateProfile1D(x_good, y_good, xq_good, "linear");
assert(numel(yq_good) == numel(xq_good));

%% 11. 本章检查表
%
% [ ] 我能用 trapz 和 integral 做积分。
% [ ] 我知道 diff 和 gradient 的长度差异。
% [ ] 我能计算一维数值导数。
% [ ] 我能在 R-Z 网格上计算偏导。
% [ ] 我能把稀疏剖面插值到统一网格。

