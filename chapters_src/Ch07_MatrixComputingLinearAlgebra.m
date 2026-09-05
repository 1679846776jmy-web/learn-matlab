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

%% 2. 不推荐显式求逆
% 初学时常写 inv(A)*b，但数值计算中更推荐 A\b。

x_backslash = A \ b;
x_inverse = inv(A) * b;

fprintf("Difference between two solutions: %.3e\n", norm(x_backslash - x_inverse));
%
% English sentence:
% The backslash operator is preferred for solving linear systems.

%% 3. 特征值和特征向量
% 特征值问题 A*v = lambda*v 常用于模态、稳定性和振荡问题。

[V, D] = eig(A);
eigenvalues = diag(D);

disp("Eigenvalues:");
disp(eigenvalues);

firstResidual = norm(A*V(:,1) - eigenvalues(1)*V(:,1));
assert(firstResidual < 1e-12);

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

%% 6. 稀疏矩阵
% PDE 离散后经常得到很大的矩阵，但很多元素是 0。
% sparse matrix 可以节省内存和计算时间。

fprintf("D2 is sparse: %d\n", issparse(D2));
fprintf("Number of nonzero entries: %d\n", nnz(D2));

figure("Color", "w");
spy(D2);
title("Sparsity pattern of D2");

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

