%% Ch12 MATLAB 工程相关 App 总览
% 本章目标 / Learning objectives
%
% 1. 认识与数据处理、信号、拟合、优化、PDE、机器学习和仿真有关的常用 App。
% 2. 知道每个 App 的输入、基本操作、输出和工具箱要求。
% 3. 学会把 App 当作探索入口，再把可复现步骤带回脚本、函数或模型。
% 4. 能判断一个任务适合先用 App 观察，还是直接编写代码。
%
% 范围说明：本章不介绍图像诊断和控制系统设计相关 App。这里先建立全景认识，
% 后续拟合、信号处理、PDE、机器学习和 App Designer 章节再通过实际案例深入。

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. App 是什么，它和代码是什么关系
% MATLAB App 通常把一类常见任务组织成可点击、可预览的交互界面。它适合：
%
% 1. 第一次接触陌生数据时快速观察。
% 2. 比较多种算法或参数，建立直觉。
% 3. 发现合适流程后导出代码、变量、模型或会话。
% 4. 教学演示和结果检查。
%
% App 并不会自动保证物理假设、单位、训练数据、边界条件或误差指标正确。正式科研
% 流程仍要保存输入、参数、代码版本和输出说明。最推荐的路线是：
%
% 准备数据 -> App 中探索 -> 检查结果 -> 导出代码或对象 -> 整理进项目 -> 自动验证
%
% Apps 选项卡只显示当前安装产品提供的 App，所以不同电脑、不同 MATLAB release
% 看到的列表可能不同。

installedProducts = ver;
installedProductNames = string({installedProducts.Name}).';
fprintf("This MATLAB installation reports %d products.\n", ...
    numel(installedProductNames));
disp(installedProductNames);

%% 2. 本章 App 地图
% 表格中的“工具箱”表示主要来源，不代表列出的所有高级功能都只需这一个产品。
% 有些导出、并行、GPU 或部署功能还需要额外产品。

appName = [
    "Import Tool"
    "Data Cleaner"
    "Signal Analyzer"
    "Signal Labeler"
    "Filter Designer"
    "Filter Analyzer"
    "Curve Fitter"
    "Distribution Fitter"
    "Regression Learner"
    "Classification Learner"
    "Optimize Live Editor Task"
    "PDE Modeler"
    "Simulation Data Inspector"
    "Deep Network Designer"
    "App Designer"
    ];

mainPurpose = [
    "预览文件并生成可复用导入代码"
    "清理 table 或 timetable"
    "比较时域、频域和时频信号"
    "为信号区间、事件或类别添加标签"
    "按指标设计 FIR/IIR 数字滤波器"
    "查看和比较滤波器响应"
    "曲线、曲面、插值和平滑拟合"
    "拟合一维概率分布"
    "训练和比较监督回归模型"
    "训练和比较监督分类模型"
    "在 Live Script 中交互定义优化问题"
    "搭建和求解二维 PDE"
    "检查并比较多次 Simulink 仿真结果"
    "搭建、检查并导出深度网络"
    "设计带界面的 MATLAB 工具"
    ];

mainProduct = [
    "MATLAB"
    "MATLAB"
    "Signal Processing Toolbox"
    "Signal Processing Toolbox"
    "Signal Processing Toolbox"
    "DSP System Toolbox"
    "Curve Fitting Toolbox"
    "Statistics and Machine Learning Toolbox"
    "Statistics and Machine Learning Toolbox"
    "Statistics and Machine Learning Toolbox"
    "MATLAB；高级问题需 Optimization Toolbox"
    "Partial Differential Equation Toolbox"
    "Simulink"
    "Deep Learning Toolbox"
    "MATLAB"
    ];

openEntry = [
    "uiimport"
    "dataCleaner"
    "signalAnalyzer"
    "signalLabeler"
    "filterDesigner"
    "filterAnalyzer"
    "curveFitter"
    "distributionFitter"
    "regressionLearner"
    "classificationLearner"
    "Live Editor > Insert > Task > Optimize"
    "pdeModeler"
    "Simulink.sdi.view"
    "deepNetworkDesigner"
    "appdesigner"
    ];

