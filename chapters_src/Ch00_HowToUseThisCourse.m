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

%% 10. 加厚练习 / Extra exercises
%
% 练习 A：用 fullfile 组合 learningRoot 和 "docs"，检查该目录是否存在。
% 练习 B：用 dir 查看 chapters 文件夹下有多少个 .mlx 文件。
% 练习 C：用 fprintf 打印一句英文学习记录：
% "Today I learned how to start the MATLAB learning library."
% 练习 D：用 which 查找 startup_learning.m 的位置。
% 练习 E：用 exist 判断 fusionlearn.io.makeDemoSignal 是否可用。

docsDir = fullfile(learningRoot, "docs");
assert(isfolder(docsDir));

chapterFiles = dir(fullfile(learningRoot, "chapters", "*.mlx"));
fprintf("Live Script chapters found: %d\n", numel(chapterFiles));

fprintf("Today I learned how to start the MATLAB learning library.\n");
disp(which("startup_learning"));
assert(strlength(string(which("fusionlearn.io.makeDemoSignal"))) > 0);

%% 11. 小测验 / Mini quiz
%
% 选择题 1：Workspace 主要用来做什么？
% A. 查看当前内存中的变量
% B. 修改 MATLAB 安装目录
% C. 删除所有函数
% 答案：A
%
% 选择题 2：Current Folder 影响什么？
% A. MATLAB 查找和运行文件的位置
% B. CPU 运行速度
% C. 图像颜色
% 答案：A
%
% 选择题 3：Live Script 的文件扩展名是什么？
% A. .mlx
% B. .csv
% C. .fig
% 答案：A
%
% 选择题 4：快速查看函数简短帮助应优先用什么？
% A. help
% B. delete
% C. close all
% 答案：A
%
% 选择题 5：真实大数据应该放在哪里？
% A. 学习库外部，通过路径配置读取
% B. 直接复制进 chapters
% C. 改名为 README
% 答案：A

%% 12. 错题案例 / Debug the mistake
%
% 错题 1：路径拼接不要手写斜杠。
%
% 错误写法：
% badPath = learningRoot + "\docs";
%
% 更稳的写法：
goodPath = fullfile(learningRoot, "docs");
assert(isfolder(goodPath));
%
% 错题 2：不要用 cd 在脚本中频繁跳来跳去。
% 更好的方式是用 fullfile 得到完整路径，把路径作为参数传给函数。

%% 13. 学习补充：Live Script 局部运行和富文本编辑
% 这些笔记来自学习过程中的手动补充，保留在完结版中，方便初学时反复对照界面操作。
%
% 局部运行核心看“节（Section）”和“选区”：
%
% 1. 运行当前节：光标停在要运行的节内，按 Ctrl + Enter。
% 2. 运行当前节并跳到下一节：按 Ctrl + Shift + Enter。
% 3. 仅运行选中的几行代码：高亮选中代码，按 F9。
% 4. 分节方法：在代码行输入 %% 加空格，或点击顶部工具栏的 Section Break。
%
% 富文本编辑：
%
% 1. 先按 Alt + Enter，或点击顶部工具栏的“文本”按钮，将当前行切为富文本模式。
% 2. 标题和字号：在“实时编辑器”选项卡中使用样式下拉菜单。
% 3. 列表、加粗、斜体、公式和图片，都可以直接作为学习笔记写在 .mlx 里。
%
% 初学建议：
%
% 1. 每个小节先运行一次，不急着改。
% 2. 第二遍只改一个参数，再观察 Workspace、图窗和输出变化。
% 3. 遇到报错时，把报错第一行、涉及的变量名、自己的猜测写在本章末尾。
