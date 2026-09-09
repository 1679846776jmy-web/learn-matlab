%% Ch04 科研绘图基础与图形规范
% 本章目标 / Learning objectives
%
% 1. 掌握常用二维科研图。
% 2. 学会坐标轴、单位、图例和多子图。
% 3. 建立可复用的绘图风格。
% 4. 能解释图中每个视觉元素对应什么数据和不确定性。
%
% Key terms:
% figure, axis label, legend, error bar, subplot, tiled layout, export

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. 基础曲线图

demo = fusionlearn.io.makeDemoSignal("DurationMs", 15, "SampleRateHz", 50000);

figure("Color", "w");
plot(demo.time_ms, demo.signal, "LineWidth", 1.0);
xlabel("Time (ms)");
ylabel("Signal (a.u.)");
title("Synthetic diagnostic signal");
legend("raw signal");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 1.1 figure、axes 和曲线对象是什么关系
% figure 是整张图窗，axes 是带坐标系的绘图区，plot 创建的 line 是 axes 内的图形对象。
% 标题、坐标轴、图例并不是数据本身，而是帮助读者正确解释数据的上下文。
%
% `gcf` 表示当前 figure，`gca` 表示当前 axes。把返回的句柄保存下来，比反复依赖
% “当前对象”更稳妥，尤其是在一张图里有多个 axes 时。

figHandle = figure("Color", "w");
axesHandle = axes(figHandle);
lineHandle = plot(axesHandle, demo.time_ms, demo.signal, ...
    "LineWidth", 1.0);
xlabel(axesHandle, "Time (ms)");
ylabel(axesHandle, "Signal (a.u.)");
title(axesHandle, "Figure, axes, and line objects");
grid(axesHandle, "on");
fprintf("Created object classes: %s, %s, %s.\n", ...
    class(figHandle), class(axesHandle), class(lineHandle));

%% 2. 多子图：原始信号、去均值信号、直方图

signal_zero_mean = demo.signal - mean(demo.signal);

figure("Color", "w");
tiledlayout(3, 1, "TileSpacing", "compact");

nexttile;
plot(demo.time_ms, demo.signal, "LineWidth", 1.0);
xlabel("Time (ms)");
ylabel("Raw (a.u.)");
title("Raw signal");
fusionlearn.plot.applyResearchStyle(gca);

nexttile;
plot(demo.time_ms, signal_zero_mean, "LineWidth", 1.0);
xlabel("Time (ms)");
ylabel("Zero-mean (a.u.)");
title("Zero-mean signal");
fusionlearn.plot.applyResearchStyle(gca);

nexttile;
histogram(signal_zero_mean, 50);
xlabel("Signal (a.u.)");
ylabel("Counts");
title("Amplitude distribution");
fusionlearn.plot.applyResearchStyle(gca);

%% 2.1 多子图不是为了塞更多图，而是为了建立比较
% tiledlayout 决定版面，nexttile 决定下一条绘图命令落在哪个 axes。多个面板最好共享
% 明确的比较逻辑，例如原始量、处理后量、分布；不要把毫不相关的图只因“空位还在”
% 放到一起。
%
% 比较同一时间段时，各面板 xlim 应一致。可以保存 axes 句柄并用 linkaxes 联动缩放。
% 不同物理量可以拥有不同 y 轴范围，但每个 y 标签都必须带名称和单位。

comparisonFigure = figure("Color", "w");
comparisonLayout = tiledlayout(comparisonFigure, 2, 1, ...
    "TileSpacing", "compact");
axRaw = nexttile(comparisonLayout);
plot(axRaw, demo.time_ms, demo.signal);
ylabel(axRaw, "Raw (a.u.)");
axProcessed = nexttile(comparisonLayout);
plot(axProcessed, demo.time_ms, signal_zero_mean);
xlabel(axProcessed, "Time (ms)");
ylabel(axProcessed, "Zero-mean (a.u.)");
linkaxes([axRaw, axProcessed], "x");

%% 3. 剖面和误差棒
% 科研图中，坐标轴必须写物理量和单位。

rho = linspace(0, 1, 21).';
temperature_keV = 2.5 * (1 - rho.^2) + 0.2;
temperature_error = 0.08 + 0.04*rho;

figure("Color", "w");
errorbar(rho, temperature_keV, temperature_error, "o-", "LineWidth", 1.2);
xlabel("Normalized radius \rho");
ylabel("Electron temperature T_e (keV)");
title("Profile with uncertainty");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

%% 3.1 误差棒的长度必须有统计或仪器含义
% errorbar 的第三个输入只是数值，MATLAB 不知道它代表标准差、标准误、置信区间，
% 还是仪器标称误差。这个含义必须由变量名、图注或正文说明。
%
% 对称误差只需要一个 yneg/ypos 数组；不对称误差可以分别给出下误差和上误差。
% 如果误差随半径变化，数组尺寸必须与剖面一致。误差棒非常密时，可以减少 marker
% 数量或只画代表性采样点，但不能为了图好看随意缩短误差。

relativeError = temperature_error ./ temperature_keV;
fprintf("Relative uncertainty ranges from %.1f%% to %.1f%%.\n", ...
    100*min(relativeError), 100*max(relativeError));

%% 4. 图形导出
% exportgraphics 可以把图保存为 PNG、PDF 等格式。
% 这里为了避免自动生成太多文件，只展示推荐写法。
%
% outputDir = fullfile(learningRoot, "outputs", "figures");
% if ~isfolder(outputDir)
%     mkdir(outputDir);
% end
% exportgraphics(gcf, fullfile(outputDir, "temperature_profile.png"), "Resolution", 300);

