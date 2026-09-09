%% Ch06 数据读写与外部数据路径配置
% 本章目标 / Learning objectives
%
% 1. 掌握 MAT、CSV、TXT 的基础读写。
% 2. 学会先检查文件信息，再加载变量。
% 3. 理解真实 EFIT 和 DBS 数据的安全接入方式。
% 4. 知道不同文件格式会保留或丢失哪些类型、尺寸和元信息。
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

%% 1.1 MAT、CSV 和 TXT 不是同一种数据容器
% MAT 文件是 MATLAB 原生二进制格式，可以保留 struct、table、复杂数组和多数
% MATLAB 类型，适合保存中间结果和可复现实验数据。
%
% CSV 本质是二维文本表格，适合跨软件交换列式数据，但嵌套 struct、多维数组、
% 单位和复杂元信息不能自然保留。TXT 更泛化，既可能是规则数值矩阵，也可能只是
% 人类可读说明；读取前必须知道它的布局和编码。
%
% 选择格式时先问：谁来读取、数据是否二维、类型是否混合、是否需要跨软件、文件
% 多大、单位和元信息放在哪里。文件扩展名本身不能替代数据说明。

matDiskInfo = dir(matFile);
fprintf("The demo MAT file occupies %.1f KiB on disk.\n", ...
    matDiskInfo.bytes/1024);

%% 2. 不加载全部数据，先检查 MAT 文件

info = fusionlearn.io.checkMatFileInfo(matFile);
assert(any(strcmp({info.name}, "demo")));

loadedDemo = fusionlearn.io.loadMatVariable(matFile, "demo");
assert(numel(loadedDemo.time_ms) == numel(loadedDemo.signal));

%% 2.1 load 的两种写法为什么风险不同
% `load(filePath)` 会把文件中的变量直接放进当前 Workspace；如果有同名变量，可能
% 覆盖现有内容。`loaded = load(filePath)` 则返回一个 struct，文件变量成为字段，
% 来源边界更清楚。
%
% 更进一步，可以写 `load(filePath,"variableName")` 只读需要的变量。本学习库的
% loadMatVariable 还会先检查变量是否存在，并在缺失时给出更明确的错误。
%
% `whos("-file",filePath)` 读取的是目录信息，而不是整个变量内容。它给出名称、尺寸、
% 字节数和 class，是决定下一步加载策略的依据。

rawContainer = load(matFile, "demo");
disp(fieldnames(rawContainer));

%% 3. 保存和读取 CSV

csvTable = table( ...
    loadedDemo.time_ms(1:20), ...
    loadedDemo.signal(1:20), ...
    'VariableNames', ["time_ms", "signal"]);

csvFile = fullfile(simulatedDir, "demo_signal_first20.csv");
writetable(csvTable, csvFile);

readBackTable = readtable(csvFile);
disp(readBackTable(1:5, :));

%% 3.1 table 读写时要检查列名和列类型
% writetable 把 table 的变量名写成表头，readtable 会根据文件内容推断每列类型。
% 自动推断很方便，但真实文件里的空值标记、日期格式、混合文本或重复列名可能让
% 结果与预期不同。
%
% 读入后至少检查 `readBackTable.Properties.VariableNames`、summary、height、width
% 和每列 class。批量读取同格式文件时，可用 detectImportOptions 生成并固定导入规则，
% 避免不同文件因为少量内容差异而推断成不同类型。

disp(readBackTable.Properties.VariableNames);
fprintf("CSV table size = %d rows x %d variables.\n", ...
    height(readBackTable), width(readBackTable));

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

%% 4.1 文本文件需要先区分“逐行文本”和“规则数值表”
% readlines 适合把每一行当作一条 string；readmatrix 适合规则的纯数值区域；
% readtable 适合有列名、混合类型的表。选择错误的读取函数，常会得到大量 NaN、
% 被拆错的列或丢失的表头。
%
% 写文本时也要明确目的：writelines 保存说明和日志，writematrix 保存数值矩阵，
% writetable 保存带列名的表。不要只因它们都能生成 `.txt` 就混为一谈。

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

%% 5.1 外部路径配置同时解决可移植性和公开安全问题
% 代码仓库应描述“需要 EFIT 原始目录、处理后目录和 DBS 文件”这些接口字段，而不是
% 写死某位使用者的盘符。换电脑时只改本地配置，不需要搜索并修改几十个脚本。
%
% 外部路径还可能暴露用户名、单位内部目录、实验编号或未公开数据线索。公开前应检查
% `.m`、`.md`、Live Script 输出缓存和生成日志，而不只检查源码里最显眼的字符串。
%
% 路径存在只说明文件系统能找到目标，不说明数据格式、权限和内容正确。读取后仍要
% 验证变量、尺寸、单位和时间范围。

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

%% 6.1 matfile 和分块读取适用于什么情况
% matfile 可以访问部分 MAT 文件中的变量切片，而不必一次把整个数组读入内存。
% 对大型二维/多维数组，可以先根据时间索引或通道索引只读取需要区域。
%
% 分块访问通常要求 MAT 文件使用支持部分加载的格式，例如 v7.3。即使能分块读取，
% 随机、零碎地访问磁盘也可能很慢；更好的方式是按连续时间块读取、在内存中处理，
% 然后及时释放不再需要的块。
%
% 推荐决策顺序：先看文件总大小 -> whos -file 看变量 -> 选择目标变量 -> 估算切片
% 所需内存 -> 再决定普通 load、只加载指定变量，还是 matfile 分块。

demoVariableInfo = whos("-file", matFile, "demo");
fprintf("Selected MAT variable uses %d bytes.\n", demoVariableInfo.bytes);

%% 6.2 数据文件还需要“来源、单位和处理历史”
% 只有 time 和 signal 数组通常不够。一个可复现结果至少应说明采样率、时间单位、
% 信号单位、来源文件或模拟参数、处理步骤和生成时间。
%
% 这些信息可以作为 struct 字段、table 的 VariableUnits/VariableDescriptions、单独
% metadata struct 或同目录 README 保存。关键是读取程序能稳定找到，使用者能看懂。

metadata = struct();
metadata.timeUnit = "ms";
metadata.signalUnit = "a.u.";
metadata.source = "fusionlearn.io.makeDemoSignal";
metadata.processing = "none";
metadata.createdAt = datetime("now");
disp(metadata);

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
