%% Ch07 矩阵计算、线性方程、特征值与 SVD
% 本章目标 / Learning objectives
%
% 1. 理解 MATLAB 中矩阵计算为什么是科研代码的核心。
% 2. 会用 A\b 求解线性方程，而不是显式求逆。
% 3. 会计算特征值、特征向量和奇异值分解。
% 4. 初步理解有限差分矩阵在计算物理中的作用。
%
% Key terms:
% matrix, linear system, backslash operator, eigenvalue, eigenvector,
% singular value decomposition, sparse matrix, finite difference

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. 矩阵和向量
% 在 MATLAB 中，大多数数据天然是数组或矩阵。
% 聚变数据中的剖面、时间序列、R-Z 网格、诊断通道矩阵都可以用矩阵表达。

A = [3 1; 1 2];
b = [5; 5];

x = A \ b;
disp("Solution of A*x=b:");
disp(x);

assert(norm(A*x - b) < 1e-12);

%% 1.1 先读尺寸，再读线性方程的物理意义
% `A*x=b` 中，A 的每一行代表一个方程，每一列代表一个未知量；b 的元素数必须等于
% 方程数，x 的元素数等于未知量数。本例是 2 个方程、2 个未知量，所以 A 为 2x2，
% b 和 x 都是 2x1。
%
% 在真实计算中，A 可能来自离散方程、响应矩阵或最小二乘模型。矩阵元素和未知量
% 往往带单位，因此“尺寸正确”只是第一步，量纲也必须让每一行方程成立。
%
% 求得 x 后不要只看数值，要计算残差 `r=A*x-b`。残差接近 0 表示数值上满足这组
% 方程，但不自动证明模型、数据或边界条件正确。

linearResidual = A*x - b;
fprintf("A is %d x %d and residual norm is %.3e.\n", ...
    size(A, 1), size(A, 2), norm(linearResidual));

%% 2. 不推荐显式求逆
% 初学时常写 inv(A)*b，但数值计算中更推荐 A\b。

x_backslash = A \ b;
x_inverse = inv(A) * b;

fprintf("Difference between two solutions: %.3e\n", norm(x_backslash - x_inverse));
%
% English sentence:
% The backslash operator is preferred for solving linear systems.

%% 2.1 反斜杠不是“除法的另一种写法”
% `A\b` 是线性系统求解运算。MATLAB 会根据 A 的形状和结构选择合适算法，例如
% 方阵求解、三角系统或最小二乘。它通常比先算 inv(A) 再乘 b 更快、更稳定，也
% 避免显式构造一个本来不需要的逆矩阵。
%
% 当 A 不是方阵时，`A\b` 往往给出最小二乘意义下的解；当方程欠定、矩阵秩不足
% 或病态时，解的解释会更复杂。此时应检查 `rank(A)`、`cond(A)`、残差和问题本身
% 是否有足够独立信息。

overdeterminedA = [1 0; 1 1; 1 2];
overdeterminedB = [1.0; 2.1; 2.9];
leastSquaresX = overdeterminedA \ overdeterminedB;
leastSquaresResidual = overdeterminedA*leastSquaresX - overdeterminedB;
fprintf("Least-squares residual norm = %.3e.\n", ...
    norm(leastSquaresResidual));

%% 3. 特征值和特征向量
% 特征值问题 A*v = lambda*v 常用于模态、稳定性和振荡问题。

[V, D] = eig(A);
eigenvalues = diag(D);

disp("Eigenvalues:");
disp(eigenvalues);

firstResidual = norm(A*V(:,1) - eigenvalues(1)*V(:,1));
assert(firstResidual < 1e-12);

%% 3.1 特征值描述某些方向被矩阵怎样缩放
% 若非零向量 v 满足 A*v=lambda*v，矩阵作用后方向不变，只被 lambda 缩放，这个 v
% 是特征向量。动力系统线性化后，特征值实部常与增长/衰减有关，虚部常与振荡频率
% 有关；具体解释仍取决于方程形式和单位。
%
% eig 返回的顺序通常不应被当作固定规则。参数扫描中若要跟踪同一个模态，不能简单
% 假设“第 1 个特征值永远是同一模态”，还要比较数值邻近性或特征向量相似度。
% 特征向量的长度和正负号/复相位也不是唯一的，验证时应检查方程残差。

