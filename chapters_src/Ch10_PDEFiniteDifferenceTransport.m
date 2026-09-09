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

%% 1.1 PDE 比 ODE 多出的核心是“空间耦合”
% ODE 只追踪有限个状态随时间变化；PDE 中 u=u(x,t)，每个位置都有自己的状态，
% 又通过空间导数与邻近位置耦合。离散 x 后，121 个网格点就变成 121 个随时间变化
% 的未知量，PDE 暂时转化为一个大型 ODE 系统。
%
% 二阶导数衡量曲线弯曲程度。峰顶通常向下弯，d2u/dx2<0，所以扩散使峰下降；谷底
% 向上弯，二阶导数为正，所以扩散使谷上升。整体效果是抹平空间差异。
%
% 量纲上，du/dt 的单位为 u/s，d2u/dx2 为 u/m^2，因此 chi 的单位应为 m^2/s。
% 本章 x 使用归一化坐标时，chi 也只是与该归一化一致的玩具系数，不能直接当真实
% 实验输运系数报告。

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

%% 2.1 一次显式推进实际做了四件事
% 第一步：读取当前 u 和边界条件。
% 第二步：在每个内部点计算二阶空间差分。
% 第三步：用 `uNext=u+dt*chi*d2u_dx2` 推进一个时间步。
% 第四步：重新施加边界值，并把结果作为下一步输入。
%
% 这个函数每次只推进一步，外层脚本决定推进多少步、何时保存快照。这种职责拆分使
% 单步公式可以独立测试，也让主脚本清楚表达时间循环。
%
% 当前示例固定两端 u=0，属于 Dirichlet 边界。剖面扩散到边缘后可以通过边界损失，
% 因而全域积分不一定守恒。周期边界或零通量 Neumann 边界会有不同的总量行为。

initialIntegral = trapz(x, snapshots(:,1));
finalIntegral = trapz(x, snapshots(:,end));
fprintf("Profile integral changed from %.4f to %.4f with fixed-zero boundaries.\n", ...
    initialIntegral, finalIntegral);

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

%% 3.1 稳定性限制连接了网格、时间步和计算成本
% 对本章的显式中心差分扩散格式，sigma=chi*dt/dx^2 不应超过约 1/2。
% chi 越大或 dx 越小，允许的 dt 越小。空间网格加密两倍使 dx 减半，稳定时间步
% 大约缩小到四分之一；同一总时间需要约四倍步数，同时每一步网格点也翻倍。
%
% 因此一维显式扩散的总工作量会迅速增加。隐式方法每一步需要解线性系统，但可允许
% 更大的稳定时间步。稳定不等于精确：即使 sigma<1/2，dt 或 dx 仍可能太粗，必须
% 通过网格/时间步收敛检查判断误差。

refinedDx = dx/2;
refinedStableDt = fusionlearn.math.explicitDiffusionStableDt( ...
    refinedDx, chi, 0.8);
fprintf("Halving dx changes stable dt by a factor of %.3f.\n", ...
    refinedStableDt/dt);

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

%% 4.1 矩阵写法让“邻点耦合”可见
% D2 的三条主要对角线分别表示左邻点、当前点和右邻点系数。`D2*u` 一次计算所有
% 网格点的离散二阶导数，和逐点循环使用相同公式。
%
% 但边界行不能只照抄内部 stencil。本例比较时只检查 interior，因为 helper 函数
% 会明确把边界设为 0，而 D2 的 interior 模式没有完整表达同样的边界更新。
%
% 对线性扩散，显式一步也可写成 `uNext=(I+dt*chi*D2)*u`。这个推进矩阵的特征值
% 与稳定性有关；后续更深入的数值分析会把 Ch07 的线性代数和本章联系起来。

interiorStencil = full(D2(round(numel(x)/2), ...
    round(numel(x)/2)+(-1:1)));
disp("Interior D2 stencil coefficients:");
disp(interiorStencil);

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

%% 5.1 公平比较输运系数必须跑到同一物理时间
% 不同 chi 的稳定 dt 不同，所以每个 case 使用的 nSteps 也不同。本例先固定
% totalTime_s，再为每个 chi 选择稳定时间步，并把 dt 调整为恰好到达同一终止时间。
% 如果只让每个 case 跑相同步数，比较到的实际时间不同，结论会混入时间差异。
%
% 峰值下降是一种指标，但不是唯一指标。还可以比较剖面宽度、梯度、边界通量和全域
% 积分。数值格式本身也可能引入人工扩散，所以解释“chi 变大导致扩散增强”前，应先
% 做网格收敛，确认变化主要来自物理参数而不是离散误差。

scanPeak = max(finalProfiles, [], 1);
scanWidthProxy = zeros(size(chiList));
for caseIndex = 1:numel(chiList)
    normalizedProfile = finalProfiles(:,caseIndex) ...
        / max(finalProfiles(:,caseIndex));
    scanWidthProxy(caseIndex) = trapz(x, normalizedProfile);
end
disp(table(chiList.', scanPeak.', scanWidthProxy.', ...
    'VariableNames', ["Chi", "Peak", "WidthProxy"]));

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
