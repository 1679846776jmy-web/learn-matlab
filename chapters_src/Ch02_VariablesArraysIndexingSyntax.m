%% Ch02 变量、数组、索引与基础语法
% 本章目标 / Learning objectives
%
% 1. 掌握 MATLAB 的数组思维。
% 2. 会创建向量、矩阵、结构体和逻辑索引。
% 3. 理解元素运算和矩阵运算的区别。
% 4. 分清点号在小数、逐元素运算、转置、字段访问和 package 中的不同含义。
% 5. 会读写 if、for 和 while，并知道什么时候使用 &、|、&&、||。
%
% Key terms:
% variable, vector, matrix, array, index, logical indexing, element-wise operation

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. 标量、向量和矩阵

shot = 13653;
time_ms = linspace(0, 2800, 2801).';
profile_rho = linspace(0, 1, 51).';

temperature_keV = 2.0 * (1 - profile_rho.^2) + 0.2;
density_1e19m3 = 4.0 * (1 - 0.6*profile_rho.^2) + 0.3;

disp(size(time_ms));
disp(size(profile_rho));

%% 1.1 数组思维到底是什么
% MATLAB 的名字来自 MATrix LABoratory。它把标量看成 1x1 数组，把一串采样点
% 看成向量，把多通道或二维网格数据看成矩阵。很多函数一次接收整个数组，因此在
% 写循环之前，应先问：“这个公式能否同时作用到所有采样点？”
%
% 行向量尺寸是 1xN，列向量尺寸是 Nx1。它们拥有相同数量的元素，却不是同一形状。
% 两个变量要逐元素计算时，不只要看 numel，还要看 size 和每个维度的物理含义。
%
% 常用创建方法：冒号适合固定步长，linspace 适合固定点数，zeros/ones/nan 适合
% 预先建立已知尺寸的数组。末尾的 `.'` 把行向量转成列向量。

fixedStep = (0:0.25:1).';
fixedCount = linspace(0, 1, 5).';
emptyProfile = nan(size(profile_rho));

disp(table(fixedStep, fixedCount));
fprintf("Preallocated profile has size %d x %d.\n", size(emptyProfile));

%% 2. 元素运算
% MATLAB 中最容易踩坑的是点运算：
%
% y = x.^2 表示每个元素平方。
% A^2 表示矩阵乘法意义下的平方，要求 A 是方阵。

x = linspace(0, 1, 6);
y_element = x.^2;

disp(table(x.', y_element.', 'VariableNames', ["x", "x_squared"]));

%% 2.1 点号语法详解：同一个符号，五种常见身份
% 第一种：小数点。`3.14` 是一个数，点号属于数字的一部分。
%
% 第二种：逐元素运算符。`.*`、`./`、`.^` 让相同位置的元素分别进行乘、除、乘方。
% 例如 `x.^2` 表示 x 中每个元素平方。相比之下，`A^2` 表示 A*A，只适用于满足
% 矩阵乘法条件的方阵。
%
% 第三种：`.'` 是非共轭转置，只交换行列。单独的 `'` 是共轭转置；当数组包含复数
% 时，它还会改变虚部符号。实数数组里两者结果看起来相同，所以这个区别容易被忽略。
%
% 第四种：字段或属性访问。`signalData.time_ms` 表示从结构体 signalData 取出
% time_ms 字段；table、timetable 和对象也常用点号访问变量或属性。
%
% 第五种：package 限定名。`fusionlearn.io.makeDemoSignal` 中的点号表示层级：
% fusionlearn package -> io 子 package -> makeDemoSignal 函数。
%
% 判断方法不是“看到点号就背答案”，而是看点号旁边是什么：数字、运算符、转置符，
% 还是变量名/函数名。

A_demo = [1 2; 3 4];
B_demo = [10 20; 30 40];
elementMultiply = A_demo .* B_demo;
matrixMultiply = A_demo * B_demo;

complexRow = [1+2i, 3-4i];
plainTranspose = complexRow.';
hermitianTranspose = complexRow';

dotDemo = struct();
dotDemo.elementMultiply = elementMultiply;
dotDemo.matrixMultiply = matrixMultiply;

disp(dotDemo.elementMultiply);
disp(plainTranspose);
disp(hermitianTranspose);

%% 3. 逻辑索引选取时间窗
% 聚变数据处理中经常需要截取某个时间窗，例如 1000-1500 ms。

demo = fusionlearn.io.makeDemoSignal("DurationMs", 20, "SampleRateHz", 100000);
timeWindow = demo.time_ms >= 5 & demo.time_ms <= 10;

