%% Ch01 MATLAB 界面与 Live Script 工作流
% 本章目标 / Learning objectives
% 
% 1. 熟悉 MATLAB 主要界面区域。 2. 理解 Live Script 为什么适合做科研学习笔记。 3. 学会用代码节组织“解释 + 计算 + 
% 图 + 结论”。
% 
% Key terms: command window, workspace, current folder, editor, live editor, 
% run section

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end
%% 1. MATLAB 界面区域
% 你需要逐步熟悉这些区域：
% 
% Command Window：直接输入命令。 Workspace：查看当前变量。 Current Folder：当前文件夹。 Editor：编辑普通 
% .m 文件。 Live Editor：编辑 .mlx 文件，可以混合文本、公式、代码和输出。 Figure：显示图形。
% 
% 建议你学习时一直打开 Workspace 面板，这样能看到变量如何出现和变化。

a = 3;
b = 4;
c = sqrt(a^2 + b^2);
fprintf("c = %.2f\n", c);
%% 2. Live Script 的代码节
% 在 .m 或 .mlx 中，两个百分号开头的行表示一个代码节。 在 Live Editor 中可以选择 Run Section，只运行当前节。

time_ms = linspace(0, 5, 501);
frequency_kHz = 2;
signal = sin(2*pi*frequency_kHz*time_ms);

figure("Color", "w");
plot(time_ms, signal, "LineWidth", 1.3);
xlabel("Time (ms)");
ylabel("Signal (a.u.)");
title("A signal section in Live Script");
grid on;
set(gca, "FontName", "Arial", "FontSize", 11, "LineWidth", 1.0, ...
    "Box", "on", "XGrid", "on", "YGrid", "on");
%% 
% |*linspace使用讲解*|
% 
% |linspace| 是 MATLAB（以及 Python NumPy）中用于生成*线性等间距向量*的函数。
% 
% 它的核心优势在于：*直接指定生成点的总个数*，而不需要手动计算相邻点之间的间隔步长。例如：
% 
% y = linspace(x1, x2)
% 
% y = linspace(x1, x2, n)
% 
% *x1（起始值）*：区间的起点。
% 
% *x2（终止值）*：区间的终点（生成的数列*必然包含*终点）。
% 
% *n（点的总数，可选）*：要生成的元素个数。如果*省略 n*，默认生成 *100* 个点。
% 
% 两种常用方法比较：
% 
% *特性*
% 
% *linspace(x1, x2, n)*
% 
% *x1 : step : x2*
% 
% *控制侧重点*
% 
% 指定*元素个数* $n$
% 
% 指定*步长间隔* step
% 
% *是否一定包含终点*
% 
% *是*，最后一个元素严格等于 x2
% 
% *不一定*，若不能整除步长，则在不超过终点处截断
% 
% *典型适用场景*
% 
% 绘图采样、需要固定数组长度的场合
% 
% 循环计数、已知固定物理步长（如时间间隔 $\Delta t$）
% 
% *who 函数使用*

% 1. 查看当前工作区中的所有变量名（直接在命令行打印输出）
who;

% 2. 使用通配符筛选特定前缀、后缀或包含特定字符的变量
who x*       % 列出所有以字母 x 开头的变量名（如 x, x1, x_test）
who *data*   % 列出所有名称中包含 data 的变量名
who a b c    % 仅检查当前工作区是否存在名为 a、b、c 的变量(直接在命令行窗口使用)

% 3. 将变量名保存到单元数组（Cell Array）中，用于自动化脚本或逻辑判断
varNames = who;             % varNames 是一个包含所有变量名的 cell 数组，如 {'A'; 'b'; 'x'}
numVars = length(varNames); % 获取当前工作区变量的总个数

% 4. 结合 ismember 判断某个变量是否已经存在于工作区中
if ismember('targetVar', who)
    disp('变量已存在，跳过初始化步骤。');
end

% 5. 不加载数据到内存，直接查看或获取 MAT 文件中保存的变量名
demoWhoFile = fullfile(tempdir, "who_demo.mat");
x_demo = 1;
data_demo = [1 2 3];
save(demoWhoFile, "x_demo", "data_demo");
who("-file", demoWhoFile);           % 仅在命令行列出某 mat 文件里的所有变量名
matVars = who("-file", demoWhoFile); % 将 mat 文件里的变量名保存为 cell 数组
assert(ismember("data_demo", string(matVars)));
%% 3. 在讲义里写观察结论
% 运行上面的代码后，你应该观察：
% 
% 1. Workspace 中出现 time_ms、frequency_kHz、signal。 2. signal 的长度和 time_ms 一样。 
% 3. 频率 frequency_kHz 改大后，单位时间内振荡次数变多。
% 
% English sentence: The signal oscillates faster when the frequency is increased.
%% 4. 清理工作区和图窗
% 常用命令：
% 
% clear 清除变量 clc 清空命令行显示 close all 关闭图窗
% 
% 初学时不建议在每个小节都 clear，否则容易看不到变量之间的关系。

variableNames = who;
disp("Variables currently in workspace:");
disp(variableNames);
%% 5. 常见错误 / Common mistakes
% 错误 1：以为 Live Script 只是“漂亮版脚本”。 更准确：它是科研笔记、教学讲义、交互实验记录的混合体。
% 
% 错误 2：每运行一行都 clear all。 这样会让代码依赖关系难以观察。建议一章开始 clear，一节内部不要乱清。
% 
% 错误 3：只看图不看变量尺寸。 科研脚本里，size、numel、class 经常比图更早暴露问题。
%% 6. 练习
% 练习 1：创建变量 shot = 13653，并在 Workspace 中找到它。 练习 2：创建 time_ms = 0:0.1:10。 练习 3：画 
% sin(2*pi*0.5*time_ms)。 练习 4：把图标题改成英文 "Demo fluctuation signal"。 练习 5：用 who 查看当前变量名。
%% 7. 参考答案

