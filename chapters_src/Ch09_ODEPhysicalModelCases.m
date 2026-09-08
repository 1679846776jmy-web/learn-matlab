%% Ch09 ODE 求解与物理模型案例
% 本章目标 / Learning objectives
%
% 1. 理解常微分方程 ODE 在物理建模中的含义。
% 2. 掌握 ode45、ode15s、odeset 和函数句柄的基础用法。
% 3. 会把参数放进 struct，并传给 ODE 右端函数。
% 4. 用一个零维等离子体玩具模型练习参数扫描和物理量检查。
%
% Key terms:
% ordinary differential equation, right-hand side, initial condition,
% time span, solver tolerance, parameter scan, zero-dimensional model

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. ODE 是什么
% ODE 描述“一个量如何随时间变化”。
%
% 例子：
%
% dT/dt = -T/tau
%
% 含义：温度 T 按时间常数 tau 指数衰减。
%
% 在 MATLAB 中，ODE 右端函数通常写成：
%
% dydt = f(t, y)

tau_s = 0.08;
coolingRhs = @(t, y) -y / tau_s;

tspan = [0 0.4];
y0 = 1.0;
[time_s, temperature] = ode45(coolingRhs, tspan, y0);

temperatureExact = y0 * exp(-time_s / tau_s);
maxCoolingError = max(abs(temperature - temperatureExact));
fprintf("Cooling model max error: %.3e\n", maxCoolingError);

figure("Color", "w");
plot(1e3*time_s, temperatureExact, "k-", "LineWidth", 1.3);
hold on;
plot(1e3*time_s, temperature, "ro", "MarkerSize", 4);
xlabel("Time (ms)");
ylabel("Normalized temperature");
title("ODE example: exponential cooling");
legend("Exact", "ode45", "Location", "best");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

assert(maxCoolingError < 1e-4);

%% 2. ode45 的四个关键输入
% ode45 最常见的调用方式：
%
% [t, y] = ode45(rhs, tspan, y0)
%
% 1. rhs：右端函数，输入 t 和 y，输出 dy/dt。
% 2. tspan：积分时间范围，例如 [0 0.2]。
% 3. y0：初始条件。
% 4. 可选 opts：由 odeset 设置误差容忍度、事件函数等。

opts = odeset("RelTol", 1e-6, "AbsTol", 1e-9);
[time_tight, temperature_tight] = ode45(coolingRhs, tspan, y0, opts);

fprintf("Default ode45 points: %d\n", numel(time_s));
fprintf("Tighter ode45 points: %d\n", numel(time_tight));
assert(abs(temperature_tight(end) - y0*exp(-time_tight(end)/tau_s)) < 1e-6);

%% 3. 多变量 ODE：状态向量
% 如果系统有多个变量，就把它们放进一个列向量。
%
% 本章的玩具模型使用：
%
% y(1) = n_e，单位是 10^20 m^-3
% y(2) = T_e，单位是 keV
%
% 这个模型只用于学习，不用于真实预测。真实等离子体模型会复杂得多。

params = struct();
params.nTarget20 = 0.8;
params.tauParticle_s = 0.08;
params.edgeTe_keV = 0.12;
params.heatingGain_keV = 2.4;
params.heatingRamp_s = 0.04;
params.tauEnergy_s = 0.05;
params.radiationCoeff_per_s = 0.18;
params.densityFloor20 = 0.05;

y0_plasma = [0.25; 0.18];
tspan_plasma = [0 0.25];
[time_plasma_s, state] = ode45( ...
    @(t, y) fusionlearn.plasma.toyZeroDPlasmaRhs(t, y, params), ...
    tspan_plasma, y0_plasma, opts);

n20 = state(:,1);
Te_keV = state(:,2);

assert(all(isfinite(state), "all"));
assert(n20(end) > n20(1));
assert(Te_keV(end) > Te_keV(1));

%% 4. 画出零维模型结果
% 一个 ODE 结果通常至少要画：
%
% 1. 每个状态量随时间的变化。
% 2. 初始值和最终值是否合理。
% 3. 不同参数下结果如何变化。

figure("Color", "w");
tiledlayout(2, 1);

nexttile;
plot(1e3*time_plasma_s, n20, "LineWidth", 1.3);
xlabel("Time (ms)");
ylabel("n_e (10^{20} m^{-3})");
title("Toy density evolution");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

nexttile;
plot(1e3*time_plasma_s, Te_keV, "LineWidth", 1.3);
xlabel("Time (ms)");
ylabel("T_e (keV)");
title("Toy temperature evolution");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 5. 参数扫描
% 参数扫描是把同一个模型在不同参数下跑多次。
% 初学时最重要的是每次只改一个参数，否则很难判断变化来自哪里。

heatingGainList = [1.4 2.4 3.4 4.4];
finalTe = zeros(size(heatingGainList));

figure("Color", "w");
hold on;
for k = 1:numel(heatingGainList)
    paramsScan = params;
    paramsScan.heatingGain_keV = heatingGainList(k);
    [tScan, stateScan] = ode45( ...
        @(t, y) fusionlearn.plasma.toyZeroDPlasmaRhs(t, y, paramsScan), ...
        tspan_plasma, y0_plasma, opts);
    finalTe(k) = stateScan(end, 2);
    plot(1e3*tScan, stateScan(:,2), "LineWidth", 1.2, ...
        "DisplayName", sprintf("gain = %.1f keV", heatingGainList(k)));