time_cut = demo.time_ms(timeWindow);
signal_cut = demo.signal(timeWindow);

figure("Color", "w");
plot(demo.time_ms, demo.signal, "Color", [0.7 0.7 0.7]);
hold on;
plot(time_cut, signal_cut, "r", "LineWidth", 1.2);
xlabel("Time (ms)");
ylabel("Signal (a.u.)");
title("Logical indexing for a time window");
legend("Full signal", "Selected window");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 4. 循环与向量化
% 初学时可以先写循环，理解后再学向量化。

n = 8;
square_loop = zeros(1, n);
for k = 1:n
    square_loop(k) = k^2;
end

k_array = 1:n;
square_vector = k_array.^2;

disp(square_loop);
disp(square_vector);
assert(isequal(square_loop, square_vector));

%% 5. 结构体保存一组相关数据
% 结构体适合保存一个诊断信号、一组物理量或一个平衡时间片。

signalData = struct();
signalData.shot = shot;
signalData.time_ms = demo.time_ms;
signalData.signal = demo.signal;
signalData.sampleRate_Hz = demo.sampleRate_Hz;
signalData.description = "Synthetic diagnostic signal";

disp(signalData);

%% 5.1 if、for、while 和逻辑运算符
% `if` 根据一个标量逻辑条件选择分支；`for` 对已知的一组索引逐个执行；`while`
% 在条件仍为 true 时继续执行。while 循环必须确保条件最终能变成 false，否则会无限运行。
%
% `&` 和 `|` 对数组逐元素进行与/或运算，适合构造逻辑掩码。`&&` 和 `||` 用于
% 标量条件并具有短路特性：如果左侧已经能决定结果，右侧就不再计算。if 条件中常用
% `&&`、`||`，筛选整条时间轴时常用 `&`、`|`。
%
% 复杂条件建议加括号，明确先后顺序。不要依赖记忆运算符优先级来表达物理条件。

peakValue = max(signal_cut);
hasEnoughSamples = numel(signal_cut) >= 10;
if hasEnoughSamples && isfinite(peakValue)
    qualityMessage = "Window is ready for a basic calculation.";
elseif ~hasEnoughSamples
    qualityMessage = "Window is too short.";
else
    qualityMessage = "Window contains a non-finite peak.";
end
disp(qualityMessage);

countdown = 3;
while countdown > 0
    fprintf("while example: %d\n", countdown);
    countdown = countdown - 1;
end

%% 5.2 冒号、end 和索引的读法
% MATLAB 索引从 1 开始。`A(row, column)` 的第一个下标是行，第二个是列。
% 冒号 `:` 在索引位置表示“这一维全部取出”；`end` 表示该维最后一个位置。
%
% `A(:,2)` 取第 2 列，`A(2,:)` 取第 2 行，`A(1:2:end,:)` 隔一行取样。
% 线性索引 `A(k)` 会按列优先顺序访问矩阵元素。它很方便，但二维物理含义可能被隐藏，
% 初学时处理 R-Z 网格应优先写清楚行、列两个下标。

indexMatrix = reshape(1:12, 3, 4);
secondColumn = indexMatrix(:, 2);
lastRow = indexMatrix(end, :);
oddRows = indexMatrix(1:2:end, :);

disp(indexMatrix);
disp(secondColumn);
disp(lastRow);
disp(oddRows);

%% 6. 常见错误 / Common mistakes
%
% 错误 1：写 y = x^2，而 x 是向量。
% 正确：y = x.^2。
%
% 错误 2：用 time_ms > 5 < 10。
% 正确：time_ms > 5 & time_ms < 10。
%
% 错误 3：忘记预分配数组。
% 小脚本问题不大，大循环会明显变慢。

%% 7. 练习
%
% 练习 1：创建 0 到 100 ms、步长 0.01 ms 的时间数组。
% 练习 2：生成一个 20 kHz 的正弦信号，注意单位换算。
% 练习 3：截取 30-40 ms 的时间窗。
% 练习 4：用循环和向量化分别计算 1 到 100 的立方。
% 练习 5：把时间、信号、采样率保存进结构体。
% 练习 6：故意把 .^ 改成 ^，观察报错。
% 练习 7：构造一个复数行向量，比较 `'` 和 `.'`。
% 练习 8：分别解释 `2.5`、`x.^2`、`data.signal` 和 `fusionlearn.io.makeDemoSignal` 中的点号。
% 练习 9：用 if/elseif/else 把温度分成 low、medium、high 三类。