laterPractice = [
    "Ch19 数据预处理项目"
    "Ch19 数据预处理项目"
    "Ch14 信号处理"
    "Ch14 信号处理扩展"
    "Ch14 信号处理"
    "Ch14 信号处理扩展"
    "Ch13 拟合与误差"
    "Ch13 误差与统计扩展"
    "后续机器学习案例"
    "后续机器学习案例"
    "Ch13 优化"
    "Ch16 平衡与 PDE 扩展"
    "Ch18 Simulink"
    "后续数据驱动案例"
    "Ch18 App Designer"
    ];

appOverview = table(appName, mainPurpose, mainProduct, openEntry, laterPractice, ...
    'VariableNames', ["App", "Purpose", "Product", "Open", "LaterChapter"]);
disp(appOverview);

%% 3. 检查命令入口是否在当前安装中可见
% `which` 返回空，不一定表示安装损坏。常见原因包括工具箱未安装、许可证不可用、
% 当前 release 尚无该 App，或者这个功能应从 Live Editor 菜单插入。
% 本节只检查命令是否可定位，不会真正打开 App。

commandNames = [
    "uiimport"
    "dataCleaner"
    "signalAnalyzer"
    "signalLabeler"
    "filterDesigner"
    "filterAnalyzer"
    "curveFitter"
    "distributionFitter"
    "regressionLearner"
    "classificationLearner"
    "pdeModeler"
    "Simulink.sdi.view"
    "deepNetworkDesigner"
    "appdesigner"
    ];

commandLocations = strings(size(commandNames));
for commandIndex = 1:numel(commandNames)
    commandLocations(commandIndex) = string(which(commandNames(commandIndex)));
end
commandAvailable = strlength(commandLocations) > 0;
disp(table(commandNames, commandAvailable, commandLocations, ...
    'VariableNames', ["Command", "Available", "Location"]));

%% 4. Import Tool：先看懂文件，再生成导入代码
% 适合输入：文本、CSV、电子表格、MAT、HDF5、netCDF 等多种文件。
%
% 基本流程：
%
% 1. Home > Import Data，或在 Command Window 输入 `uiimport(filePath)`。
% 2. 预览文件，确认分隔符、表头、数据起始行和每列类型。
% 3. 只选择真正需要的行、列或变量。
% 4. 先导入 Workspace 检查。
% 5. 对同格式批量文件，选择生成脚本或函数，不要每次手点。
%
% 对聚变数据尤其要检查：时间单位、缺失值标记、科学计数法、列名是否被自动修改、
% HDF5/netCDF 内部层级，以及大文件是否适合一次性读取。

demoCsvPath = fullfile(tempdir, "fusionlearn_app_overview_demo.csv");
demoTime_ms = (0:0.5:5).';
demoSignal = sin(2*pi*0.2*demoTime_ms);
demoImportTable = table(demoTime_ms, demoSignal);
writetable(demoImportTable, demoCsvPath);
fprintf("A small Import Tool demo file was written to:\n%s\n", demoCsvPath);

% 需要交互练习时取消下一行注释：
% uiimport(demoCsvPath)
%
% 官方文档：https://www.mathworks.com/help/matlab/ref/importtool.html

%% 5. Data Cleaner：处理列式数据，并保留清洗步骤
% 适合输入：一个 table 或 timetable。它可以查看摘要、缺失值和异常值，并执行重命名、
% 删除列、填补缺失、处理异常、平滑、归一化、stack/unstack 和 timetable retime。
%
% 基本流程：
%
% 1. 在 Workspace 准备原始 table/timetable，建议保留只读风格的原变量。
% 2. 输入 `dataCleaner`，从 Workspace 或文件导入。
% 3. 先看 Summary 和 Visualization，再决定清洗动作。
% 4. 检查每一步影响了多少行、是否改变时间轴。
% 5. 导出新的清洗后变量，或导出脚本/函数，使过程可复现。
%
% Data Cleaner 适合初步探索，但“异常值”不等于“错误值”。物理瞬变、破裂前快速变化
% 或诊断饱和必须结合实验背景判断，不能看到离群点就自动删除。