allEigenResiduals = vecnorm(A*V - V*D);
fprintf("Largest eigenpair residual = %.3e.\n", max(allEigenResiduals));

%% 4. SVD 入门
% SVD 可以用于降噪、数据压缩和模态分析。

t = linspace(0, 1, 200).';
modes = [sin(2*pi*t), cos(2*pi*t), sin(4*pi*t)];
weights = [3 1.5 0.4];
signalMatrix = modes * diag(weights);

rng(3);
noisyMatrix = signalMatrix + 0.15*randn(size(signalMatrix));
[U, S, Vsvd] = svd(noisyMatrix, "econ");
singularValues = diag(S);

figure("Color", "w");
plot(singularValues, "o-", "LineWidth", 1.2);
xlabel("Mode index");
ylabel("Singular value");
title("Singular values of a noisy signal matrix");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 4.1 SVD 把数据拆成“模式、强度和系数”
% 对 m x n 矩阵 X，经济型 SVD 写成 X=U*S*V'。U 的列可看成左侧模式，S 对角线
% 是从大到小排列的奇异值，V 描述这些模式在另一维度上的组合。
%
% 截断到前 k 个奇异值可得到秩 k 近似。若少数奇异值明显占主导，数据可能包含
% 低维结构；但把小奇异值全部当作噪声并不总正确，弱物理信号也可能位于较小模式中。
%
% 常用能量占比是奇异值平方的累计比例。选择 k 时同时看占比、重建误差、残差结构
% 和物理解释。

kKeep = 2;
rankKApproximation = U(:, 1:kKeep) * S(1:kKeep, 1:kKeep) ...
    * Vsvd(:, 1:kKeep)';
capturedFraction = sum(singularValues(1:kKeep).^2) ...
    / sum(singularValues.^2);
relativeReconstructionError = norm(noisyMatrix-rankKApproximation, "fro") ...
    / norm(noisyMatrix, "fro");
fprintf("First %d modes capture %.2f%%; relative error %.3f.\n", ...
    kKeep, 100*capturedFraction, relativeReconstructionError);

%% 5. 有限差分矩阵
% 二阶导数 d2u/dx2 可以写成矩阵乘法 D2*u。
% 这种思想会在 PDE 和输运模型中反复出现。

n = 101;
xgrid = linspace(0, 1, n).';
dx = xgrid(2) - xgrid(1);

D2 = fusionlearn.math.makeSecondDerivativeMatrix(n, dx, "interior");
y = sin(pi*xgrid);
d2y_numeric = D2 * y;
d2y_exact = -pi^2 * sin(pi*xgrid);

interior = 2:n-1;
maxError = max(abs(d2y_numeric(interior) - d2y_exact(interior)));
fprintf("Second derivative max interior error: %.3e\n", maxError);

figure("Color", "w");
plot(xgrid, d2y_exact, "k-", "LineWidth", 1.2);
hold on;
plot(xgrid, d2y_numeric, "r--", "LineWidth", 1.1);
xlabel("x");
ylabel("d^2y/dx^2");
title("Second derivative using a matrix operator");
legend("Exact", "Finite difference");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

assert(maxError < 1e-2);

%% 5.1 差分矩阵的内部行和边界行含义不同
% 对均匀网格，内部点二阶差分使用 `[1 -2 1]/dx^2`，所以 D2 的一行只连接当前点
% 及左右邻点。把所有内部点公式叠起来，就得到矩阵乘法 D2*y。
%
% 边界点没有完整的左右邻居，必须根据边界条件另行处理。本例函数的 "interior"
% 模式重点演示内部算子，因此误差只在 `2:n-1` 检查。真实 PDE 程序不能把边界行
% 当作无关细节；它们决定了方程问题是否闭合以及解的物理行为。
%
% 网格缩小一半时，二阶中心差分的内部截断误差理论上约缩小到四分之一。通过多组
% 网格验证这个趋势，叫网格收敛检查。

%% 6. 稀疏矩阵
% PDE 离散后经常得到很大的矩阵，但很多元素是 0。
% sparse matrix 可以节省内存和计算时间。

fprintf("D2 is sparse: %d\n", issparse(D2));
fprintf("Number of nonzero entries: %d\n", nnz(D2));

