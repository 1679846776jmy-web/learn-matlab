%% Ch06 数据读写与外部数据路径配置
% 本章目标 / Learning objectives
%
% 1. 掌握 MAT、CSV、TXT 的基础读写。
% 2. 学会先检查文件信息，再加载变量。
% 3. 理解真实 EFIT 和 DBS 数据的安全接入方式。
%
% Key terms:
% MAT file, CSV file, text file, external path, large file, whos -file, matfile

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
    addpath(fullfile(learningRoot, "data", "external_paths"));
end

%% 1. 生成并保存一个小型模拟数据

demo = fusionlearn.io.makeDemoSignal("DurationMs", 10, "SampleRateHz", 50000);
simulatedDir = fullfile(learningRoot, "data", "simulated");
if ~isfolder(simulatedDir)
    mkdir(simulatedDir);
end

matFile = fullfile(simulatedDir, "demo_signal_phase1.mat");
save(matFile, "demo");
fprintf("Saved demo MAT file: %s\n", matFile);

%% 2. 不加载全部数据，先检查 MAT 文件

info = fusionlearn.io.checkMatFileInfo(matFile);
assert(any(strcmp({info.name}, "demo")));

loadedDemo = fusionlearn.io.loadMatVariable(matFile, "demo");
assert(numel(loadedDemo.time_ms) == numel(loadedDemo.signal));

%% 3. 保存和读取 CSV

csvTable = table( ...
    loadedDemo.time_ms(1:20), ...
    loadedDemo.signal(1:20), ...
    'VariableNames', ["time_ms", "signal"]);

csvFile = fullfile(simulatedDir, "demo_signal_first20.csv");
writetable(csvTable, csvFile);

readBackTable = readtable(csvFile);
disp(readBackTable(1:5, :));

%% 4. 保存和读取 TXT

txtFile = fullfile(simulatedDir, "demo_notes.txt");
notes = [
    "This is a small synthetic signal."
    "It is safe to store inside the learning library."
    "Large experimental data should stay outside this folder."
];
writelines(notes, txtFile);

readBackLines = readlines(txtFile);
disp(readBackLines);

%% 5. 外部真实数据路径
% 真实实验数据不随公开仓库发布。你可以在本机创建被 Git 忽略的
% data/external_paths/data_paths_local.m，填写自己的 EFIT 和 DBS 路径。
%
% EFIT raw gfile directory:
% <your external EFIT raw gfile directory>
%
% EFIT processed MAT directory:
% <your external EFIT processed MAT directory>
%
% DBS MAT file:
% <your external DBS MAT file>

[paths, pathSource] = fusionlearn.io.getExternalDataPaths();
fprintf("External path source: %s\n", pathSource);

hasEfitRaw = fusionlearn.utils.checkPathExists(paths.efitRawDir, "EFIT raw directory");
hasEfitMat = fusionlearn.utils.checkPathExists(paths.efitMatDir, "EFIT MAT directory");
hasDbsMat = fusionlearn.utils.checkPathExists(paths.dbsMatFile, "DBS MAT file");

%% 6. 大 MAT 文件的安全检查方式
% DBS 文件通常可能很大，初学阶段不要直接 load 整个文件。
% 先使用 whos -file 查看变量，再决定读取哪个变量、哪个时间窗。

if hasDbsMat
    fprintf("Inspecting DBS MAT file without loading all data...\n");
    dbsInfo = fusionlearn.io.checkMatFileInfo(paths.dbsMatFile);
    disp(struct2table(dbsInfo));
else
    fprintf("DBS MAT file is not available on this machine.\n");
end

%% 7. 常见错误 / Common mistakes
%
% 错误 1：直接 load 一个几百 MB 或几 GB 的 MAT 文件。
% 改进：先 whos -file，再用 matfile 或只加载需要的变量。
%
% 错误 2：处理脚本里到处写真实数据路径。
% 改进：集中写在 data_paths_local.m 或 data_paths_template.m。
%
% 错误 3：读入数据后不检查尺寸。
% 改进：马上使用 size、numel、class、min、max。

