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

%% 10. 加厚练习 / Extra exercises
%
% 练习 A：画 psi = 0.5 和 psi = 1.0 两条等值线。
% 练习 B：用 axis image 和 axis equal 比较效果。
% 练习 C：用 colormap turbo 改变色图。
% 练习 D：计算 pressure 的最大值和最小值。
% 练习 E：用逻辑索引找出 psi <= 1 的等离子体区域。

insidePlasma = psi <= 1;
pressureMin = min(pressure(:));
pressureMax = max(pressure(:));
fprintf("Pressure range: [%.3f, %.3f]\n", pressureMin, pressureMax);

figure("Color", "w");
contour(RR, ZZ, psi, [0.5 1.0], "LineWidth", 1.5);
xlabel("R (m)");
ylabel("Z (m)");
title("Selected toy flux surfaces");
axis equal tight;
grid on;
fusionlearn.plot.applyResearchStyle(gca);

figure("Color", "w");
imagesc(R, Z, insidePlasma);
set(gca, "YDir", "normal");
axis equal tight;
colormap(gca, "gray");
colorbar;
xlabel("R (m)");
ylabel("Z (m)");
title("Inside plasma mask");
fusionlearn.plot.applyResearchStyle(gca);

%% 11. 小测验 / Mini quiz
%
% 选择题 1：构造二维网格常用：
% A. meshgrid
% B. legend
% C. save
% 答案：A
%
% 选择题 2：画等值线常用：
% A. contour
% B. whos
% C. load
% 答案：A
%
% 选择题 3：画二维彩色场常用：
% A. contourf 或 imagesc
% B. clc
% C. addpath
% 答案：A
%
% 选择题 4：R-Z 截面为了不变形，应常用：
% A. axis equal
% B. clear all
% C. xlabel off
% 答案：A
%
% 选择题 5：colorbar 的作用是：
% A. 说明颜色和数值之间的对应关系
% B. 自动修复数据
% C. 删除坐标轴
% 答案：A

%% 12. 错题案例 / Debug the mistake
%
% 错题 1：忘记 set(gca, "YDir", "normal")，imagesc 的 Z 方向可能倒置。

figure("Color", "w");
imagesc(R, Z, pressure);
set(gca, "YDir", "normal");
axis equal tight;
colorbar;
xlabel("R (m)");
ylabel("Z (m)");
title("Correct image orientation");
fusionlearn.plot.applyResearchStyle(gca);
%
% 错题 2：没有检查矩阵尺寸。

assert(isequal(size(RR), size(psi)));
assert(isequal(size(ZZ), size(pressure)));
assert(any(insidePlasma(:)));