%% 4.1 PNG、PDF 和分辨率怎样选
% PNG 是栅格图，适合包含 imagesc、复杂填色或用于网页/幻灯片；分辨率决定放大后的
% 清晰度。PDF 常能保留线条和文字的矢量信息，适合论文中的曲线和等值线。
%
% 导出前先固定图窗内容和尺寸，避免使用屏幕截图。文件名应描述物理内容或 case，
% 不要长期积累 `figure1_final_new2.png` 这类无法追溯的名字。
%
% 颜色还要考虑打印、色觉差异和黑白阅读。多条曲线最好同时使用颜色、线型和 marker，
% 不要只依赖非常接近的两种颜色。

%% 5. 常见错误 / Common mistakes
%
% 错误 1：坐标轴没有单位。
% 错误 2：用标题代替 y 轴标签。
% 错误 3：多条曲线没有 legend。
% 错误 4：图形脚本和数据处理脚本混在一起，后续难复用。

%% 6. 练习
%
% 练习 1：画 demo.signal 的前 5 ms。
% 练习 2：改变线条颜色和线宽。
% 练习 3：画 temperature_keV 和 density 的双曲线对比图。
% 练习 4：使用 tiledlayout 创建 2 行 1 列子图。
% 练习 5：给所有图添加英文坐标轴标签。
% 练习 6：尝试取消 grid，再比较可读性。

%% 7. 参考答案

mask_5ms = demo.time_ms <= 5;

figure("Color", "w");
plot(demo.time_ms(mask_5ms), demo.signal(mask_5ms), "b", "LineWidth", 1.4);
xlabel("Time (ms)");
ylabel("Signal (a.u.)");
title("First 5 ms of the signal");
legend("selected window");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

density_1e19 = 4.0 * (1 - 0.5*rho.^2) + 0.2;
figure("Color", "w");
tiledlayout(2, 1, "TileSpacing", "compact");
nexttile;
plot(rho, temperature_keV, "o-", "LineWidth", 1.2);
xlabel("Normalized radius \rho");
ylabel("T_e (keV)");
title("Temperature profile");
fusionlearn.plot.applyResearchStyle(gca);
nexttile;
plot(rho, density_1e19, "s-", "LineWidth", 1.2);
xlabel("Normalized radius \rho");
ylabel("Density (10^{19} m^{-3})");
title("Density profile");
fusionlearn.plot.applyResearchStyle(gca);

%% 8. 本章检查表
%
% [ ] 我能画基础曲线图。
% [ ] 我能使用 tiledlayout。
% [ ] 我能画误差棒。
% [ ] 我知道坐标轴必须写单位。
% [ ] 我知道如何导出图片。

%% 9. 加厚练习 / Extra exercises
%
% 练习 A：画一条红色虚线。
% 练习 B：画两条曲线，并添加 legend。
% 练习 C：把 x 轴限制在 2-8 ms。
% 练习 D：把图保存到 outputs/figures，但先检查目录是否存在。
% 练习 E：把图标题改为英文研究风格短标题。

figure("Color", "w");
plot(demo.time_ms, demo.signal, "r--", "LineWidth", 1.0);
xlim([2 8]);
xlabel("Time (ms)");
ylabel("Signal (a.u.)");
title("Windowed fluctuation signal");
grid on;
fusionlearn.plot.applyResearchStyle(gca);

outputDir = fullfile(learningRoot, "outputs", "figures");
if ~isfolder(outputDir)
    mkdir(outputDir);
end
exportgraphics(gcf, fullfile(outputDir, "phase1_windowed_signal.png"), "Resolution", 150);
assert(isfile(fullfile(outputDir, "phase1_windowed_signal.png")));

%% 10. 小测验 / Mini quiz
%
% 选择题 1：科研图的坐标轴最好包含：
% A. 物理量和单位
% B. 随便一个字母
% C. 文件夹路径
% 答案：A
%
% 选择题 2：多子图推荐使用：
% A. tiledlayout 和 nexttile
% B. clear 和 clc
% C. whos 和 who
% 答案：A
%
% 选择题 3：误差棒常用函数是：
% A. errorbar
% B. surf
% C. readtable
% 答案：A
%
% 选择题 4：保存当前图像常用：
% A. exportgraphics
% B. load
% C. exist
% 答案：A
%
% 选择题 5：图例的作用是：
% A. 区分不同曲线或数据组
% B. 改变采样率
% C. 自动计算积分
% 答案：A

%% 11. 错题案例 / Debug the mistake
%
% 错题 1：两条曲线没有图例，读者不知道谁是谁。

t_plot = demo.time_ms;
y1_plot = demo.signal;
y2_plot = demo.signal - mean(demo.signal);

figure("Color", "w");
plot(t_plot, y1_plot, "Color", [0.5 0.5 0.5]);
hold on;
plot(t_plot, y2_plot, "b", "LineWidth", 1.1);
xlabel("Time (ms)");
ylabel("Signal (a.u.)");
title("Raw and zero-mean signals");
legend("Raw", "Zero-mean");
grid on;
fusionlearn.plot.applyResearchStyle(gca);
%
% 错题 2：保存图之前没有创建输出目录。
% 正确做法：先 if ~isfolder(outputDir), mkdir(outputDir), end。
