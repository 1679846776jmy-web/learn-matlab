%% Ch11 MATLAB 项目使用 Tips：命令窗口、路径、数据类型与调试习惯
% 本章目标 / Learning objectives
%
% 1. 把 Command Window 当作临时试验和支线工作的操作台。
% 2. 理解 MATLAB 怎样寻找函数，而不再只靠“把文件放到一起”碰运气。
% 3. 能辨认并选择常见数据类型和数据容器。
% 4. 看懂一个通用科研项目的文件职责和调用顺序。
% 5. 掌握一组能立刻用于真实项目的调试、计时和可复现习惯。
%
% 本章不会要求你背下所有命令。重点是建立一张“遇到问题时去哪里看”的地图。

clear; clc; close all;
if exist("startup_learning", "file") == 2
    learningRoot = startup_learning();
else
    learningRoot = fileparts(fileparts(mfilename("fullpath")));
    addpath(learningRoot);
    addpath(fullfile(learningRoot, "functions"));
end

%% 1. 命令窗口是支线工作台，不只是输出窗口
% 运行脚本后，变量通常进入当前 Workspace。命令窗口可以立刻接着使用这些变量：
%
% 1. 临时查看某个值或某几行数据。
% 2. 直接调用已经写好的 function。
% 3. 换一组参数试算，不必先改动正式脚本。
% 4. 快速画图验证“这个量大致长什么样”。
% 5. 用帮助和定位命令查清楚 MATLAB 实际调用了哪个函数。
%
% 这种临时操作适合探索，但有价值的步骤最终应写回脚本或函数，否则关闭 MATLAB
% 后很难完整复现。

demoVector = linspace(0, 1, 9).';
demoProfile = 2.5*(1 - demoVector.^2) + 0.2;

disp(demoProfile(1:3));
fprintf("Peak value = %.3f\n", max(demoProfile));

% 下面这些命令也可以逐行复制到 Command Window 试用：
%
% demoProfile(end)
% mean(demoProfile)
% plot(demoVector, demoProfile)
% grid on

%% 2. function 写好后，可以从命令窗口直接调用
% function 不属于某一个调用它的脚本。只要 MATLAB 能找到函数文件，并且输入满足
% 函数要求，就可以从脚本、Live Script、另一个函数或 Command Window 调用它。
%
% 例如 centralDifference1D.m 位于本学习库的 package 中。启动脚本已经把 functions
% 文件夹加入搜索路径，所以这里可以直接使用完整名称调用。

x = linspace(0, 2*pi, 101).';
y = sin(x);
dy_dx = fusionlearn.math.centralDifference1D(x, y);

fprintf("Numerical derivative near x = pi is %.4f.\n", dy_dx(51));

% 在 Command Window 中可以马上试另一组参数：
%
% x_try = linspace(0, 1, 51).';
% y_try = x_try.^3;
% derivative_try = fusionlearn.math.centralDifference1D(x_try, y_try);
%
% 这没有修改函数本身。你改变的是“传给函数的输入”，函数根据新输入重新计算。

%% 3. 一个函数为什么能被找到
% 当你输入函数名时，MATLAB 会按搜索规则寻找可调用的名字。初学阶段可以先记住：
%
% 1. 当前正在执行的文件内部可见的 local function。
% 2. Current Folder 中的文件。
% 3. MATLAB search path 上各文件夹中的文件。
% 4. MATLAB 自带函数和工具箱函数也位于这套搜索体系中。
%
% 如果多个位置存在同名函数，排在前面的版本会遮住后面的版本，这叫 name shadowing。
% 因此“文件确实存在”不等于“MATLAB 调用的就是你以为的那个文件”。

functionLocation = which("fusionlearn.math.centralDifference1D");
disp("MATLAB currently finds the function here:");
disp(functionLocation);

% 实际排查时常用：
%
% which functionName
% which functionName -all
% help functionName
% edit functionName
%
% `which -all` 会列出所有同名候选，是检查名称遮蔽最直接的办法之一。