shot = 13653;
time_ms_answer = 0:0.1:10;
signal_answer = sin(2*pi*0.5*time_ms_answer);

figure("Color", "w");
plot(time_ms_answer, signal_answer, "LineWidth", 1.3);
xlabel("Time (ms)");
ylabel("Amplitude (a.u.)");
title("Demo fluctuation signal");
grid on;
set(gca, "FontName", "Arial", "FontSize", 11, "LineWidth", 1.0, ...
    "Box", "on", "XGrid", "on", "YGrid", "on");

disp(who);
assert(shot == 13653);
assert(numel(time_ms_answer) == numel(signal_answer));
% assert（断言）会在程序运行时检测条件是否为真。
% 如果条件为 false，程序会立即中断并抛出错误，适合检查数组长度、单位换算和数据范围。
%% 8. 本章检查表
% [ ] 我知道 Command Window 的作用。 [ ] 我知道 Workspace 的作用。 [ ] 我能用 Run Section 分节运行。 
% [ ] 我能在 Live Script 中写代码和观察结论。 [ ] 我能用 who 查看变量。
%% 9. 加厚练习 / Extra exercises
% 

plasmaCurrent_MA = 0.6;
time_ms_more_dense = 0:0.05:5;
signal_more_dense = sin(2*pi*1.2*time_ms_more_dense);
whos plasmaCurrent_MA time_ms_more_dense signal_more_dense

sectionNote = "The current section created a temporary learning note.";
disp(sectionNote);
clear sectionNote
assert(~any(strcmp(who, "sectionNote")));
%% 
% |*assert(~any(strcmp(who, "sectionNote")));*|：
%% 
% * |who| 返回当前工作区所有变量名的 cell 数组。
% * |strcmp(who, "sectionNote")| 检查里面是否有名为 |"sectionNote"| 的项。
% * 因为刚刚执行了 |clear|，该项不存在，返回全 0（false）。
% * 取反 |~| 后为真（true），*断言通过，不会报错*。
%% 10. 小测验 / Mini quiz
% 选择题 1：Run Section 的作用是什么？ A. 只运行当前代码节 B. 删除当前文件 C. 安装工具箱 答案：A
% 
% 选择题 2：Workspace 中能看到什么？ A. 当前变量名、尺寸和值的摘要 B. GitHub 仓库访问量 C. Windows 桌面图标 答案：A
% 
% 选择题 3：Live Script 适合科研学习，是因为它可以： A. 混合文本、代码、图和输出 B. 自动替你理解物理 C. 代替所有测试 答案：A
% 
% 选择题 4：变量太多看不清时可以先用： A. who 或 whos B. plot C. legend 答案：A
% 
% 选择题 5：初学时建议如何处理报错？ A. 先读报错行号和原因 B. 立刻删除整个文件 C. 忽略继续运行 答案：A
%% 11. 错题案例 / Debug the mistake
% 错题 1：误以为变量会自动跨 MATLAB 重启保存。
% 
% 错误想法： "我昨天在 Workspace 里有变量，今天打开 MATLAB 应该还在。"
% 
% 正确理解： Workspace 是当前会话内存。需要长期保存的数据，应写入 .mat 文件。

tempValue = 42;
tempMatFile = fullfile(tempdir, "phase1_workspace_demo.mat");
save(tempMatFile, "tempValue");
loadedTemp = load(tempMatFile, "tempValue");
assert(loadedTemp.tempValue == 42);
%
% 错题 2：在不同代码节里使用变量，却忘记先运行产生变量的代码节。
% 解决方式：从上到下运行(全局运行)，或者在当前节中显式创建所需变量。
%% 12. 学习补充：grid 和 plot 属性
% grid 控制坐标轴网格线。科研图里常用 grid on 帮助读取数值；需要更细参考线时可以用 grid minor。

x_grid = 0:0.1:2*pi;
y_grid = sin(x_grid);

figure("Color", "w");
plot(x_grid, y_grid, "LineWidth", 1.3);
xlabel("x");
ylabel("sin(x)");
title("Grid example");
grid on;
grid minor;
set(gca, "FontName", "Arial", "FontSize", 11, "LineWidth", 1.0, ...
    "Box", "on", "XGrid", "on", "YGrid", "on");
%% 13. 学习补充：plot 常用属性
% plot 可以同时控制线型、线宽、颜色、标记、图例标签等属性。 学习时可以先模仿下面这个完整例子，再逐项删减，观察每个属性的作用。

x_style = 0:pi/20:2*pi;
y_style = sin(x_style);

figure("Color", "w");
plot(x_style, y_style, ...
    "LineStyle", "--", ...              % 虚线，默认实线
    "LineWidth", 2, ...                 % 线宽
    "Color", [0.2, 0.5, 0.9], ...       % 自定义 RGB 颜色
    "Marker", "square", ...             % 方形标记
    "MarkerSize", 8, ...                % 标记大小
    "MarkerEdgeColor", "b", ...         % 标记边框为蓝色
    "MarkerFaceColor", [1, 0.8, 0], ... % 标记填充为黄色
    "MarkerIndices", 1:2:length(x_style), ... % 每隔一个点画一个标记
    "DisplayName", "sin(x)");           % 图例标签
xlabel("x");
ylabel("sin(x)");
title("Styled plot example");
legend("show", "Location", "best");
grid on;
set(gca, "FontName", "Arial", "FontSize", 11, "LineWidth", 1.0, ...
    "Box", "on", "XGrid", "on", "YGrid", "on");