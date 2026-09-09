%% Ch05 二维、三维可视化与磁面图
% 本章目标 / Learning objectives
%
% 1. 掌握二维场和三维曲面的基础画法。
% 2. 学会使用 meshgrid 构造 R-Z 网格。
% 3. 为后续 EFIT 磁通面可视化做准备。
% 4. 能把矩阵的行列与 R、Z 坐标正确对应，并解释颜色和等值线。
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

%% 1.1 meshgrid 输出尺寸和物理坐标怎样对应
% R 有 121 个位置，Z 有 161 个位置。meshgrid(R,Z) 生成的 RR、ZZ 都是
% 161x121：矩阵的每一列对应一个 R，矩阵的每一行对应一个 Z。
%
% 因此场量 psi(row,column) 可读成 psi(Z(row),R(column))。这也是 contour(RR,ZZ,psi)
% 和 imagesc(R,Z,psi) 能正确绘图的前提。若把 R、Z 顺序写反，代码可能仍能画出图，
% 但物理轴和矩阵方向会错位。
%
% RR 的每一行都是完整 R 轴副本，ZZ 的每一列都是完整 Z 轴副本。先看 size，
% 再看首行/首列，通常能快速确认方向。

fprintf("R points = %d, Z points = %d, field size = %d x %d.\n", ...
    numel(R), numel(Z), size(psi, 1), size(psi, 2));
disp(RR(1, 1:5));
disp(ZZ(1:5, 1).');

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

%% 2.1 等值线表达“场值相同的位置”
% contour 并不是直接画出网格线，而是在二维场中寻找指定数值的轨迹。`psi=1`
% 这条线之所以被当作玩具边界，是我们定义模型时赋予它这个意义；MATLAB 本身并
% 不知道哪条线是 LCFS，也不会自动判断磁轴或限制器。
%
% 等值线数量太少会隐藏结构，太多会让图难读。研究图中最好明确关键 levels，
% 例如 `[0.2 0.5 0.8 1.0]`，并把真正重要的边界用线型或颜色单独强调。

selectedFluxLevels = [0.2 0.5 0.8 1.0];
fprintf("Selected %d physically interpretable contour levels.\n", ...
    numel(selectedFluxLevels));

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

%% 3.1 填色图中的颜色必须能还原成数值
% contourf 把数值范围分成若干区间并填色，colorbar 给出颜色到数值的映射。若比较
% 多个 case，应尽量使用相同的 `clim`，否则两幅图颜色相同却可能代表不同数值。
%
% colormap 只改变视觉编码，不改变 pressure 数组。选择色图时应保证数值顺序清楚；
% 对有正有负且以 0 为中心的量，可考虑发散色图并把颜色范围对称设置。

pressureRange = [min(pressure(:)), max(pressure(:))];
fprintf("Color scale represents pressure in [%.3f, %.3f].\n", ...
    pressureRange(1), pressureRange(2));

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

%% 4.1 surf 是二维场的三维视角，不会增加新的物理维度
% surf 的 x、y 来自 R、Z，z 高度来自 pressure；表面颜色默认也与 z 值相关。
% 它有助于观察峰、谷和梯度，但透视和遮挡可能让精确比较变困难。需要读取具体
% 数值或边界位置时，contourf/imagesc 往往更直接。
%
% `view(2)` 可以把 surf 从正上方观察，`view(35,30)` 则给出倾斜三维视角。
% 不管视角如何变化，底层 pressure 数据都没有变化。

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

%% 5.1 imagesc 为什么经常需要 YDir normal
% 图像坐标习惯通常把第 1 行放在最上方，所以 imagesc 默认可能让 y 轴向下增加。
% R-Z 物理坐标通常希望 Z 向上增加，因此设置 `YDir` 为 `normal`。
%
% imagesc 更接近“每个矩阵单元显示一个颜色块”，适合快速查看大矩阵；contourf
% 强调连续等值区域。两者使用同一数据时，应检查轴范围、方向和颜色范围是否一致。

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
