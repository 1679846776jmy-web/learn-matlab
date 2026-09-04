%% Ch00 如何使用这套讲义
% 本章目标 / Learning objectives
%
% 1. 知道这套学习库的目录结构。
% 2. 学会运行 startup_learning.m 初始化路径。
% 3. 学会查看 MATLAB 版本、工具箱和帮助文档。
% 4. 建立每次学习的基本流程：运行、修改、观察、记录。
%
% Key terms:
% workspace, current folder, command window, live script, toolbox, path

clear; clc; close all;

if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
    addpath(fullfile(learningRoot, "data", "external_paths"));
end

%% 1. 查看学习库结构
% 建议你先把 MATLAB 的 Current Folder 切换到学习库根目录：
%
% 你的学习库根目录，例如克隆 GitHub 仓库后的 learn-matlab 文件夹。
%
% 然后运行 startup_learning。

disp("Learning root:");
disp(learningRoot);

folderList = ["chapters", "chapters_src", "functions", "examples", "data", "tests", "docs", "projects"];
for k = 1:numel(folderList)
    folderPath = fullfile(learningRoot, folderList(k));
    fusionlearn.utils.checkPathExists(folderPath, folderList(k));
end

%% 2. 查看 MATLAB 版本和工具箱
% version 返回 MATLAB 版本。
% ver 返回已安装产品列表。

matlabVersionText = version;
products = ver;

fprintf("MATLAB version: %s\n", matlabVersionText);
fprintf("Number of installed products: %d\n", numel(products));

if ~isempty(products)
    firstProducts = products(1:min(8, numel(products)));
    disp(struct2table(firstProducts));
end

%% 3. help 和 doc
% help 适合快速看函数用法。
% doc 适合打开完整官方文档。
%
% 下面的命令不会自动打开 doc 页面，避免打断运行；你可以手动在命令行输入：
%
% help plot
% doc plot

helpText = help("plot");
disp(extractBefore(string(helpText), min(strlength(string(helpText)), 600)));

%% 4. 一个最小可运行例子
% 这是你学习每章时的基本动作：运行一段代码，改参数，再看图形变化。

t = linspace(0, 2*pi, 400);
y = sin(t);

figure("Color", "w");
plot(t, y, "LineWidth", 1.5);
xlabel("Phase (rad)");
ylabel("Amplitude (a.u.)");
title("First MATLAB plot");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 5. 学习方式建议
% 推荐节奏：
%
% 1. 先完整运行本章。
% 2. 修改参数，比如把 sin 改成 cos，把线宽改成 2。
% 3. 出错时不要马上删代码，先读报错信息。
% 4. 把错误原因写进学习日志。
% 5. 最后完成练习，再看参考答案。

%% 6. 常见错误 / Common mistakes
%
% 错误 1：Current Folder 没切到学习库根目录。
% 结果：MATLAB 找不到 startup_learning 或 fusionlearn 函数。
%
% 错误 2：把大实验数据复制进学习库。
% 结果：目录混乱，后续 Git 管理困难。
%
% 错误 3：看到报错就重启 MATLAB。
% 更好的方式：先看第一行错误、文件名和行号。

%% 7. 练习
%
% 练习 1：运行 startup_learning，确认输出根目录。
% 练习 2：用 version 查看 MATLAB 版本。
% 练习 3：用 ver 查看是否有 Signal Processing Toolbox。
% 练习 4：画 cos(t) 曲线。
% 练习 5：把曲线标题改成英文。

%% 8. 参考答案

rootFromStartup = startup_learning();
assert(isfolder(rootFromStartup));

disp(version);

v_answer = ver;
productNames = string({v_answer.Name});
hasSignalToolbox = any(contains(productNames, "Signal Processing Toolbox"));
fprintf("Signal Processing Toolbox installed: %d\n", hasSignalToolbox);

t_answer = linspace(0, 2*pi, 400);
y_answer = cos(t_answer);
figure("Color", "w");
plot(t_answer, y_answer, "LineWidth", 1.5);
xlabel("Phase (rad)");
ylabel("Amplitude (a.u.)");
title("Cosine wave example");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 9. 本章检查表
%
% [ ] 我能运行 startup_learning。
% [ ] 我知道 Current Folder 是什么。
% [ ] 我能查看 MATLAB 版本和工具箱。
% [ ] 我知道 help 和 doc 的区别。
% [ ] 我能运行并修改一个简单绘图例子。