end
xlabel("Time (ms)");
ylabel("T_e (keV)");
title("Heating-gain scan");
legend("show", "Location", "best");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

assert(all(diff(finalTe) > 0));

%% 6. ode15s 的位置
% ode45 适合很多非刚性问题。
% ode15s 常用于刚性问题，也就是系统里同时存在很快和很慢的时间尺度。
%
% 对同一个温和的玩具模型，ode45 和 ode15s 的最终结果应该接近。

[time_15s, state_15s] = ode15s( ...
    @(t, y) fusionlearn.plasma.toyZeroDPlasmaRhs(t, y, params), ...
    tspan_plasma, y0_plasma, opts);

finalDifference = norm(state_15s(end,:) - state(end,:));
fprintf("Final state difference between ode45 and ode15s: %.3e\n", finalDifference);
assert(finalDifference < 1e-3);

%% 7. 常见错误 / Common mistakes
%
% 错误 1：右端函数输出行向量。
% 改进：保持 y 和 dydt 都是列向量。
%
% 错误 2：忘记单位。ms 和 s 混用会让时间尺度差 1000 倍。
%
% 错误 3：把参数写散在很多行里。
% 改进：用 params struct 集中管理参数。
%
% 错误 4：不检查结果是否为 finite。
% ODE 出现 NaN 或 Inf 时，先检查除零、开方和指数项。

%% 8. 练习
%
% 练习 1：把冷却模型的 tau_s 从 0.08 改成 0.16，观察衰减变慢还是变快。
% 练习 2：把 tspan 改成 [0 0.8]，观察最终温度。
% 练习 3：把 y0_plasma 的初始密度改成 0.6，观察密度演化。
% 练习 4：把 heatingGainList 增加到 5 个值。
% 练习 5：用 plot 画 finalTe 随 heatingGainList 的变化。
% 练习 6：用一句英文解释 initial condition 的含义。
% 练习 7：故意删掉 params.tauEnergy_s，观察函数报错。

%% 9. 参考答案

tau_s_answer = 0.16;
coolingRhs_answer = @(t, y) -y / tau_s_answer;
[time_answer_s, temp_answer] = ode45(coolingRhs_answer, [0 0.8], 1.0);
assert(temp_answer(end) < temp_answer(1));
assert(temp_answer(end) > 0);

y0_changed = [0.6; 0.18];
[~, state_changed] = ode45( ...
    @(t, y) fusionlearn.plasma.toyZeroDPlasmaRhs(t, y, params), ...
    tspan_plasma, y0_changed, opts);
assert(state_changed(end,1) > state_changed(1,1));

heatingGainAnswer = [1.4 2.4 3.4 4.4 5.4];
finalTeAnswer = zeros(size(heatingGainAnswer));
for k = 1:numel(heatingGainAnswer)
    paramsAnswer = params;
    paramsAnswer.heatingGain_keV = heatingGainAnswer(k);
    [~, stateAnswer] = ode45( ...
        @(t, y) fusionlearn.plasma.toyZeroDPlasmaRhs(t, y, paramsAnswer), ...
        tspan_plasma, y0_plasma, opts);
    finalTeAnswer(k) = stateAnswer(end, 2);
end

figure("Color", "w");
plot(heatingGainAnswer, finalTeAnswer, "o-", "LineWidth", 1.3);
xlabel("Heating gain (keV)");
ylabel("Final T_e (keV)");
title("Final temperature from parameter scan");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

fprintf("The initial condition is the model state at the starting time.\n");

%% 10. 小测验 / Mini quiz
%
% 选择题 1：ode45 的右端函数通常输出什么？
% A. dy/dt
% B. 图像标题
% C. 文件路径
% 答案：A
%
% 选择题 2：y0 表示什么？
% A. 初始条件
% B. 最终答案
% C. 图例位置
% 答案：A
%
% 选择题 3：把参数集中放进 struct 的好处是：
% A. 参数更容易管理和扫描
% B. 图一定更漂亮
% C. 可以不用检查单位
% 答案：A
%
% 选择题 4：ode15s 常用于：
% A. 刚性 ODE
% B. 读取 CSV
% C. 画等值线
% 答案：A
%
% 选择题 5：ODE 结果出现 NaN，优先检查：
% A. 除零、非法开方、指数溢出和参数单位
% B. 文件名是否足够长
% C. 图窗背景色
% 答案：A

%% 11. 错题案例 / Debug the mistake
%
% 错题 1：右端函数返回行向量。
%
% 错误写法：
% badRhs = @(t, y) [-y(1), -2*y(2)];
%
% 正确写法：
goodRhs = @(t, y) [-y(1); -2*y(2)];
[~, goodState] = ode45(goodRhs, [0 1], [1; 1]);
assert(size(goodState, 2) == 2);
%
% 错题 2：把毫秒当成秒。
% 如果物理时间是 250 ms，应写成 0.250 s，而不是 250 s。

duration_ms = 250;
duration_s = duration_ms / 1000;
assert(abs(duration_s - 0.25) < 1e-12);

%% 12. 本章检查表
%
% [ ] 我能写出 dydt = f(t,y) 形式的右端函数。
% [ ] 我能用 ode45 求解一阶 ODE。
% [ ] 我能把多个状态量放进一个列向量。
% [ ] 我能用 params struct 管理模型参数。
% [ ] 我能做一个简单参数扫描并画图。