dirtyValue = [1.0; NaN; 1.2; 8.0; 1.1];
dirtyTable = table((1:5).', dirtyValue, ...
    'VariableNames', ["Sample", "Signal"]);
disp(dirtyTable);

% 需要交互练习时取消下一行注释：
% dataCleaner
%
% 官方文档：https://www.mathworks.com/help/matlab/ref/datacleaner-app.html

%% 6. Signal Analyzer：同时观察时域、频域和时频域
% 适合输入：向量、每列一条信号的矩阵、带时间信息的 timetable 或 timeseries。
% 如果只传数值向量，应同时告诉 App 采样率，否则横轴可能只是样本编号。
%
% 基本流程：
%
% 1. 把一段较短、已确认采样率的信号放进 Workspace。
% 2. 输入 `signalAnalyzer(signal, "SampleRate", fs_Hz)`。
% 3. 比较波形、频谱和 spectrogram，检查主频与时间变化。
% 4. 尝试去趋势、平滑、滤波、重采样或截取。
% 5. 导出处理后的信号或生成预处理函数，再用代码复核参数。
%
% 这非常适合 Ch14 前的频谱直觉训练。不要把频谱上的每一个峰都直接解释成物理模态；
% 还要检查窗函数、频率分辨率、工频干扰、采样混叠和仪器响应。

fs_Hz = 2000;
t_s = (0:1/fs_Hz:1-1/fs_Hz).';
signalForApp = sin(2*pi*80*t_s) + 0.25*sin(2*pi*260*t_s);

% 需要交互练习时取消下一行注释：
% signalAnalyzer(signalForApp, "SampleRate", fs_Hz)
%
% 官方文档：https://www.mathworks.com/help/signal/ref/signalanalyzer-app.html

%% 7. Signal Labeler：把“事件在哪里”保存为结构化标签
% Signal Labeler 用于给信号区间、点事件或整体成员添加标签。标签可以表示运行阶段、
% 异常区间、某种波形事件或人工审核结论，之后可导出为 labeledSignalSet 等对象。
%
% 基本流程：导入带时间信息的信号 -> 定义标签 -> 在波形上标注 -> 检查一致性 ->
% 导出标签集合。多人标注时还需要统一标签含义和边界规则。
%
% 对初学者最重要的区分是：Signal Analyzer 主要分析信号，Signal Labeler 主要记录
% “哪些样本属于什么事件”。

% 需要交互练习时取消下一行注释：
% signalLabeler
%
% 官方文档：https://www.mathworks.com/help/signal/ref/signallabeler-app.html

%% 8. Filter Designer 与 Filter Analyzer：设计和检查滤波器
% Filter Designer 从通带、阻带、采样率、阶数等指标出发，设计 FIR 或 IIR 滤波器；
% 可查看幅频、相频、群延迟、脉冲响应和零极点，并导出滤波器或生成 MATLAB 代码。
%
% Filter Analyzer 更偏向导入多个已有滤波器，比较它们的响应。它适合回答“这两个
% 滤波器到底差在哪里”，而不是代替你决定科学上合理的截止频率。
%
% 基本流程：
%
% 1. 明确采样率和想保留的物理频带。
% 2. 设定通带、阻带和允许衰减，不要只填一个截止频率就结束。
% 3. 查看幅值响应之外，也检查相位/群延迟和阶数。
% 4. 导出 digitalFilter 或生成代码。
% 5. 用原始信号与滤波后信号做并列图，并记录滤波器参数。

% filterDesigner
% filterAnalyzer
%
% 官方文档：
% https://www.mathworks.com/help/signal/ref/filterdesigner-app.html
% https://www.mathworks.com/help/dsp/ref/filteranalyzer-app.html

