%% Ch05 二维、三维可视化与磁面图
% 本章目标 / Learning objectives
%
% 1. 掌握二维场和三维曲面的基础画法。
% 2. 学会使用 meshgrid 构造 R-Z 网格。
% 3. 为后续 EFIT 磁通面可视化做准备。
%
% Key terms:
% meshgrid, contour, contourf, surface plot, colorbar, flux surface, R-Z plane

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. 构造 R-Z 网格
% 在 Tokamak 截面中，R 通常表示大半径方向，Z 表示竖直方向。

R = linspace(1.0, 2.2, 121);
Z = linspace(-0.8, 0.8, 161);
[RR, ZZ] = meshgrid(R, Z);

R0 = 1.65;
a = 0.45;
kappa = 1.6;

psi = ((RR - R0)/a).^2 + (ZZ/(kappa*a)).^2;

%% 2. 用 contour 画模拟磁通面

figure("Color", "w");
contour(RR, ZZ, psi, 20, "LineWidth", 1.0);
hold on;
contour(RR, ZZ, psi, [1 1], "r", "LineWidth", 2.0);
plot(R0, 0, "kx", "MarkerSize", 10, "LineWidth", 2);
xlabel("R (m)");
ylabel("Z (m)");
title("Toy flux surfaces in the R-Z plane");
legend("Flux surfaces", "Boundary \psi=1", "Magnetic axis");
axis equal tight;
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 3. 用 contourf 和 colorbar 看二维场

pressure = exp(-psi);

figure("Color", "w");
contourf(RR, ZZ, pressure, 30, "LineStyle", "none");
colorbar;
xlabel("R (m)");
ylabel("Z (m)");
title("Toy pressure field");
axis equal tight;
fusionlearn.plot.applyResearchStyle(gca);

%% 4. 用 surf 看三维曲面

figure("Color", "w");
surf(RR, ZZ, pressure, "EdgeColor", "none");
xlabel("R (m)");
ylabel("Z (m)");
zlabel("Pressure (a.u.)");
title("3D surface view of pressure");
colorbar;
view(35, 30);
fusionlearn.plot.applyResearchStyle(gca);

%% 5. imagesc 的坐标方向
% imagesc 很适合快速看二维矩阵，但要注意 y 轴方向。

figure("Color", "w");
imagesc(R, Z, pressure);
set(gca, "YDir", "normal");
axis equal tight;
colorbar;
xlabel("R (m)");
ylabel("Z (m)");
title("Pressure field using imagesc");
fusionlearn.plot.applyResearchStyle(gca);

%% 6. 常见错误 / Common mistakes
%
% 错误 1：meshgrid 输出 RR、ZZ 的尺寸没看清。
% 错误 2：画 R-Z 截面忘记 axis equal，导致形状被拉伸。
% 错误 3：imagesc 默认 y 轴方向可能和物理直觉相反。
% 错误 4：colorbar 没有说明颜色代表什么。

%% 7. 练习
%
% 练习 1：把 kappa 改成 1.0，观察磁面形状。
% 练习 2：把 pressure 改成 exp(-2*psi)。
% 练习 3：用 contourf 画 psi。
% 练习 4：标出 R0 和 Z0。
% 练习 5：用 surf 画 psi 曲面。
% 练习 6：解释为什么 R-Z 图通常需要 axis equal。

%% 8. 参考答案

kappa_ex = 1.0;
psi_ex = ((RR - R0)/a).^2 + (ZZ/(kappa_ex*a)).^2;
pressure_ex = exp(-2*psi_ex);

figure("Color", "w");
contourf(RR, ZZ, psi_ex, 25, "LineStyle", "none");
hold on;
plot(R0, 0, "kx", "MarkerSize", 10, "LineWidth", 2);
colorbar;
xlabel("R (m)");
ylabel("Z (m)");
title("Toy circular flux surfaces");
axis equal tight;
fusionlearn.plot.applyResearchStyle(gca);

figure("Color", "w");
surf(RR, ZZ, psi_ex, "EdgeColor", "none");
xlabel("R (m)");
ylabel("Z (m)");
zlabel("\psi (a.u.)");
title("Surface plot of toy flux");
colorbar;
view(35, 30);
fusionlearn.plot.applyResearchStyle(gca);

assert(isequal(size(RR), size(ZZ)));
assert(isequal(size(RR), size(psi)));

%% 9. 本章检查表
%
% [ ] 我能用 meshgrid 构造二维网格。
% [ ] 我能画 contour 和 contourf。
% [ ] 我能画 surf。
% [ ] 我知道 imagesc 的 YDir 问题。
% [ ] 我知道 R-Z 截面图为什么要 axis equal。

