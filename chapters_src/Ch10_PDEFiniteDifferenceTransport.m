%% Ch10 PDE 有限差分入门与一维输运模型
% 本章目标 / Learning objectives
%
% 1. 理解一维 PDE 如何先离散空间，再推进时间。
% 2. 会用二阶差分近似扩散项。
% 3. 理解显式 Euler 扩散格式的稳定性条件。
% 4. 用一个一维扩散模型类比入门输运问题。
%
% Key terms:
% partial differential equation, diffusion equation, finite difference,
% explicit Euler, stability number, boundary condition, transport coefficient

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. 从 PDE 到差分格式
% 一维扩散方程：
%
% du/dt = chi * d2u/dx2
%
% 这里 u 可以理解成温度扰动、密度扰动或任意被扩散抹平的剖面量。
% chi 是扩散系数，也常被当作输运强弱的玩具参数。
%
% 二阶空间差分：
%
% d2u/dx2 ≈ (u(i+1) - 2*u(i) + u(i-1)) / dx^2

x = linspace(-1, 1, 121).';
dx = x(2) - x(1);
chi = 0.08;
dt = fusionlearn.math.explicitDiffusionStableDt(dx, chi, 0.8);
stabilityNumber = chi * dt / dx^2;

fprintf("dx = %.4f\n", dx);
fprintf("dt = %.4e\n", dt);
fprintf("stability number chi*dt/dx^2 = %.3f\n", stabilityNumber);
assert(stabilityNumber <= 0.5);

%% 2. 显式推进一维扩散
% 显式 Euler 的思想：
%
% 下一步 = 当前值 + dt * 当前斜率
%
% 对扩散方程来说，当前斜率来自二阶空间导数。

u = exp(-30*x.^2);
initialPeak = max(u);

nSteps = 160;
snapshotSteps = [0 20 80 160];
snapshots = zeros(numel(x), numel(snapshotSteps));
snapshots(:,1) = u;

for step = 1:nSteps
    u = fusionlearn.math.explicitDiffusion1DStep(u, dx, dt, chi, 0);
    idx = find(snapshotSteps == step, 1);
    if ~isempty(idx)
        snapshots(:,idx) = u;
    end
end

assert(max(u) < initialPeak);
assert(all(isfinite(u)));

figure("Color", "w");
plot(x, snapshots, "LineWidth", 1.2);
xlabel("x");
ylabel("u");
title("Explicit 1-D diffusion");
legend("step 0", "step 20", "step 80", "step 160", "Location", "best");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 3. 稳定性条件
% 对最简单的一维显式扩散格式，稳定性条件大致是：
%
% chi * dt / dx^2 <= 1/2
%
% dt 太大时，数值解可能振荡、爆炸，或者在本讲义函数中直接报错。

tooLargeDt = 1.1 * dx^2 / (2 * chi);
didCatchUnstableStep = false;
try
    fusionlearn.math.explicitDiffusion1DStep(snapshots(:,1), dx, tooLargeDt, chi, 0);
catch ME
    didCatchUnstableStep = strcmp(ME.identifier, "fusionlearn:UnstableTimeStep");
    fprintf("Caught expected error: %s\n", ME.identifier);
end
assert(didCatchUnstableStep);

%% 4. 用矩阵理解扩散
% Ch07 中学过二阶导数矩阵 D2。
% 一步显式扩散也可以写成：
%
% u_next = u + dt * chi * D2 * u
%
% 在大型 PDE 程序中，矩阵、稀疏矩阵和边界条件会反复出现。

D2 = fusionlearn.math.makeSecondDerivativeMatrix(numel(x), dx, "interior");
u0 = exp(-30*x.^2);
uMatrix = u0 + dt * chi * (D2 * u0);
uHelper = fusionlearn.math.explicitDiffusion1DStep(u0, dx, dt, chi, 0);

interior = 2:numel(x)-1;
matrixHelperDifference = max(abs(uMatrix(interior) - uHelper(interior)));
fprintf("Matrix/helper interior difference: %.3e\n", matrixHelperDifference);
assert(matrixHelperDifference < 1e-12);

figure("Color", "w");
spy(D2);
title("Second-derivative matrix for 1-D diffusion");

%% 5. 输运系数扫描
% 在真实输运分析中，扩散系数越大，剖面通常越快被抹平。
% 这里用不同 chi 跑到同一个总时间，观察最终剖面差异。

chiList = [0.03 0.08 0.15];
totalTime_s = 0.08;
finalProfiles = zeros(numel(x), numel(chiList));