%% 9. Curve Fitter：拟合不是只看一条曲线贴得多近
% 适合输入：一维 x-y 数据、带权重的曲线数据或 x-y-z 曲面数据。
% 可比较线性/非线性回归、插值、平滑和自定义方程，并查看拟合优度、置信区间、
% 残差和验证数据表现。
%
% 基本流程：
%
% 1. 准备 x、y，可选权重或验证数据。
% 2. 输入 `curveFitter(x, y)`。
% 3. 选择候选模型并检查参数初值和边界。
% 4. 比较残差结构，不要只看 R-squared。
% 5. 导出 fit 对象或生成函数，放入 Ch13 的可复现脚本。

fitX = linspace(0, 2, 30).';
fitY = 1.8*exp(-fitX/0.7) + 0.15;

% curveFitter(fitX, fitY)
%
% 官方文档：https://www.mathworks.com/help/curvefit/curvefitter-app.html

%% 10. Distribution Fitter：问“数据像哪种分布”
% 它用于对一维样本拟合概率分布，并比较 PDF、CDF、概率图和参数。适合检查噪声、
% 波动幅度或残差是否近似某种分布。
%
% 基本流程：导入样本 -> 查看经验分布 -> 试多个候选分布 -> 比较拟合 -> 导出参数。
% 需要注意：样本可能有时间相关性，不能因为直方图像高斯就默认每个点独立同分布。

rng(12);
distributionSample = randn(300, 1);
% distributionFitter(distributionSample)
%
% 官方文档：https://www.mathworks.com/help/stats/distributionfitter-app.html

%% 11. Regression Learner 与 Classification Learner
% Regression Learner 的响应是连续数值，例如根据多个特征预测输运系数。
% Classification Learner 的响应是类别，例如把时间窗分成“背景、事件 A、事件 B”。
%
% 两者的基本流程相似：
%
% 1. 准备每行一个样本的 table，分清 predictor 和 response。
% 2. 选择训练/验证方案，避免同一次实验的相邻样本同时泄漏到训练和验证。
% 3. 训练多个候选模型并比较验证指标。
% 4. 查看残差、混淆矩阵、ROC、特征影响或预测解释。
% 5. 用从未参与调参的测试数据做最终检查。
% 6. 导出模型和预测函数，保存训练变量名、单位和预处理步骤。
%
% App 能快速比较算法，但不能自动判断数据泄漏、类别不平衡或跨放电泛化问题。

mlTable = table((1:20).', sin((1:20).'/3), cos((1:20).'/5), ...
    'VariableNames', ["Sample", "FeatureA", "Response"]);
% regressionLearner
% classificationLearner
%
% 官方文档：
% https://www.mathworks.com/help/stats/regression-learner-app.html
% https://www.mathworks.com/help/stats/classificationlearner-app.html

%% 12. Optimize Live Editor Task：边调参数边生成优化代码
% Optimize 是 Live Editor Task，不一定作为独立窗口出现在 Apps 列表。打开 Live Script，
% 选择 Insert > Task > Optimize。它可以为常见优化或非线性方程问题生成 MATLAB 代码。
%
% 基本流程：在任务上方准备数据和初值 -> 插入任务 -> 选择问题类型和求解器 ->
% 设置边界/约束/选项 -> 运行 -> 阅读退出标志和最优目标值 -> 保留生成代码。
%
% 初值、变量缩放和局部极小值会影响结果。“求解器成功退出”只表示数值条件满足，
% 不表示模型一定符合物理。

objective = @(p) (p(1)-2).^2 + 4*(p(2)+1).^2;
initialGuess = [0; 0];
fprintf("Objective at initial guess = %.3f.\n", objective(initialGuess));

% 官方文档：https://www.mathworks.com/help/matlab/ref/optimize.html

%% 13. PDE Modeler：把二维 PDE 的七个步骤看成一个整体
% PDE Modeler 适合二维几何问题。统一工作流是：
%
% 1. 建立几何区域。
% 2. 指定边界条件。
% 3. 指定 PDE 系数。
% 4. 生成网格。
% 5. 设置求解参数和必要的初值。
% 6. 求解。
% 7. 绘制并导出结果。
%
% 它有助于理解几何、边界、系数、网格和解之间的关系，也可以把数据导出到 Workspace
% 继续处理。需要注意其 App 工作流主要针对二维几何，且并非所有多方程系统都支持。