%% 4. addpath 到底做了什么
% `addpath(folder)` 的含义是：把 folder 加入“当前 MATLAB 会话”的函数搜索路径。
% 它不会复制函数，不会把函数读进 Workspace，也不会自动执行文件。
%
% 可以把 path 想成一张有顺序的路线清单。调用函数时，MATLAB 沿路线寻找匹配文件；
% `addpath` 是把一条新路线加入清单。默认情况下，新路径放在搜索顺序前部。
%
% 常用配套命令：
%
% path                 查看完整搜索路径
% addpath(folder)      为当前会话增加路径
% rmpath(folder)       从当前会话移除路径
% addpath(genpath(folder))  递归加入 folder 下的大多数子文件夹
% restoredefaultpath   恢复 MATLAB 默认路径，使用前要知道它会清除自定义路径
% savepath             把当前 path 写入后续会话的默认路径设置
%
% `genpath` 很方便，但会把许多并不需要公开调用的子目录一起加入。项目越大，越容易
% 出现同名函数冲突。更可控的做法是只加入源码根目录，让 package 和项目入口管理边界。
%
% `savepath` 会影响后续 MATLAB 会话。学习项目通常更适合在 startup 脚本或 MATLAB
% Project 启动任务里重建路径，使“项目需要哪些路径”仍然能被别人复现。

pathContainsCourseFunctions = contains(path, fullfile(learningRoot, "functions"));
fprintf("Course functions are on path: %d\n", pathContainsCourseFunctions);

%% 5. “必须在同一个文件夹”并不是完整规则
% 两个文件在同一文件夹时，经常恰好能互相调用，是因为该文件夹是 Current Folder
% 或已经位于 path 上。真正决定可见性的不是“必须同文件夹”，而是文件类型和搜索范围。
%
% 普通独立函数：函数名通常与文件名一致；文件所在目录在 Current Folder 或 path 上即可。
%
% 脚本末尾 local function：主要服务当前文件，只在该文件规定的范围内可见，不适合作为
% 多个文件共同调用的公共入口。
%
% `private` 文件夹：其中函数只对指定父文件夹范围内的代码可见，适合隐藏内部实现。
%
% `+package` 文件夹：调用时必须写限定名，例如
% `fusionlearn.plot.applyResearchStyle(gca)`。点号左侧是 package 层级，右侧才是函数名。
% package 能减少大型项目里的同名冲突，也让函数属于哪个模块一目了然。

%% 6. 点号在 MATLAB 语法中的几种身份
% 点号看起来相同，实际含义由它所在的位置决定：
%
% 1. `3.14`：数字中的小数点。
% 2. `.*`、`./`、`.^`：逐元素乘、除、乘方；数组同位置元素分别计算。
% 3. `.'`：非共轭转置，只交换行列；复数数据中它与 `'` 不完全相同。
% 4. `data.signal`：访问结构体字段、对象属性或 table/timetable 的变量。
% 5. `fusionlearn.math.centralDifference1D`：用点号写 package 限定名。
%
% 初学者最容易把第 2 类和矩阵运算混淆。`A*B` 是线性代数矩阵乘法，`A.*B`
% 是对应元素相乘。点号不是“装饰”，而是在改变运算定义。

a = [1 2; 3 4];
b = [2 2; 2 2];
elementProduct = a .* b;
matrixProduct = a * b;

z = [1+2i, 3-4i];
nonConjugateTranspose = z.';
conjugateTranspose = z';

pointDemo = struct("elementProduct", elementProduct, ...
    "matrixProduct", matrixProduct);
disp(pointDemo.elementProduct);
disp(nonConjugateTranspose);
disp(conjugateTranspose);

%% 7. 先问 class 和 size，再猜变量是什么
% 报错信息经常只告诉你“这里不能这样算”，真正原因可能是类型或尺寸与预期不同。
% `class` 回答“它是什么类型”，`size` 回答“它的形状是什么”，`whos` 同时给出
% 名称、尺寸、字节数和类型。面对陌生数据时，这三项通常比直接双击变量更快。

numericDouble = 42;
numericSingle = single(42);
numericInteger = int16(42);
logicalValue = true;
textValue = "plasma";
characterValue = 'plasma';

basicValues = {numericDouble; numericSingle; numericInteger; logicalValue; ...
    textValue; characterValue};
basicLabels = ["default numeric"; "single precision"; "integer"; ...
    "logical"; "string"; "character vector"];