for k = 1:numel(chiList)
    chiNow = chiList(k);
    dtNow = fusionlearn.math.explicitDiffusionStableDt(dx, chiNow, 0.8);
    nStepsNow = ceil(totalTime_s / dtNow);
    dtNow = totalTime_s / nStepsNow;
    uNow = exp(-30*x.^2);
    for step = 1:nStepsNow
        uNow = fusionlearn.math.explicitDiffusion1DStep(uNow, dx, dtNow, chiNow, 0);
    end
    finalProfiles(:,k) = uNow;
end

figure("Color", "w");
plot(x, finalProfiles, "LineWidth", 1.2);
xlabel("x");
ylabel("u at final time");
title("Transport coefficient scan");
legend("\chi = 0.03", "\chi = 0.08", "\chi = 0.15", "Location", "best");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

assert(max(finalProfiles(:,3)) < max(finalProfiles(:,1)));

%% 6. 常见错误 / Common mistakes
%
% 错误 1：忘记稳定性条件，dt 取得太大。
% 改进：先用 explicitDiffusionStableDt 估算 dt。
%
% 错误 2：边界条件没说清楚。
% 改进：每个 PDE 小程序都要写清楚边界点怎么处理。
%
% 错误 3：把空间网格 x 和时间网格 t 混在一起。
% 改进：变量命名中保留 dx、dt、nSteps 等信息。
%
% 错误 4：没有保存中间快照。
% 改进：用 snapshots 保存关键时刻，方便画图和调试。

%% 7. 练习
%
% 练习 1：把初始条件改成 exp(-10*x.^2)，观察峰值下降速度。
% 练习 2：把 chi 改成 0.02，观察扩散变慢还是变快。
% 练习 3：把 snapshotSteps 加入 step 120。
% 练习 4：用 max(finalProfiles) 比较不同 chi 的最终峰值。
% 练习 5：故意把 dt 设大，观察报错。
% 练习 6：用一句英文解释 boundary condition 的含义。
% 练习 7：解释为什么 PDE 离散后经常出现大而稀疏的矩阵。

%% 8. 参考答案

uWide = exp(-10*x.^2);
uWideInitialPeak = max(uWide);
for step = 1:80
    uWide = fusionlearn.math.explicitDiffusion1DStep(uWide, dx, dt, chi, 0);
end
assert(max(uWide) < uWideInitialPeak);

chiSlow = 0.02;
dtSlow = fusionlearn.math.explicitDiffusionStableDt(dx, chiSlow, 0.8);
uSlow = exp(-30*x.^2);
for step = 1:80
    uSlow = fusionlearn.math.explicitDiffusion1DStep(uSlow, dx, dtSlow, chiSlow, 0);
end
assert(max(uSlow) > 0);

peakByChi = max(finalProfiles, [], 1);
disp(table(chiList.', peakByChi.', ...
    'VariableNames', ["chi", "final_peak"]));
assert(all(diff(peakByChi) < 0));

fprintf("A boundary condition defines how the solution behaves at the edge of the domain.\n");
fprintf("Finite-difference PDE matrices are often sparse because each grid point only couples to nearby points.\n");

%% 9. 小测验 / Mini quiz
%
% 选择题 1：一维扩散方程中的 chi 通常表示：
% A. 扩散或输运系数
% B. 图像窗口编号
% C. 文件扩展名
% 答案：A
%
% 选择题 2：显式扩散格式的稳定性数是：
% A. chi*dt/dx^2
% B. x + y
% C. numel(title)
% 答案：A
%
% 选择题 3：dt 太大可能导致：
% A. 数值不稳定
% B. 自动提高物理精度
% C. 文件自动保存
% 答案：A
%
% 选择题 4：PDE 空间离散后常得到：
% A. 矩阵问题
% B. Word 文档
% C. 图例标签
% 答案：A
%
% 选择题 5：边界条件描述的是：
% A. 区域边缘的解如何处理
% B. MATLAB 主题颜色
% C. GitHub 用户名
% 答案：A

%% 10. 错题案例 / Debug the mistake
%
% 错题 1：只更新内点，却忘了边界值。

uCase = exp(-20*x.^2);
[uCaseNext, sigmaCase] = fusionlearn.math.explicitDiffusion1DStep(uCase, dx, dt, chi, 0);
assert(sigmaCase <= 0.5);
assert(uCaseNext(1) == 0 && uCaseNext(end) == 0);
%
% 错题 2：以为空间点越多，dt 可以不变。
% 实际上 dx 变小后，稳定 dt 会按 dx^2 变小。

dxHalf = dx / 2;
dtHalf = fusionlearn.math.explicitDiffusionStableDt(dxHalf, chi, 0.8);
assert(dtHalf < dt);

%% 11. 本章检查表
%
% [ ] 我能写出一维扩散方程的差分格式。
% [ ] 我知道显式格式为什么有稳定性条件。
% [ ] 我能用函数推进一个时间步。
% [ ] 我能保存不同时间的剖面快照。
% [ ] 我能解释 chi 增大对剖面的影响。