%% 8. 参考答案

time_ms_ex = (0:0.01:100).';
frequency_Hz = 20000;
signal_ex = sin(2*pi*frequency_Hz*(time_ms_ex/1000));

mask_ex = time_ms_ex >= 30 & time_ms_ex <= 40;
time_30_40 = time_ms_ex(mask_ex);
signal_30_40 = signal_ex(mask_ex);

cube_loop = zeros(1, 100);
for k = 1:100
    cube_loop(k) = k^3;
end
cube_vector = (1:100).^3;

answerData = struct();
answerData.time_ms = time_ms_ex;
answerData.signal = signal_ex;
answerData.sampleRate_Hz = 1/(0.01e-3);

assert(numel(time_30_40) == numel(signal_30_40));
assert(isequal(cube_loop, cube_vector));
assert(abs(answerData.sampleRate_Hz - 100000) < 1e-9);

%% 9. 本章检查表
%
% [ ] 我能解释行向量和列向量的区别。
% [ ] 我能使用逻辑索引截取时间窗。
% [ ] 我知道 .*, ./, .^ 的作用。
% [ ] 我能写一个 for 循环。
% [ ] 我能用结构体保存一组信号数据。

%% 10. 加厚练习 / Extra exercises
%
% 练习 A：生成列向量 rho = 0 到 1，共 101 个点。
% 练习 B：构造 density = 5*(1-rho.^2)+0.2。
% 练习 C：找出 density > 3 的所有位置。
% 练习 D：用 if 判断最大 density 是否大于 5。
% 练习 E：把 rho 和 density 放进 table。
% 练习 F：用 mean 和 std 计算 signal_cut 的平均值和标准差。

rho_extra = linspace(0, 1, 101).';
density_extra = 5*(1 - rho_extra.^2) + 0.2;
coreMask = density_extra > 3;

if max(density_extra) > 5
    disp("Peak density is above 5 in normalized units.");
else
    disp("Peak density is not above 5 in normalized units.");
end

profileTable = table(rho_extra, density_extra, coreMask);
disp(profileTable(1:5, :));

signalMean = mean(signal_cut);
signalStd = std(signal_cut);
fprintf("Selected signal mean = %.3f, std = %.3f\n", signalMean, signalStd);

%% 11. 小测验 / Mini quiz
%
% 选择题 1：对向量逐元素平方应该写：
% A. x.^2
% B. x^2
% C. x**2
% 答案：A
%
% 选择题 6：复数向量只交换行列、不做共轭，应使用：
% A. .'
% B. '
% C. .^
% 答案：A
%
% 选择题 7：访问结构体字段 time_ms 应写：
% A. data.time_ms
% B. data.*time_ms
% C. data/time_ms
% 答案：A
%
% 选择题 2：选取 5 到 10 ms 的时间窗应该写：
% A. time_ms >= 5 & time_ms <= 10
% B. time_ms >= 5 && time_ms <= 10
% C. 5 <= time_ms <= 10
% 答案：A
%
% 选择题 3：查看数组尺寸应该用：
% A. size
% B. title
% C. clear
% 答案：A
%
% 选择题 4：结构体适合保存：
% A. 一组有关系的数据和元信息
% B. MATLAB 工具箱许可证
% C. 只能保存一个数字
% 答案：A
%
% 选择题 5：`A\b` 常用于：
% A. 解线性方程 A*x=b
% B. 画图
% C. 清空变量
% 答案：A

%% 12. 错题案例 / Debug the mistake
%
% 错题 1：逻辑条件写法错误。
%
% 错误写法：
% badMask = 5 <= demo.time_ms <= 10;
%
% 正确写法：
goodMask = demo.time_ms >= 5 & demo.time_ms <= 10;
assert(any(goodMask));
assert(all(demo.time_ms(goodMask) >= 5 & demo.time_ms(goodMask) <= 10));
%
% 错题 2：行列方向混乱。

rowVector = 1:5;
columnVector = (1:5).';
assert(isequal(size(rowVector), [1 5]));
assert(isequal(size(columnVector), [5 1]));

% 错题 3：认为所有点号都表示逐元素运算。
% 更正：只有 `.*`、`./`、`.^` 是相应的逐元素运算；小数点、`.'`、字段访问和
% package 限定名中的点号各有自己的语法含义。

% 错题 4：在 if 中直接放入一整条逻辑数组，却没有说明要 all 还是 any。
% 更正：先决定含义。要求所有元素满足用 all(mask)，至少一个满足用 any(mask)。
