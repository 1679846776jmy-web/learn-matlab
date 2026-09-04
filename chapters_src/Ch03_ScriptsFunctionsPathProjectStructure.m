%% Ch03 脚本、函数、路径与工程化组织
% 本章目标 / Learning objectives
%
% 1. 知道什么时候写脚本，什么时候写函数。
% 2. 学会使用学习库中的 +fusionlearn package。
% 3. 理解路径配置和真实数据路径分离。
%
% Key terms:
% script, function, input argument, output argument, package, path, configuration

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
    addpath(fullfile(learningRoot, "data", "external_paths"));
end

%% 1. 脚本和函数的区别
% Script：直接运行，变量出现在当前工作区。
% Function：有输入输出，内部变量默认不泄露到外部。
%
% 工程化的第一步：把重复出现的代码封装成函数。

demo = fusionlearn.io.makeDemoSignal("DurationMs", 10, "SampleRateHz", 50000);
fprintf("Signal points: %d\n", numel(demo.signal));

%% 2. MATLAB package folder
% functions/+fusionlearn 下面的函数通过 fusionlearn.xxx.yyy 调用。
%
% 好处：
% 1. 函数名不容易和别人的函数冲突。
% 2. 目录结构更像真正的科研代码库。
% 3. 以后可以按 io、plot、math、efit、dbs 分类扩展。

fig = fusionlearn.plot.plotSignalOverview( ...
    demo.time_ms, demo.signal, ...
    "TimeUnit", "ms", ...
    "SignalName", "demo signal", ...
    "SignalUnit", "a.u.");

%% 3. 数据路径配置
% 真实数据路径不应该写死在每个脚本里。
% 本学习库提供 data_paths_template.m，后续可复制为 data_paths_local.m。
% 公开仓库只保存模板；本地真实路径保存在被 Git 忽略的 data_paths_local.m。

[paths, pathSource] = fusionlearn.io.getExternalDataPaths();
fprintf("External path source: %s\n", pathSource);
disp(paths);

fusionlearn.utils.checkPathExists(paths.efitRawDir, "EFIT raw directory");
fusionlearn.utils.checkPathExists(paths.efitMatDir, "EFIT MAT directory");
fusionlearn.utils.checkPathExists(paths.dbsMatFile, "DBS MAT file");

%% 4. 最小工程化流程
% 一个更干净的科研脚本通常长这样：
%
% 1. 初始化路径。
% 2. 读取配置。
% 3. 读取或生成数据。
% 4. 调用函数处理数据。
% 5. 调用函数绘图。
% 6. 保存结果。
% 7. 用 assert 做最小检查。

processed = demo.signal - mean(demo.signal);
assert(abs(mean(processed)) < 1e-12);

figure("Color", "w");
plot(demo.time_ms, processed, "LineWidth", 1.0);
xlabel("Time (ms)");
ylabel("Detrended signal (a.u.)");
title("Processed signal");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 5. 常见错误 / Common mistakes
%
% 错误 1：一个脚本写几百行，所有任务混在一起。
% 改进：把读数据、处理、绘图拆成函数。
%
% 错误 2：在函数内部写死某台电脑上的真实数据路径。
% 改进：用配置函数传入路径。
%
% 错误 3：函数名太随意，例如 aaa、test2、newnew。
% 改进：用清楚的动词和对象，例如 loadSignalData、plotFluxSurfaces。

%% 6. 练习
%
% 练习 1：调用 makeDemoSignal 生成 5 ms 信号。
% 练习 2：把信号去均值。
% 练习 3：用 plotSignalOverview 画图。
% 练习 4：用 assert 检查去均值后的平均值接近 0。
% 练习 5：查看 getExternalDataPaths 的输出。
% 练习 6：解释为什么真实数据路径不应该散落在各个脚本中。

%% 7. 参考答案

demo_ex = fusionlearn.io.makeDemoSignal("DurationMs", 5, "SampleRateHz", 20000);
signal_zero_mean = demo_ex.signal - mean(demo_ex.signal);

fusionlearn.plot.plotSignalOverview( ...
    demo_ex.time_ms, signal_zero_mean, ...
    "TimeUnit", "ms", ...
    "SignalName", "zero-mean signal", ...
    "SignalUnit", "a.u.");

assert(abs(mean(signal_zero_mean)) < 1e-12);

[paths_ex, pathSource_ex] = fusionlearn.io.getExternalDataPaths();
fprintf("External path source: %s\n", pathSource_ex);
disp(paths_ex);

%% 8. 本章检查表
%
% [ ] 我知道脚本和函数的区别。
% [ ] 我能调用 fusionlearn.io.makeDemoSignal。
% [ ] 我知道 +fusionlearn 是 package folder。
% [ ] 我能用配置函数集中管理路径。
% [ ] 我能写一个 assert 检查结果。