basicClasses = string(cellfun(@class, basicValues, "UniformOutput", false));
disp(table(basicLabels, basicClasses, 'VariableNames', ["Example", "Class"]));

%% 8. 数值类型：double 不是“所有数字”的总称
% MATLAB 直接输入 `1` 时，默认得到 double。double 提供约 15-16 位十进制有效数字，
% 是大多数数值计算函数的默认选择。
%
% single 占用的存储通常是 double 的一半，但精度较低；只有当数据量、GPU 工作流或
% 外部格式确实需要时再使用。整数类型适合计数、标签和特定文件格式，不适合直接承担
% 一般微分方程计算。logical 只保存 true/false，特别适合掩码。
%
% 类型转换会真实改变表示范围和精度，不只是改一个名字。

largeDouble = 1e8 + 1;
largeSingle = single(1e8) + single(1);
fprintf("Double keeps 1e8 + 1 as %.0f.\n", largeDouble);
fprintf("Single stores the same expression as %.0f.\n", largeSingle);

%% 9. string、char、cell、struct、table 和 timetable 怎么选
% string：处理文件名、标签和普通文本时通常更方便，用双引号创建。
%
% char：较早 MATLAB 代码和部分接口常用字符向量，用单引号创建。两者不是同一类型。
%
% cell：每个单元可以放不同类型或不同尺寸的内容，灵活但不自动说明每列含义。
%
% struct：按字段名组织一组有关联、但尺寸或类型可以不同的数据，适合配置和单次实验记录。
%
% table：按列组织观测数据，每列有变量名且类型可不同，适合导入、清洗、统计和机器学习。
%
% timetable：在 table 基础上增加时间行坐标，适合时间序列、重采样和多诊断时间对齐。

cfgDemo = struct();
cfgDemo.sampleRate_Hz = 1000;
cfgDemo.window_ms = [20 40];
cfgDemo.description = "short diagnostic window";

sampleIndex = (1:5).';
temperature_keV = [1.2; 1.3; 1.4; 1.35; 1.28];
quality = categorical(["good"; "good"; "check"; "good"; "good"]);
profileTable = table(sampleIndex, temperature_keV, quality);

