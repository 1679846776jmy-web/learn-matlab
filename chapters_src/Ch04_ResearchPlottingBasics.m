%% Ch04 科研绘图基础与图形规范
% 本章目标 / Learning objectives
%
% 1. 掌握常用二维科研图。
% 2. 学会坐标轴、单位、图例和多子图。
% 3. 建立可复用的绘图风格。
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

%% 4. 图形导出
% exportgraphics 可以把图保存为 PNG、PDF 等格式。
% 这里为了避免自动生成太多文件，只展示推荐写法。
%
% outputDir = fullfile(learningRoot, "outputs", "figures");
% if ~isfolder(outputDir)
%     mkdir(outputDir);
% end
% exportgraphics(gcf, fullfile(outputDir, "temperature_profile.png"), "Resolution", 300);

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