% pdeModeler
%
% 官方文档：https://www.mathworks.com/help/pde/ug/pdemodeler-app.html

%% 14. Simulation Data Inspector：比较“多次仿真”而不只看一条曲线
% 这个工具用于查看和比较 Simulink 记录信号。它可以按绝对、相对和时间容差比较
% 两次运行，适合参数修改前后、算法版本前后和基准结果回归检查。
%
% 基本流程：让模型记录信号 -> 运行多个 case -> 打开 Data Inspector -> 选择信号 ->
% 设置比较容差 -> 查看未通过区间 -> 保存会话或用程序接口生成比较结果。
%
% 它依赖 Simulink。没有 Simulink 时，本课程的数值主线仍可继续使用普通 MATLAB
% 脚本和图形比较。

% Simulink.sdi.view
%
% 官方文档：https://www.mathworks.com/help/simulink/slref/simulationdatainspector.html

%% 15. Deep Network Designer：先理解网络结构，再谈训练
% 该 App 可导入、搭建、编辑和检查深度学习网络，分析层之间的尺寸是否兼容，并生成
% 构建网络的 MATLAB 代码。不同 release 的训练入口和推荐网络对象可能变化。
%
% 对本学习路线，它属于后期拓展：只有在数据量、标签质量、验证划分和简单基线都已
% 明确后，再尝试深度网络。先用线性模型或树模型建立可解释基线通常更容易发现问题。

% deepNetworkDesigner
%
% 官方文档：
% https://www.mathworks.com/help/deeplearning/ref/deepnetworkdesigner-app.html

%% 16. App Designer：把成熟流程包成工具
% App Designer 用 Design View 布局按钮、输入框、表格和 UIAxes，用 Code View 编写
% callback。它适合把已经稳定的读取、处理和绘图流程做成给其他人使用的小工具。
%
% 推荐结构：界面只负责收集输入和显示状态；真正的数据读取和算法仍放在普通函数中。
% 这样同一套算法既能被 App 调用，也能被测试脚本和批处理脚本调用。
%
% 基本流程：新建空白 App -> 用 grid layout 布局 -> 添加组件 -> 写 callback ->
% 把计算委托给函数 -> 处理输入错误 -> 测试不同窗口尺寸 -> 打包分享。

% appdesigner
%
% 官方文档：https://www.mathworks.com/help/matlab/app-designer.html

%% 17. 怎样为任务选择 App
% 情况 A：陌生 CSV 列类型混乱。先用 Import Tool 看结构，再生成导入函数。
%
% 情况 B：table 有缺失值、异常值和不同时间步。先用 Data Cleaner探索，再导出清洗代码。
%
% 情况 C：想看某段涨落信号主频是否随时间变化。先用 Signal Analyzer。
%
% 情况 D：已经知道要保留的频带，需要设计并审查滤波器。用 Filter Designer，随后
% 在代码里验证幅相响应和对原信号的影响。
%
% 情况 E：温度剖面需要比较多种经验函数。用 Curve Fitter 建立候选，再在 Ch13 中
% 用独立数据、残差和物理约束确认。
%
% 情况 F：二维区域、边界和网格关系还不直观。用 PDE Modeler 建模，再导出数据。
%
% 情况 G：需要反复比较多个 Simulink case。用 Simulation Data Inspector。
%
% 情况 H：稳定算法需要交给不写代码的同事操作。用 App Designer 包装已测试函数。

%% 18. App 使用的共同限制
% 工具箱：App 图标缺失时先运行 ver，并查官方文档中的产品要求。
%
% release：命令名、界面位置和可导出对象可能随版本变化，讲义中的入口以当前官方
% 文档为准；旧版本优先从 Apps 选项卡搜索相近名称。
%
% 内存：App 往往方便地加载整份数据，大型诊断文件仍应先检查尺寸并截取小时间窗。
%
% 可复现性：只保存截图不足以复现实验。至少保存生成代码、导出对象、输入数据版本、
% 参数和 MATLAB release。
%
% 科学判断：自动推荐、最佳分数和默认参数都只是候选，必须回到单位、误差、独立
% 验证和物理解释。