figure("Color", "w");
spy(D2);
title("Sparsity pattern of D2");

%% 6.1 稀疏矩阵只存“非零结构和值”
% 普通 n x n double 矩阵即使大部分为 0，也要为 n^2 个元素分配空间。sparse 主要
% 保存非零值及其位置。局部有限差分每个网格点只连接少量邻居，因此非零数通常随 n
% 线性增长，而不是随 n^2 增长。
%
% `nnz` 统计非零元素，`spy` 显示非零位置。稀疏并不保证所有运算都快；若中途把它
% 转成 full，或执行会产生大量填充的操作，内存仍可能迅速增加。

fullBytesEstimate = numel(D2) * 8;
fprintf("A full double D2 would need about %.1f KiB before overhead.\n", ...
    fullBytesEstimate/1024);

%% 7. 常见错误 / Common mistakes
%
% 错误 1：用 inv(A)*b 解线性方程。
% 改进：用 A\b。
%
% 错误 2：把元素乘法和矩阵乘法混用。
% A*B 是矩阵乘法，A.*B 是对应元素相乘。
%
% 错误 3：没有检查矩阵条件数。
% 条件数很大时，小误差可能被放大。

conditionNumber = cond(A);
fprintf("Condition number of A: %.3f\n", conditionNumber);

%% 8. 练习
%
% 练习 1：构造矩阵 A2 = [4 1; 2 3] 和 b2 = [1; 2]，求解 A2*x=b2。
% 练习 2：检查残差 norm(A2*x-b2) 是否小于 1e-12。
% 练习 3：计算 A2 的特征值。
% 练习 4：构造一个 5x5 随机矩阵，计算 SVD。
% 练习 5：生成 n=51 的二阶导数矩阵，查看 nnz。
% 练习 6：用 spy 观察矩阵非零元素位置。
% 练习 7：解释为什么 PDE 离散矩阵常适合用 sparse。

%% 9. 参考答案

A2 = [4 1; 2 3];
b2 = [1; 2];
x2 = A2 \ b2;
assert(norm(A2*x2 - b2) < 1e-12);

eigA2 = eig(A2);
disp(eigA2);

rng(9);
M = randn(5, 5);
[U2, S2, V2] = svd(M);
assert(norm(U2*S2*V2' - M) < 1e-12);

n2 = 51;
x2grid = linspace(0, 1, n2).';
dx2 = x2grid(2) - x2grid(1);
D2_small = fusionlearn.math.makeSecondDerivativeMatrix(n2, dx2, "interior");
fprintf("Small D2 nonzero entries: %d\n", nnz(D2_small));
assert(issparse(D2_small));

figure("Color", "w");
spy(D2_small);
title("Small second-derivative matrix");

%% 10. 小测验 / Mini quiz
%
% 选择题 1：解 A*x=b 推荐使用：
% A. A\b
% B. inv(A)*b 作为默认做法
% C. plot(A,b)
% 答案：A
%
% 选择题 2：查看矩阵非零结构常用：
% A. spy
% B. xlabel
% C. readtable
% 答案：A
%
% 选择题 3：特征值函数是：
% A. eig
% B. fft
% C. mkdir
% 答案：A
%
% 选择题 4：SVD 在 MATLAB 中常用：
% A. svd
% B. ode45
% C. contourf
% 答案：A
%
% 选择题 5：PDE 离散矩阵常常：
% A. 大而稀疏
% B. 只能是 2x2
% C. 不能存储
% 答案：A

%% 11. 错题案例 / Debug the mistake
%
% 错题 1：误把向量逐元素平方写成矩阵平方。

v = (1:5).';
v_squared = v.^2;
assert(isequal(v_squared, [1; 4; 9; 16; 25]));
%
% 错题 2：不看残差就相信结果。

candidate = A \ b;
residual = norm(A*candidate - b);
assert(residual < 1e-12);

%% 12. 本章检查表
%
% [ ] 我能用 A\b 解线性方程。
% [ ] 我知道为什么不默认使用 inv(A)*b。
% [ ] 我能计算特征值和 SVD。
% [ ] 我能构造一个二阶导数矩阵。
% [ ] 我知道 sparse 矩阵为什么重要。
