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

%% 9. 加厚练习 / Extra exercises
%
% 练习 A：用 which 找到 makeDemoSignal 函数。
% 练习 B：用 exist 判断 data_paths_local 是否存在。
% 练习 C：写一个临时结构体 config，包含 shot、timeStart_ms、timeEnd_ms。
% 练习 D：用 assert 检查 timeEnd_ms 大于 timeStart_ms。
% 练习 E：把一个长表达式拆成中间变量，让代码更容易读。

disp(which("fusionlearn.io.makeDemoSignal"));
hasLocalPaths = exist("data_paths_local", "file") == 2;
fprintf("Has local private paths: %d\n", hasLocalPaths);

config = struct();
config.shot = 0;
config.timeStart_ms = 5;
config.timeEnd_ms = 10;
assert(config.timeEnd_ms > config.timeStart_ms);

rawSignal = demo_ex.signal;
rawMean = mean(rawSignal);
signalNoMean = rawSignal - rawMean;
signalRms = sqrt(mean(signalNoMean.^2));
fprintf("Signal RMS = %.3f\n", signalRms);

%% 10. 小测验 / Mini quiz
%
% 选择题 1：重复使用的代码更适合放在哪里？
% A. 函数
% B. Figure 标题
% C. 命令历史
% 答案：A
%
% 选择题 2：`+fusionlearn` 文件夹表示：
% A. MATLAB package folder
% B. 自动备份目录
% C. 图片文件夹
% 答案：A
%
% 选择题 3：本机私有路径应该放在：
% A. data_paths_local.m
% B. 每个脚本最开头
% C. README 标题里
% 答案：A
%
% 选择题 4：`assert` 的主要作用是：
% A. 检查程序结果是否满足条件
% B. 自动画三维图
% C. 上传 GitHub
% 答案：A
%
% 选择题 5：函数内部变量默认：
% A. 不会泄露到外部工作区
% B. 自动保存到所有脚本
% C. 只能是整数
% 答案：A

%% 11. 错题案例 / Debug the mistake
%
% 错题 1：函数名和脚本名随意，后续自己也找不到。
%
% 不推荐：
% test1.m, newnew.m, aaa.m
%
% 推荐：
% loadSignalData.m, plotSignalOverview.m, computePowerSpectrum.m
%
% 错题 2：把配置、计算、绘图全部写在一个超长脚本中。
% 一个更好的主脚本结构如下：

exampleConfig = struct("duration_ms", 5, "sampleRate_Hz", 20000);
exampleData = fusionlearn.io.makeDemoSignal( ...
    "DurationMs", exampleConfig.duration_ms, ...
    "SampleRateHz", exampleConfig.sampleRate_Hz);
exampleProcessed = exampleData.signal - mean(exampleData.signal);
assert(numel(exampleProcessed) == numel(exampleData.signal));