%% 8. 练习
%
% 练习 1：保存一个包含 time_ms 和 signal 的 MAT 文件。
% 练习 2：用 whos -file 检查该文件。
% 练习 3：只读取其中一个变量。
% 练习 4：把前 100 个数据点写成 CSV。
% 练习 5：用 readtable 读回 CSV。
% 练习 6：检查 EFIT 路径是否存在。
% 练习 7：如果 DBS 文件存在，只查看变量信息，不直接 load。

%% 9. 参考答案

answerData = fusionlearn.io.makeDemoSignal("DurationMs", 5, "SampleRateHz", 20000);
answerMat = fullfile(simulatedDir, "answer_signal.mat");
save(answerMat, "answerData");

answerInfo = whos("-file", answerMat);
disp(struct2table(answerInfo));

answerLoaded = fusionlearn.io.loadMatVariable(answerMat, "answerData");
answerCsv = fullfile(simulatedDir, "answer_signal_first100.csv");
answerTable = table(answerLoaded.time_ms(1:100), answerLoaded.signal(1:100), ...
    'VariableNames', ["time_ms", "signal"]);
writetable(answerTable, answerCsv);

answerReadBack = readtable(answerCsv);
assert(height(answerReadBack) == 100);

fusionlearn.utils.checkPathExists(paths.efitMatDir, "EFIT MAT directory");
if hasDbsMat
    dbsAnswerInfo = whos("-file", paths.dbsMatFile);
    fprintf("DBS variables inspected safely: %d\n", numel(dbsAnswerInfo));
end

%% 10. 本章检查表
%
% [ ] 我能保存和读取 MAT 文件。
% [ ] 我能保存和读取 CSV 文件。
% [ ] 我能保存和读取 TXT 文件。
% [ ] 我知道 whos -file 的作用。
% [ ] 我知道为什么不能随便 load 大 DBS 文件。

%% 11. 加厚练习 / Extra exercises
%
% 练习 A：用 whos -file 查看 demo_signal_phase1.mat。
% 练习 B：用 isfile 检查 CSV 文件是否存在。
% 练习 C：用 height 查看 readBackTable 的行数。
% 练习 D：用 contains 找出 DBS 变量名中包含 "I_" 的变量。
% 练习 E：如果没有本地真实数据路径，解释为什么示例仍能继续学习。

info_extra = whos("-file", matFile);
assert(any(strcmp({info_extra.name}, "demo")));
assert(isfile(csvFile));
fprintf("CSV rows: %d\n", height(readBackTable));

if exist("dbsInfo", "var")
    dbsNames = string({dbsInfo.name});
    iSignalNames = dbsNames(startsWith(dbsNames, "I_"));
    fprintf("Detected I-channel variables: %d\n", numel(iSignalNames));
else
    fprintf("No local DBS info available; simulated data remains enough for this chapter.\n");
end

%% 12. 小测验 / Mini quiz
%
% 选择题 1：检查 MAT 文件变量但不加载全部数据，应使用：
% A. whos -file
% B. close all
% C. title
% 答案：A
%
% 选择题 2：读取 CSV 表格常用：
% A. readtable
% B. contour
% C. eig
% 答案：A
%
% 选择题 3：大 MAT 文件推荐优先尝试：
% A. matfile 和分块读取
% B. 直接 load 全部变量
% C. 复制到 chapters
% 答案：A
%
% 选择题 4：本地真实路径文件为什么不发布？
% A. 它可能暴露私人目录和数据线索
% B. MATLAB 不允许有路径文件
% C. GitHub 不能显示 .m 文件
% 答案：A
%
% 选择题 5：读入数据后第一步应该：
% A. 检查变量名、尺寸、类型和单位线索
% B. 立刻画最终论文图
% C. 删除原始文件
% 答案：A

%% 13. 错题案例 / Debug the mistake
%
% 错题 1：直接 load 大文件。
%
% 错误写法：
% hugeData = load(paths.dbsMatFile);
%
% 更稳的起步方式：
if strlength(paths.dbsMatFile) > 0 && isfile(paths.dbsMatFile)
    safeInfo = whos("-file", paths.dbsMatFile);
    fprintf("Safe variable inspection count: %d\n", numel(safeInfo));
end
%
% 错题 2：假设所有 MAT 文件里变量名都一样。
% 正确方式：先检查变量名，再按实际变量名读取。

availableNames = string({info.name});
assert(any(availableNames == "demo"));