time_s = seconds((0:4).');
signalTimetable = timetable(time_s, temperature_keV);

disp(fieldnames(cfgDemo));
disp(profileTable);
disp(signalTimetable);

%% 10. 工程文件的职责：入口、配置、算法、展示、测试、输出
% 一个通用科研项目通常需要回答六个问题：
%
% 入口脚本：这次计算按什么顺序执行？
% 配置文件：网格、时间、物理参数和开关在哪里改？
% 算法函数：每一步计算的输入和输出是什么？
% 绘图函数：怎样把计算结果变成一致的图？
% 测试：哪些最基本性质必须一直成立？
% 输出目录：哪些文件是运行生成的，而不是源码？
%
% Ch11 配套的 rk3_pde_project 使用一个与聚变数据无关的对流扩散例子，目的是让
% 工程结构本身更容易看清。三阶 Runge-Kutta 是时间推进方法，不是“三阶方程”。

projectRoot = fullfile(learningRoot, "examples", "project_tips", ...
    "rk3_pde_project");
projectFiles = [
    "main_run_case.m"
    "config/defaultConfig.m"
    "src/+rk3pde/buildGrid.m"
    "src/+rk3pde/rhsAdvectionDiffusion.m"
    "src/+rk3pde/stepSSPRK3.m"
    "src/+rk3pde/plotSolution.m"
    "tests/test_rk3_project.m"
    ];
disp(projectFiles);

%% 11. 读懂 RK3 项目的调用链
% `main_run_case.m` 只做流程编排：定位项目、读取配置、建网格、构造初值、估算时间步、
% 循环推进、检查结果并画图。具体公式分别放在 package 函数中。
%
% 对流扩散方程写成：
%
% du/dt + c du/dx = chi d2u/dx2
%
% 空间离散后，右端函数 L(u) 返回当前状态的变化率。三阶 SSP RK 的三个 stage
% 会多次调用 L(u)，最后组成下一时刻的状态。这里用周期边界，因此最左和最右网格
% 在差分意义上相邻。

pathBeforeProject = path;
projectPathCleanup = onCleanup(@() path(pathBeforeProject));
addpath(fullfile(projectRoot, "config"));
addpath(fullfile(projectRoot, "src"));

cfg = defaultConfig();
cfg.nCells = 48;
cfg.finalTime_s = 0.05;
[xProject_m, dxProject_m] = rk3pde.buildGrid(cfg);
uProject0 = rk3pde.initialCondition(xProject_m, cfg);
dtProject_s = rk3pde.stableTimeStep(dxProject_m, cfg);
rhsProject = @(state) rk3pde.rhsAdvectionDiffusion(state, dxProject_m, cfg);
uProject1 = rk3pde.stepSSPRK3(uProject0, dtProject_s, rhsProject);

fprintf("One RK3 step changed the peak from %.4f to %.4f.\n", ...
    max(uProject0), max(uProject1));
clear projectPathCleanup;

%% 12. 调试时按“现场、类型、尺寸、数值、来源”检查
% 现场：在 Command Window 输入 `dbstop if error`，再次运行后 MATLAB 会停在报错行。
%
% 类型：用 `class(variable)`，确认你拿到的是 double、table、struct 还是其他对象。
%
% 尺寸：用 `size`、`numel`、`height`、`width`，特别检查行向量和列向量。
%
% 数值：用 `isfinite`、`isnan`、`isinf`、`min`、`max` 看是否出现非法值或数量级错误。
%
% 来源：用 `which functionName -all` 查函数版本，用调用堆栈看是谁调用了当前函数。
%
% 修复后可以输入 `dbclear if error` 取消“遇错即停”。断点和单步运行适合追踪变量
% 怎样一行一行变化，尤其适合定位变量被提前 clear 或被同名变量覆盖的问题。

debugVector = [1, 2, NaN, 4, Inf];
finiteMask = isfinite(debugVector);
fprintf("Finite values: %d of %d.\n", nnz(finiteMask), numel(debugVector));

%% 13. 可复现、计时和大数据习惯
% `rng(seed)` 固定随机数流，别人再次运行时能得到相同噪声样本。
% `tic`/`toc` 适合粗略测量一段代码耗时；需要找瓶颈时再用 `profile on`、
% `profile off` 和 `profile viewer`。
%
% 大 MAT 文件不要一上来全部 load。先用 `whos("-file", filePath)` 看变量名、尺寸
% 和字节数，再决定读取哪个变量或是否使用 matfile 分块读取。
%
% 警告和错误也有职责差异：warning 表示结果仍可返回但需要注意；error 表示继续计算
% 可能产生无意义结果，应立即停止。沉默地返回错误物理量通常最难排查。

rng(11);
timerStart = tic;
repeatableNoise = 0.02*randn(2000, 1);
elapsed_s = toc(timerStart);
fprintf("Generated reproducible noise in %.4g s.\n", elapsed_s);

%% 14. 一页式项目 Tips
% 命令窗口组：
%
% - 临时试值、查看切片、调用函数、画快图和查帮助。
% - 用上箭头或 Command History 找回命令，把重要步骤整理回代码文件。
% - 用 `format shortG`、`format longG` 改显示方式，不会改变变量实际精度。
% - 用 `pwd`、`dir`、`cd` 确认位置，但正式项目路径优先由根目录和 fullfile 构造。
%
% 函数与路径组：
%
% - 先用 `which` 判断 MATLAB 是否找到函数，再检查输入参数。
% - `addpath` 改搜索路线，不会导入函数或变量。
% - `which -all` 用于检查同名遮蔽；package 用限定名降低冲突概率。
% - `genpath` 适合结构简单且全部子目录都应公开的项目，使用前先想清楚范围。
% - 多个脚本共享的逻辑放在独立函数或 package 中，并写清输入、输出和单位。
% - local function 适合当前文件内部的小辅助步骤。
%
% 数据和工程组：
%
% - 参数较多时用 struct 集中管理，表格型观测数据优先考虑 table/timetable。
% - 变量名附带单位，例如 `time_ms`、`Te_keV`、`sampleRate_Hz`。
% - 入口文件组织流程，算法函数做计算，绘图函数负责表达结果。
% - 输出文件与源码分开；生成结果应能由代码再次产生。
% - 先让小网格、小时间窗或少量文件跑通，再扩大规模。
%
% 调试和性能组：
%
% - 先读报错的第一条有效信息、文件名和行号，再顺着调用堆栈向上看。
% - 优先检查类型、行列方向、数组尺寸、单位和 NaN/Inf。
% - `dbstop if error` 保留报错现场；修复后用相同输入重新验证。
% - 不要在流程中随意 clear 后续仍需要的变量；`clear all` 还会清函数缓存。
% - 固定随机种子使测试可重复，计时前先让代码至少运行一次。
% - 用 profiler 找到真正耗时的位置后再优化。

%% 15. 练习
% 练习 1：在 Command Window 直接调用 centralDifference1D，计算 y=x.^2 的导数。
% 练习 2：用 `which` 和 `which -all` 查看 `mean` 以及一个自编函数的位置。
% 练习 3：解释 addpath 为什么不是 Python 语言中的 import。
% 练习 4：分别用 struct、table、timetable 表示一次实验配置、径向剖面和时间信号。
% 练习 5：比较 `'` 和 `.'` 对复数向量的结果。
% 练习 6：运行 RK3 项目的主脚本，只修改对流速度，观察峰的位置如何变化。
% 练习 7：在 RK3 右端函数中故意传入行向量，使用 `dbstop if error` 观察停在哪里。
% 练习 8：对一个大 MAT 文件先运行 `whos("-file", filePath)`，不要直接 load。

%% 16. 小测验 / Mini quiz
% 选择题 1：在 Command Window 输入一个可见函数名并给出参数，会发生什么？
% A. MATLAB 调用该函数并返回结果
% B. MATLAB 只能显示脚本输出
% C. function 文件必须先复制到 Command Window
% 答案：A
%
% 选择题 2：addpath(folder) 的核心作用是：
% A. 修改当前会话的函数搜索路径
% B. 执行 folder 中全部脚本
% C. 把 folder 中变量加载到 Workspace
% 答案：A
%
% 选择题 3：`A.*B` 表示：
% A. 对应元素相乘
% B. 必然是矩阵乘法
% C. 字段访问
% 答案：A
%
% 选择题 4：带明确时间轴的多列观测数据常适合使用：
% A. timetable
% B. figure
% C. function_handle
% 答案：A
%
% 选择题 5：MATLAB 调错了同名函数时，最先使用：
% A. which functionName -all
% B. close all
% C. format long
% 答案：A
%
% 选择题 6：程序出现尺寸不匹配时，应优先查看：
% A. class 和 size
% B. 图窗颜色
% C. MATLAB 启动画面
% 答案：A

%% 17. 错题案例 / Debug the mistake
% 错题 1：认为“函数和脚本不在同一个文件夹，所以绝对不能调用”。
% 更正：普通函数只要位于 Current Folder 或 MATLAB path 上就可能被调用；local、
% private 和 package 还各自有可见性规则。
%
% 错题 2：为了找函数，直接对整个磁盘运行 addpath(genpath(...))。
% 更正：这会引入大量无关目录和同名冲突。应从项目根目录确定真正需要公开的源码目录。
%
% 错题 3：把 `cfg.dt` 中的点号理解为逐元素运算。
% 更正：这里的点号是字段访问；只有 `.*`、`./`、`.^` 才是对应的逐元素运算符。
%
% 错题 4：看到 single 和 double 都能保存小数，就认为它们精度完全相同。
% 更正：single 的有效数字和可表示范围更小，类型转换可能丢失信息。
%
% 错题 5：脚本报错后先 clear all，导致现场变量全部消失。
% 更正：先用 debugger、Workspace、class 和 size 检查现场，再决定清理哪些变量。

%% 18. 本章检查表
% [ ] 我能在 Command Window 直接调用一个自己写好的 function。
% [ ] 我能解释 Current Folder、path 和 addpath 的关系。
% [ ] 我能用 which -all 检查同名函数遮蔽。
% [ ] 我知道普通函数、local function、private 和 package 的可见性不同。
% [ ] 我能解释点号在逐元素运算、字段访问、package 和转置中的含义。
% [ ] 我能辨认 double、logical、string、struct、table 和 timetable。
% [ ] 我能读懂 RK3 示例项目中入口、配置、算法、测试和输出的职责。
% [ ] 我能用 dbstop if error、class、size 和 isfinite 保存并检查报错现场。
