%% Ch02 变量、数组、索引与基础语法
% 本章目标 / Learning objectives
%
% 1. 掌握 MATLAB 的数组思维。
% 2. 会创建向量、矩阵、结构体和逻辑索引。
% 3. 理解元素运算和矩阵运算的区别。
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

%% 2. 元素运算
% MATLAB 中最容易踩坑的是点运算：
%
% y = x.^2 表示每个元素平方。
% A^2 表示矩阵乘法意义下的平方，要求 A 是方阵。

x = linspace(0, 1, 6);
y_element = x.^2;

disp(table(x.', y_element.', 'VariableNames', ["x", "x_squared"]));

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