%% 19. 练习
% 练习 1：查看 appOverview，为每个 App 标记你的电脑上是否可用。
% 练习 2：用 Import Tool 打开 demoCsvPath，并生成导入函数。
% 练习 3：在 Data Cleaner 中打开 dirtyTable，比较填补缺失值前后的统计量。
% 练习 4：用 Signal Analyzer 查看 signalForApp 的 80 Hz 和 260 Hz 成分。
% 练习 5：为“保留 50-120 Hz、抑制 200 Hz 以上”选择一个滤波 App，并写出必需参数。
% 练习 6：用 Curve Fitter 打开 fitX 和 fitY，比较指数模型与多项式模型的残差。
% 练习 7：为二维扩散、连续量预测、事件类别判断分别选择一个 App。
% 练习 8：任选一个 App，记录“输入、三步操作、导出物、后续脚本位置”。

%% 20. 小测验 / Mini quiz
% 选择题 1：Import Tool 最适合在什么时候使用？
% A. 第一次查看并配置陌生文件的导入规则
% B. 替代所有数值计算
% C. 自动判断物理单位
% 答案：A
%
% 选择题 2：Data Cleaner 当前主要处理：
% A. table 和 timetable
% B. 任意 Simulink 模型
% C. 函数搜索路径
% 答案：A
%
% 选择题 3：Signal Analyzer 输入普通向量时还应明确：
% A. 采样率或采样时间
% B. 文件夹颜色
% C. Git 分支名
% 答案：A
%
% 选择题 4：Curve Fitter 结果中不能只看：
% A. 一条拟合曲线和 R-squared
% B. 残差和验证数据
% C. 参数单位和边界
% 答案：A
%
% 选择题 5：PDE Modeler 的合理顺序包括：
% A. 几何、边界、系数、网格、求解、绘图
% B. 只按一次 Solve
% C. 先删除全部变量
% 答案：A
%
% 选择题 6：App 探索完成后，正式项目最重要的动作是：
% A. 导出并保存可复现代码、对象、参数和数据说明
% B. 只保存截图
% C. 记住按钮位置即可
% 答案：A

%% 21. 错题案例 / Debug the mistake
% 错题 1：Apps 列表没有某个 App，就认为 MATLAB 安装完全损坏。
% 更正：先检查 release、工具箱和许可证；有些功能是 Live Editor Task。
%
% 错题 2：Signal Analyzer 图上有峰，就立即写成某种等离子体模态。
% 更正：还要检查采样率、窗函数、频率分辨率、混叠、仪器响应和独立证据。
%
% 错题 3：Data Cleaner 自动识别为异常值，所以全部删除。
% 更正：统计离群点可能是真实物理瞬变，应结合诊断和实验上下文判断。
%
% 错题 4：机器学习 App 中分数最高的模型一定最好。
% 更正：检查数据泄漏、分组验证、测试集、复杂度、稳定性和解释性。
%
% 错题 5：App 中做完操作并保存截图，就认为分析可复现。
% 更正：应导出代码或对象，记录输入、参数、版本和输出。

%% 22. 本章检查表
% [ ] 我知道怎样查看本机已安装产品和可用 App。
% [ ] 我能说出 Import Tool 与 Data Cleaner 的不同职责。
% [ ] 我能区分 Signal Analyzer、Signal Labeler、Filter Designer 和 Filter Analyzer。
% [ ] 我知道 Curve Fitter、Distribution Fitter 和两个 Learner App 分别解决什么问题。
% [ ] 我能复述 PDE Modeler 的几何到求解流程。
% [ ] 我知道 Simulation Data Inspector 用来比较仿真运行结果。
% [ ] 我知道 Deep Network Designer 属于后期拓展，App Designer 用于封装成熟流程。
% [ ] 我会把 App 探索结果导回可复现的脚本、函数、对象或模型。
