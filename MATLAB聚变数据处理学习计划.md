# MATLAB 聚变数据处理与等离子体仿真学习计划

生成日期：2026-09-04  
目标用户：MATLAB 有一点编程基础、希望面向聚变数据处理、等离子体平衡、湍流输运核心模块开发与仿真程序调试的初学者  
计划形式：后续建设为一套可在 MATLAB 中直接使用的 Live Script 讲义、配套 `.m` 函数库、项目案例、练习答案和测试脚本。

---

## 1. 总体目标

这份学习计划的核心目标不是单纯学会 MATLAB 语法，而是逐步具备以下能力：

1. 能读懂、修改、调试小型科研 MATLAB 脚本。
2. 能处理常见聚变实验数据文件，包括 `.mat`、`.txt`、`.csv`、HDF5、NetCDF，以及 EFIT/gfile 类数据。
3. 能用 MATLAB 完成数值积分、数值微分、偏导数近似、矩阵计算、ODE/PDE 入门、拟合、优化、FFT、滤波、谱分析等计算物理任务。
4. 能围绕 Tokamak 聚变研究中的数据处理、平衡分析、湍流输运分析建立初步代码框架。
5. 能用更工程化的方式组织脚本、函数、配置、测试、数据路径和项目案例。
6. 能形成科研英文阅读和表达习惯，逐步熟悉 MATLAB 与等离子体物理常见英文术语。

最终成果应是一套“可以打开、可以运行、可以改、可以模仿”的 MATLAB 学习讲义，而不是静态 PDF。

---

## 2. 用户选择与默认取舍

根据已回答的 55 个选择题，本计划采用以下决策：

| 维度 | 采用方案 |
|---|---|
| 学习周期 | 8 周强化路线 |
| 每周投入 | 10 小时以上，建议每周 10-14 小时 |
| 起点 | 会一点编程，但按 MATLAB 初学者安排 |
| 数学 | 边学边补，数学概念和代码实现同步推进 |
| 物理 | 边学聚变与等离子体物理，优先服务代码理解 |
| 语言 | 中文为主，中英术语对照，并增加科研英文表达 |
| MATLAB 版本 | 当前版本未知，后续代码应先检查版本和工具箱 |
| 文件形式 | `.mlx`、`.m`、`.md` 全部提供 |
| 章节数量 | 20 章，含 4 个项目型章节 |
| 每章结构 | 概念 + 示例 + 练习 + 答案 + 项目任务结合 |
| 练习答案 | 放在同一 `.mlx` 中，便于对照学习 |
| 代码风格 | 教学型清晰 + 工程型严谨 |
| 目录结构 | `chapters/examples/functions/projects/data/tests/docs` |
| Git | 教基础 Git 与版本管理习惯 |
| 脚本管理 | 函数化、路径管理、配置文件、项目结构 |
| MATLAB 界面 | 穿插讲，不单独占用太多主线时间 |
| 绘图 | 科研图规范、二维/三维可视化、图形导出 |
| 数据来源 | 先模拟数据，再逐步接入真实 EFIT 和 DBS 数据 |
| 真实 EFIT 数据 | 通过本地私有 `data_paths_local.m` 配置，不在公开仓库暴露路径 |
| 真实 DBS 数据 | 通过本地私有 `data_paths_local.m` 配置，不在公开仓库暴露路径 |
| 计算物理 | 积分、微分、ODE、PDE、矩阵、拟合、加权拟合、误差分析 |
| 等离子体平衡 | Grad-Shafranov 概念、玩具模型、EFIT 数据读取与可视化 |
| 湍流输运 | 相关长度、谱分析、通量估计、DBS 数据处理 |
| 调试 | 断点、debugger、常见错误、仿真程序验证 |
| 性能 | 向量化、预分配、profile、并行/GPU 入门 |
| 工具箱 | Base MATLAB 为主，Signal/Optimization/Symbolic/Parallel 可选 |
| Simulink | 加一章认识，不作为主线 |
| App Designer | 后期做一个小工具 |
| 测试 | `assert` + MATLAB 单元测试入门 |
| 项目数量 | 4 个 |
| 难度 | 小步递进 |
| 每章练习 | 5-8 题 |
| 错题代码 | 每章包含常错代码与改正 |
| 检查表 | 每章包含学习检查表 |
| 术语表 | MATLAB + 聚变术语 |
| 速查表 | 函数、绘图、调试速查 |
| 评估成果 | 能读懂并修改小型科研脚本 |
| 文档风格 | 详细教学大纲 |

---

## 3. 后续学习库建议目录结构

后续真正创建 `.mlx` 和 `.m` 文件时，建议在当前工作文件夹中建立如下结构：

```text
learn-matlab
├─ README.md
├─ MATLAB聚变数据处理学习计划.md
├─ startup_learning.m
├─ chapters
│  ├─ Ch00_如何使用这套讲义_完结版.mlx
│  ├─ Ch01_MATLAB界面与LiveScript工作流_完结版.mlx
│  ├─ Ch02_变量数组索引与基础语法_完结版.mlx
│  ├─ Ch03_脚本函数路径与工程化组织_完结版.mlx
│  ├─ Ch04_科研绘图基础与图形规范_完结版.mlx
│  ├─ Ch05_二维三维可视化与磁面图_完结版.mlx
│  ├─ Ch06_数据读写与外部数据路径配置_完结版.mlx
│  ├─ Ch07_矩阵计算线性方程特征值与SVD_完结版.mlx
│  ├─ Ch08_数值积分微分偏导与插值_完结版.mlx
│  ├─ Ch09_ODE求解与物理模型案例_完结版.mlx
│  ├─ Ch10_PDE有限差分入门与一维输运模型_完结版.mlx
│  ├─ Ch11_拟合优化加权拟合与误差分析.mlx
│  ├─ Ch12_FFT滤波谱分析与相关分析.mlx
│  ├─ Ch13_Tokamak与等离子体物理入门.mlx
│  ├─ Ch14_GradShafranov平衡与EFIT数据.mlx
│  ├─ Ch15_调试测试性能优化并行GPU入门.mlx
│  ├─ Ch16_SymbolicSimulink与AppDesigner入门.mlx
│  ├─ Ch17_Project1_聚变实验数据预处理.mlx
│  ├─ Ch18_Project2_磁场平衡可视化.mlx
│  └─ Ch19_Project3和4_湍流谱分析与仿真调试.mlx
├─ examples
│  ├─ basic_syntax
│  ├─ plotting
│  ├─ numerical_methods
│  ├─ plasma_intro
│  └─ debugging_cases
├─ functions
│  └─ +fusionlearn
│     ├─ +io
│     ├─ +plot
│     ├─ +math
│     ├─ +plasma
│     ├─ +efit
│     ├─ +dbs
│     ├─ +debug
│     └─ +utils
├─ projects
│  ├─ project01_fusion_preprocess
│  ├─ project02_equilibrium_visualization
│  ├─ project03_dbs_turbulence_spectrum
│  └─ project04_simulation_debug_validation
├─ data
│  ├─ simulated
│  ├─ small_samples
│  ├─ external_paths
│  │  └─ data_paths_template.m
│  └─ README_data_policy.md
├─ tests
│  ├─ run_all_tests.m
│  ├─ test_math_methods.m
│  ├─ test_io_adapters.m
│  └─ test_signal_pipeline.m
└─ docs
   ├─ MATLAB函数速查表.md
   ├─ 科研绘图速查表.md
   ├─ 调试速查表.md
   ├─ MATLAB与聚变术语表.md
   └─ 学习进度检查表.md
```

### 目录设计原则

1. `chapters` 放可交互学习讲义，每章一个 `.mlx`。
2. `functions/+fusionlearn` 放可复用函数，使用 MATLAB package folder，避免函数名污染。
3. `examples` 放小而独立的演示脚本。
4. `projects` 放四个综合项目，每个项目有自己的脚本、说明和结果输出。
5. `data/simulated` 放可公开、可重复生成的小型模拟数据。
6. `data/external_paths` 只保存路径配置模板，不复制真实大数据。
7. `tests` 放验证函数正确性的测试脚本。
8. `docs` 放速查表、术语表和学习清单。

---

## 4. 数据路径与真实数据接入策略

### 4.1 外部真实数据

1. EFIT/gfile 原始目录：
   `<your external EFIT raw gfile directory>`

   初步观察到文件形如：
   `a013653.00042`、`a013653.00043` 等，单个文件约 5-6 KB。

2. 已读出的 EFIT `.mat` 目录：
   `<your external EFIT processed MAT directory>`

   初步观察到文件形如：
   `13653gdata_00042.mat`、`13653gdata_00043.mat` 等，单个文件约 300 KB。

3. DBS 原始数据：
   `<your external DBS MAT file>`

   文件约 732 MB，应按大文件处理。

### 4.2 数据使用原则

1. 前 6-8 章全部使用模拟数据，避免初学阶段被真实数据格式卡住。
2. 第 14 章开始接入 EFIT 数据，先读取已处理 `.mat`，再讨论 gfile 原始文本解析。
3. 第 19 章接入 DBS 数据，先用 `whos -file` 查看变量，再用 `matfile` 或分块读取。
4. 不把真实数据复制进学习库；公开仓库只保留 `data/external_paths/data_paths_template.m` 空模板，本机路径放入被 Git 忽略的 `data_paths_local.m`。
5. 所有真实数据读取函数都要有错误提示：路径不存在、变量名不匹配、数据维度不符合预期时给出清晰信息。
6. 所有项目都先提供模拟数据版本，再提供真实数据适配版本。

### 4.3 建议的数据路径配置函数

后续实现时创建：

```matlab
function paths = data_paths_template()
paths.efitRawDir = "";
paths.efitMatDir = "";
paths.dbsMatFile = "";
end
```

实际学习库中可另建 `data_paths_local.m`，由使用者按自己电脑路径修改。该文件已经加入 `.gitignore`，不应公开发布。

---

## 5. 8 周学习节奏

由于你选择 8 周、高投入路线，建议每周 10-14 小时，按“讲义学习、代码模仿、练习纠错、项目推进”四块分配。

| 周次 | 主线内容 | 目标产出 |
|---|---|---|
| 第 1 周 | Ch00-Ch02 | 熟悉 MATLAB 工作环境、Live Script、变量、数组、索引、基础语法 |
| 第 2 周 | Ch03-Ch05 | 会组织脚本函数，会画科研图，会做基础二维/三维可视化 |
| 第 3 周 | Ch06-Ch08 | 会读写数据，掌握矩阵计算、积分、微分、插值 |
| 第 4 周 | Ch09-Ch11 | 掌握 ODE、PDE 有限差分、拟合、优化、误差分析 |
| 第 5 周 | Ch12-Ch14 | 掌握 FFT、滤波、谱分析、相关分析、Tokamak 和 EFIT 基础 |
| 第 6 周 | Ch15-Ch16 | 掌握调试、测试、性能优化、Symbolic、Simulink、App Designer 入门 |
| 第 7 周 | Ch17-Ch18 | 完成实验数据预处理项目和平衡可视化项目 |
| 第 8 周 | Ch19 + 总复盘 | 完成 DBS 湍流谱分析和仿真调试验证项目，整理个人代码库 |

### 每周建议时间分配

1. 讲义阅读与运行：3-4 小时。
2. 模仿重写示例代码：2-3 小时。
3. 练习题与答案对照：2-3 小时。
4. 项目推进与调试记录：2-4 小时。
5. 英文术语复盘：每次学习后 10-15 分钟。

---

## 6. 每章 `.mlx` 标准模板

每一章 Live Script 都采用固定结构，降低学习负担：

1. 本章目标 / Learning Objectives
2. 前置知识 / Prerequisites
3. 中文概念解释
4. 英文关键词 / Key English Terms
5. 最小可运行例子 / Minimal Runnable Example
6. 科研场景例子 / Research-Oriented Example
7. 常错代码 / Common Mistakes
8. 动手练习 / Exercises
9. 参考答案 / Reference Solutions
10. 本章检查表 / Checklist
11. 延伸阅读 / Further Reading

每章练习数量：5-8 题。  
每章答案位置：同一 `.mlx` 中，放在练习之后，默认折叠或放在后半部分。  
每章英文量：关键词、变量命名、图标题、短句说明逐步增加，但主体讲解仍用中文。

---

## 7. 章节详细大纲

### Ch00 如何使用这套讲义

目标：

1. 说明学习路线、目录结构、运行方式。
2. 检查 MATLAB 版本和工具箱。
3. 创建学习日志和问题记录习惯。

核心内容：

1. `version`、`ver`、`license` 的使用。
2. Live Script 与普通 `.m` 脚本的区别。
3. 当前路径 Current Folder、工作区 Workspace、命令行 Command Window、编辑器 Editor。
4. 如何运行一节、运行整篇、清空变量、重启 MATLAB。
5. 学习库路径初始化：`startup_learning.m`。

英文术语：

`workspace`, `current folder`, `command window`, `editor`, `live script`, `section`, `toolbox`, `path`

练习：

1. 查看 MATLAB 版本。
2. 查看已安装工具箱。
3. 创建一个变量并在 Workspace 中观察。
4. 用 Live Script 写一段文本和一段代码。
5. 运行 `help plot` 与 `doc plot`。

---

### Ch01 MATLAB 界面与 Live Script 工作流

目标：

1. 熟悉 MATLAB 界面中常见按钮和面板。
2. 学会在 Live Script 中写说明、公式、代码和图。
3. 建立“边解释、边运行、边记录”的科研笔记习惯。

核心内容：

1. Home、Plots、Apps、Editor、Live Editor 常用按钮。
2. Run、Run Section、Run and Advance、Clear Output。
3. Workspace、Command History、Current Folder、Figure 窗口。
4. Live Script 中插入标题、文本、公式、图片、代码节。
5. 临时脚本和正式函数的区别。

示例：

1. 创建一个简单函数曲线。
2. 在同一 `.mlx` 中写说明、代码、图和观察结论。

练习：

1. 修改曲线参数并观察图形变化。
2. 使用分节运行。
3. 故意制造变量未定义错误并定位。
4. 导出 Live Script 为 PDF 或 HTML。
5. 使用 `doc` 查一个陌生函数。

---

### Ch02 变量、数组、索引与基础语法

目标：

1. 掌握 MATLAB 最核心的数组思维。
2. 学会基础语法、循环、判断、函数调用。
3. 理解 MATLAB 与其他语言的差异。

核心内容：

1. 数值、字符串、逻辑值、结构体、表格。
2. 向量、矩阵、多维数组。
3. 一维索引、二维索引、逻辑索引。
4. `for`、`while`、`if`、`switch`。
5. 元素运算：`.*`、`./`、`.^`。
6. 矩阵运算：`*`、`\`、`'`。
7. 函数句柄：`@(x)`。

科研例子：

1. 构造时间数组 `t`。
2. 构造模拟诊断信号 `signal = sin(...) + noise`。
3. 使用逻辑索引选取某个时间窗。

常错代码：

1. 忘记点乘导致矩阵维度错误。
2. 行向量和列向量混用。
3. 用 `=` 代替 `==`。
4. 数组越界。

练习：

1. 生成 0-2800 ms 的时间数组。
2. 创建一个带噪声的正弦信号。
3. 提取 1000-1500 ms 时间窗。
4. 用循环和向量化两种方式计算平方。
5. 将结果保存为结构体。

---

### Ch03 脚本、函数、路径与工程化组织

目标：

1. 知道什么时候写脚本，什么时候写函数。
2. 学会拆分代码，避免一个脚本越写越长。
3. 学会基本路径管理和 Git 思维。

核心内容：

1. Script 与 Function 的区别。
2. 输入参数、输出参数、局部变量。
3. `addpath`、`genpath`、`restoredefaultpath`。
4. MATLAB package folder：`+fusionlearn`。
5. 配置文件与数据路径分离。
6. 项目 README、命名规范、文件夹规范。
7. Git 基础：commit、diff、status、ignore。

工程规范：

1. 一个函数只做一件清晰的事。
2. 函数名使用动词 + 对象，例如 `readEfitMat`、`plotFluxSurface`。
3. 变量名尽量使用物理含义，例如 `time_ms`、`density_m3`、`psi_norm`。
4. 不在函数内部硬编码真实数据路径。
5. 重要计算写测试。

练习：

1. 把脚本中的信号生成代码改成函数。
2. 写一个路径配置函数。
3. 写一个绘图函数。
4. 用 `assert` 检查函数输出长度。
5. 写一个最小 README。

---

### Ch04 科研绘图基础与图形规范

目标：

1. 掌握 MATLAB 常用二维绘图。
2. 养成科研图的规范习惯。
3. 会导出适合报告和论文草稿的图。

核心内容：

1. `plot`、`scatter`、`errorbar`、`histogram`。
2. `xlabel`、`ylabel`、`title`、`legend`、`grid`。
3. `xlim`、`ylim`、`set(gca,...)`。
4. 多子图：`tiledlayout`、`nexttile`。
5. 图形导出：`exportgraphics`、`savefig`。
6. 颜色、线型、标记、字体大小。

科研规范：

1. 坐标轴必须有物理量和单位。
2. 图例必须能区分不同数据。
3. 标题不代替坐标轴标签。
4. 保存图时同时保存 `.png` 和 `.fig`。
5. 图片文件名包含变量、时间窗和处理方法。

练习：

1. 绘制模拟密度随时间变化。
2. 绘制带误差棒的温度剖面。
3. 用 `tiledlayout` 对比原始信号和滤波信号。
4. 导出 300 dpi 图。
5. 将绘图过程封装成函数。

---

### Ch05 二维、三维可视化与磁面图

目标：

1. 掌握 `contour`、`contourf`、`surf`、`imagesc`、`slice`。
2. 学会画二维场、等值线和基础三维图。
3. 为后续磁通面、平衡可视化做准备。

核心内容：

1. 网格生成：`meshgrid`、`ndgrid`。
2. 标量场可视化：`imagesc`、`contourf`。
3. 等值线：`contour`、`clabel`。
4. 三维曲面：`surf`、`mesh`。
5. 色图与色条：`colormap`、`colorbar`。
6. 坐标比例：`axis equal`、`axis tight`。

科研例子：

1. 构造二维磁通函数 `psi(R,Z)`。
2. 画模拟磁通面。
3. 叠加边界曲线和诊断位置。

练习：

1. 用 `meshgrid` 生成 R-Z 平面。
2. 画一个二维高斯场。
3. 画等值线并标注。
4. 用 `surf` 画三维曲面。
5. 保存磁面示意图。

---

### Ch06 数据读写与外部数据路径配置

目标：

1. 掌握常见数据格式读写。
2. 学会先检查数据，再处理数据。
3. 建立真实数据路径配置和数据安全习惯。

核心内容：

1. `.mat`：`save`、`load`、`whos -file`、`matfile`。
2. `.csv`：`readtable`、`writetable`、`readmatrix`。
3. `.txt`：`readlines`、`textscan`、`readmatrix`。
4. HDF5：`h5info`、`h5read`。
5. NetCDF：`ncinfo`、`ncread`。
6. 大文件读取策略。
7. 数据路径配置函数。

真实数据策略：

1. EFIT `.mat` 文件较小，可先用 `whos -file` 和 `load`。
2. DBS `.mat` 文件较大，应先用 `whos -file`，再判断是否可用 `matfile`。
3. 任何真实数据处理脚本都必须先打印变量名、尺寸、采样率或时间范围。

练习：

1. 保存并读取模拟信号。
2. 读取一个 CSV 表格。
3. 写一个 `checkMatFileInfo` 函数。
4. 用 `matfile` 读取大数组的一小段。
5. 写一个外部路径配置模板。

---

### Ch07 矩阵计算、线性方程、特征值与 SVD

目标：

1. 掌握计算物理中常见矩阵计算。
2. 理解线性方程、特征值、奇异值分解的基本用途。
3. 为有限差分、谱分析、数据降维做准备。

核心内容：

1. 矩阵创建、拼接、转置、逆与条件数。
2. 线性方程：`A\b`。
3. 特征值：`eig`。
4. 奇异值分解：`svd`。
5. 稀疏矩阵入门：`sparse`、`spdiags`。
6. 数值稳定性：避免显式求逆。

物理例子：

1. 离散二阶导数矩阵。
2. 弹簧振子耦合系统的本征模。
3. 用 SVD 去除模拟噪声。

练习：

1. 构造三对角矩阵。
2. 解一组线性方程。
3. 比较 `inv(A)*b` 和 `A\b`。
4. 计算特征值并解释稳定性。
5. 用 SVD 近似恢复低秩信号。

---

### Ch08 数值积分、微分、偏导与插值

目标：

1. 会用 MATLAB 实现常用计算物理中的积分和微分。
2. 理解数值误差、网格间距和边界处理。
3. 会处理一维和二维实验数据中的导数与插值。

核心内容：

1. 数值积分：`trapz`、`cumtrapz`、`integral`。
2. 数值微分：`diff`、`gradient`。
3. 有限差分：前向、后向、中心差分。
4. 偏导数：二维网格上的 `gradient(F,dR,dZ)`。
5. 插值：`interp1`、`interp2`、`griddedInterpolant`。
6. 网格分辨率和误差。

物理例子：

1. 对径向密度剖面积分。
2. 从温度剖面估计梯度尺度长度。
3. 在 R-Z 网格上计算磁通函数梯度。

练习：

1. 比较解析积分和 `trapz`。
2. 比较 `diff` 与 `gradient`。
3. 计算二维场的偏导。
4. 对不等间隔数据插值。
5. 分析网格变细后误差如何变化。

---

### Ch09 ODE 求解与聚变物理模型案例

目标：

1. 掌握 `ode45`、`ode15s` 的基本用法。
2. 理解初值问题、刚性问题、误差容限。
3. 用一个有物理背景的案例学习 ODE，而不是孤立学语法。

核心内容：

1. ODE 函数写法。
2. `ode45`、`ode15s`、`odeset`。
3. 初始条件、时间范围、参数传递。
4. 结果可视化和守恒量检查。
5. 简单刚性问题识别。

推荐物理案例：

1. 一维粒子在给定电场中的运动。
2. 简化 0D 粒子数平衡模型。
3. 简化能量约束时间模型。

主案例采用：

简化 0D 粒子数与能量演化模型：

```text
dn/dt = S - n/tau_p
dT/dt = P/(C*n) - T/tau_E
```

该模型不追求真实预测，而用于训练 ODE 建模、参数扫描和物理量检查。

练习：

1. 实现 ODE 右端函数。
2. 改变源项 `S` 观察密度变化。
3. 改变约束时间 `tau_E` 观察温度变化。
4. 用 `odeset` 调整误差容限。
5. 加入简单物理边界检查。

---

### Ch10 PDE 有限差分入门与输运模型

目标：

1. 理解一维 PDE 的离散思想。
2. 会实现简单扩散方程。
3. 为湍流输运和剖面演化做入门准备。

核心内容：

1. 一维扩散方程：
   `partial u / partial t = chi * partial^2 u / partial x^2`
2. 空间网格、时间步长、边界条件。
3. 显式格式和稳定性限制。
4. 隐式格式概念。
5. 用矩阵写有限差分。

物理例子：

1. 简化温度剖面扩散。
2. 比较不同输运系数 `chi`。
3. 观察边界条件对结果的影响。

练习：

1. 实现一维显式扩散。
2. 检查稳定性条件。
3. 用 `imagesc` 画时空演化。
4. 把循环版本改成矩阵版本。
5. 用测试检查总量变化。

---

### Ch11 拟合、优化、加权拟合与误差分析

目标：

1. 掌握实验数据处理中常用拟合方法。
2. 学会加权拟合和误差棒。
3. 理解残差、置信区间、过拟合和物理约束。

核心内容：

1. 多项式拟合：`polyfit`、`polyval`。
2. 非线性拟合：`lsqcurvefit`。
3. 优化：`fminsearch`、`fmincon`。
4. 加权最小二乘。
5. 残差分析。
6. 误差传播入门。

物理例子：

1. 拟合温度剖面。
2. 拟合指数衰减信号。
3. 对带误差棒的诊断数据做加权拟合。

练习：

1. 对模拟剖面做多项式拟合。
2. 写一个高斯拟合函数。
3. 加入测量误差作为权重。
4. 比较加权和不加权结果。
5. 画残差图。
6. 用 `assert` 检查拟合参数范围。

---

### Ch12 FFT、滤波、谱分析与相关分析

目标：

1. 掌握信号处理在聚变诊断数据中的基本用法。
2. 学会 FFT、功率谱、滤波、谱图、相关函数。
3. 为 DBS 数据处理和湍流分析做准备。

核心内容：

1. 采样率、Nyquist 频率、频率分辨率。
2. FFT：`fft`、`fftshift`。
3. 功率谱密度：`pwelch`。
4. 滤波：`designfilt`、`lowpass`、`bandpass`。
5. 时频分析：`spectrogram`。
6. 相关分析：`xcorr`。
7. 相干分析：`mscohere`。

物理例子：

1. 从模拟涨落信号识别主频。
2. 对带噪信号做带通滤波。
3. 估计两个探针信号的时间延迟。
4. 由相关时间和相关长度理解湍流尺度。

练习：

1. 生成多频率信号。
2. 画单边频谱。
3. 设计带通滤波器。
4. 计算自相关和互相关。
5. 用谱图观察频率随时间变化。

---

### Ch13 Tokamak 与等离子体物理入门

目标：

1. 建立后续代码所需的聚变物理背景。
2. 熟悉常见物理量、单位、坐标和数据命名。
3. 把物理概念和 MATLAB 变量联系起来。

核心内容：

1. Tokamak 基本结构。
2. 磁场：toroidal field、poloidal field。
3. 磁通面、归一化磁通 `psi_norm`。
4. 主要半径 `R0`、小半径 `a`、环向角、极向角。
5. 密度、温度、电流、压力、约束时间。
6. 单位与量纲：eV、keV、Tesla、Weber、m^-3、MW。
7. 常见诊断数据的时间窗和采样率。

英文术语：

`tokamak`, `plasma equilibrium`, `magnetic flux surface`, `toroidal field`, `poloidal field`, `density`, `temperature`, `current`, `pressure`, `transport`, `turbulence`

练习：

1. 写出常见变量名和单位。
2. 画一个 Tokamak 截面示意数据图。
3. 把 eV 转换为 Joule。
4. 计算简单 pressure profile。
5. 检查单位是否一致。

---

### Ch14 Grad-Shafranov 平衡与 EFIT 数据

目标：

1. 理解 Grad-Shafranov 方程的概念作用。
2. 会读取和可视化 EFIT 结果。
3. 从玩具模型过渡到真实 gfile/EFIT `.mat` 数据。

核心内容：

1. 平衡问题的物理意义。
2. Grad-Shafranov 方程的结构性认识。
3. EFIT/gfile 数据通常包含什么。
4. R-Z 网格、磁通 `psi`、归一化磁通 `psi_norm`。
5. LCFS、limiter、magnetic axis、boundary。
6. q profile、pressure profile、fpol 等常见量。

代码设计：

1. 先用模拟 `psi(R,Z)` 讲磁通面。
2. 再读取本地私有路径配置中的 EFIT `.mat` 文件。
3. 最后建立 gfile 文本解析器雏形。
4. 提供统一结构体：

```matlab
efit.shot
efit.time
efit.R
efit.Z
efit.psi
efit.psi_norm
efit.r_axis
efit.z_axis
efit.r_boundary
efit.z_boundary
efit.q_profile
efit.pressure
```

练习：

1. 读取一个 EFIT `.mat` 文件并查看变量。
2. 画 `psi(R,Z)` 等值线。
3. 标出 magnetic axis。
4. 叠加 plasma boundary。
5. 画 q profile。
6. 写一个 `normalizeEfitStruct` 函数。

---

### Ch15 调试、测试、性能优化、并行与 GPU 入门

目标：

1. 学会系统调试 MATLAB 程序。
2. 学会用测试保护计算结果。
3. 掌握科研脚本常见性能优化方法。
4. 认识并行和 GPU 的基本入口。

核心内容：

1. 断点、单步运行、查看变量。
2. `dbstop if error`。
3. 常见错误：维度不匹配、路径错误、变量覆盖、NaN/Inf。
4. `assert` 与 MATLAB Unit Test 入门。
5. 预分配：`zeros`、`nan`。
6. 向量化与循环比较。
7. `profile on`、`profile viewer`。
8. 并行：`parfor`。
9. GPU：`gpuArray`。

策略：

1. 主线代码必须能不用并行/GPU 运行。
2. 并行和 GPU 只作为加速选项。
3. 性能优化先用 `profile` 找瓶颈，再修改。

练习：

1. 调试一个故意写错的信号处理脚本。
2. 修复一个维度错误。
3. 用 `assert` 检查输出。
4. 对比循环和向量化耗时。
5. 用 `profile` 找最慢函数。

---

### Ch16 Symbolic Math、Simulink 与 App Designer 入门

目标：

1. 深入使用 Symbolic Math 辅助理解公式推导。
2. 认识 Simulink，不作为主线。
3. 用 App Designer 做一个小型数据查看工具。

核心内容：

1. 符号变量：`syms`。
2. 符号求导、积分、化简。
3. 从符号表达式生成函数：`matlabFunction`。
4. Simulink 基本概念：block、signal、scope。
5. App Designer 基本控件：按钮、坐标轴、文件选择。

小工具目标：

建立一个简易信号查看器：

1. 选择 `.mat` 文件。
2. 显示变量名。
3. 选择一个信号变量。
4. 画时间序列和频谱。

练习：

1. 用 Symbolic Math 推导有限差分误差项。
2. 把符号函数转成数值函数。
3. 打开并运行一个最小 Simulink 模型。
4. 用 App Designer 画一个信号浏览界面。
5. 给按钮回调函数加错误提示。

---

### Ch17 Project 1：聚变实验数据预处理

目标：

1. 把前面学到的数据读写、清洗、滤波、绘图组织成一个完整项目。
2. 建立从原始数据到处理结果的标准流程。

项目任务：

1. 使用模拟数据建立预处理 pipeline。
2. 支持读取 `.mat`、`.csv`、`.txt`。
3. 检查时间轴、采样率、缺失值、异常值。
4. 完成去均值、滤波、插值、归一化。
5. 输出处理后的数据和图。

建议函数：

```text
fusionlearn.io.checkMatFileInfo
fusionlearn.io.loadSignalData
fusionlearn.math.removeOutliersSimple
fusionlearn.math.resampleSignal
fusionlearn.plot.plotSignalOverview
```

验收标准：

1. 能用一条主脚本完成数据读取、处理、绘图、保存。
2. 每一步都有清晰变量名和单位。
3. 遇到路径错误能给出清楚提示。
4. 至少有 3 个 `assert` 检查。

---

### Ch18 Project 2：磁场与平衡可视化

目标：

1. 用模拟平衡和真实 EFIT 数据完成磁通面可视化。
2. 建立平衡数据读取、标准化、绘图的函数链。

项目任务：

1. 生成模拟 R-Z 网格和磁通函数。
2. 绘制模拟磁通面。
3. 读取本地 EFIT 处理结果目录中的一个时间片 `.mat`。
4. 统一数据结构。
5. 绘制真实磁通面、边界、磁轴、q profile。
6. 批处理多个时间片，输出图像序列。

建议函数：

```text
fusionlearn.efit.makeToyEquilibrium
fusionlearn.efit.readEfitMat
fusionlearn.efit.normalizeEfitStruct
fusionlearn.plot.plotFluxSurfaces
fusionlearn.plot.plotQProfile
```

验收标准：

1. 模拟数据版本无需真实数据即可运行。
2. 真实数据版本能从外部路径读取。
3. 图中有 R、Z 轴标签和单位。
4. LCFS、limiter 或 boundary 能清楚区分。
5. 批处理失败时能跳过坏文件并记录原因。

---

### Ch19 Project 3 与 Project 4：DBS 湍流谱分析与仿真调试验证

由于第 19 章是收束章，将两个项目组合到一个综合 Live Script 中，但项目文件夹仍分开保存。

## Project 3：DBS 湍流谱分析

目标：

1. 使用模拟 DBS 信号掌握湍流谱分析流程。
2. 在内存安全前提下尝试读取真实 DBS `.mat` 数据。
3. 输出频谱、谱图、相关函数和基础湍流指标。

真实数据路径：

通过本地私有 `data_paths_local.m` 配置，不写入公开仓库。

大文件策略：

1. 先运行 `whos -file` 查看变量。
2. 若文件支持 `matfile`，优先分块读取。
3. 每次只处理短时间窗，例如 10-50 ms。
4. 不在内存中复制多个完整大数组。
5. 先保存小样本到 `data/small_samples` 供教学复现。

分析内容：

1. 去均值和去趋势。
2. 带通滤波。
3. FFT 和功率谱。
4. Spectrogram。
5. 自相关和互相关。
6. 相关时间、主频、带宽等基础指标。

建议函数：

```text
fusionlearn.dbs.inspectDbsMatFile
fusionlearn.dbs.loadDbsTimeWindow
fusionlearn.dbs.preprocessDbsSignal
fusionlearn.dbs.computePowerSpectrum
fusionlearn.dbs.computeCorrelationMetrics
fusionlearn.plot.plotSpectrumOverview
```

## Project 4：仿真程序调试与验证

目标：

1. 学会面对一段“能跑但不一定对”的仿真程序。
2. 使用调试、测试、守恒检查、误差分析、性能分析改进代码。

项目任务：

1. 给出一个含错误的简化输运仿真程序。
2. 学生先运行并观察异常结果。
3. 使用断点定位错误。
4. 修复单位错误、边界条件错误、数组维度错误。
5. 添加测试和守恒量检查。
6. 用 `profile` 分析性能瓶颈。

验收标准：

1. 修复前后结果有对比图。
2. 至少 3 个错误被定位并解释。
3. 至少 5 个测试或断言通过。
4. 代码结构从单脚本整理为主脚本 + 函数。

---

## 8. 函数库模块规划

### 8.1 `fusionlearn.io`

用途：文件读取、路径检查、数据摘要。

建议函数：

```text
checkPathExists
checkMatFileInfo
loadMatVariable
readNumericTextFile
readCsvTable
saveProcessedData
```

学习重点：

1. 输入检查。
2. 错误提示。
3. 大文件变量摘要。
4. 数据和代码解耦。

### 8.2 `fusionlearn.math`

用途：计算物理基础方法。

建议函数：

```text
centralDifference1D
gradient2DUniform
trapzWithUnits
weightedLeastSquares
makeSecondDerivativeMatrix
solveDiffusion1DExplicit
```

学习重点：

1. 数值方法和解析解对比。
2. 网格间距。
3. 误差估计。
4. 单元测试。

### 8.3 `fusionlearn.plot`

用途：科研绘图模板。

建议函数：

```text
applyResearchStyle
plotSignalOverview
plotProfileWithError
plotFluxSurfaces
plotQProfile
plotSpectrumOverview
exportFigureSet
```

学习重点：

1. 统一字体和线宽。
2. 坐标轴单位。
3. 图像导出。
4. 多子图布局。

### 8.4 `fusionlearn.plasma`

用途：等离子体基础量计算。

建议函数：

```text
eVToJoule
keVToJoule
computePressure
computeGradientScaleLength
computeBetaSimple
```

学习重点：

1. 单位转换。
2. 物理量命名。
3. 量纲检查。

### 8.5 `fusionlearn.efit`

用途：平衡数据和磁通面。

建议函数：

```text
makeToyEquilibrium
readEfitMat
normalizeEfitStruct
parseGFileBasic
computePsiNorm
extractFluxSurface
```

学习重点：

1. EFIT 数据结构。
2. R-Z 网格。
3. 磁通归一化。
4. 边界和磁轴可视化。

### 8.6 `fusionlearn.dbs`

用途：DBS 信号预处理和谱分析。

建议函数：

```text
inspectDbsMatFile
loadDbsTimeWindow
preprocessDbsSignal
computePowerSpectrum
computeSpectrogram
computeCorrelationMetrics
```

学习重点：

1. 大 `.mat` 文件读取。
2. 时间窗选择。
3. FFT、滤波、相关。
4. 结果物理解释。

### 8.7 `fusionlearn.debug`

用途：教学用错误案例和验证工具。

建议函数：

```text
introduceDimensionBug
introduceUnitBug
checkFiniteValues
checkMonotonicTime
compareSimulationResults
```

学习重点：

1. 常见错误定位。
2. 输入输出检查。
3. 可复现调试案例。

---

## 9. 每章练习与答案设计

每章 5-8 道练习，分为四类：

1. 基础模仿题：照着示例改参数。
2. 代码填空题：补全关键一两行。
3. 错误修复题：读报错、定位、改正。
4. 小研究题：把结果画出来并写一句解释。

答案放在同一个 `.mlx` 后半部分，结构如下：

```text
练习区
1. 题目
2. 你的代码区域
3. 思考问题

答案区
1. 参考代码
2. 为什么这样写
3. 常见错误
4. 如何自检
```

推荐每章检查表：

```text
[ ] 我能独立运行本章所有代码
[ ] 我能解释 5 个核心英文术语
[ ] 我能不看答案完成至少 60% 练习
[ ] 我知道本章最常见的 2 个错误
[ ] 我能把本章一个函数改成自己的版本
```

---

## 10. 英文能力融入方式

你希望提升科研英文能力，因此讲义中不只出现术语翻译，还要逐步训练英文表达。

### 10.1 每章固定英文内容

1. 关键词：`Key Terms`
2. 一句话目标：`In this chapter, you will learn to...`
3. 图标题英文版。
4. 变量命名使用英文。
5. 每章 3-5 句科研表达模板。

### 10.2 示例表达

```text
The signal is filtered using a band-pass filter.
The power spectrum shows a dominant peak near 50 kHz.
The equilibrium flux surfaces are plotted in the R-Z plane.
The numerical derivative becomes noisy when the grid is too coarse.
The fitted curve agrees with the data within the estimated uncertainty.
```

### 10.3 术语表分类

1. MATLAB 操作术语。
2. 数值计算术语。
3. 信号处理术语。
4. Tokamak 和平衡术语。
5. 湍流输运术语。
6. 调试和工程术语。

---

## 11. 工具箱与版本兼容策略

由于 MATLAB 版本未知，后续讲义必须采用“基础可运行 + 工具箱增强”的设计。

### 11.1 必须支持

1. Base MATLAB。
2. Live Script。
3. 常见绘图、矩阵、基础数据读写。

### 11.2 推荐工具箱

1. Signal Processing Toolbox：用于 `pwelch`、`spectrogram`、滤波器设计。
2. Optimization Toolbox：用于 `lsqcurvefit`、`fmincon`。
3. Symbolic Math Toolbox：用于公式推导和符号计算。
4. Parallel Computing Toolbox：用于 `parfor`、`gpuArray`。
5. Simulink：只做认识和简单示例。

### 11.3 兼容原则

1. 每个工具箱函数都提供替代方案或说明。
2. 如果没有 Signal Processing Toolbox，则使用基础 FFT 和手写简单滤波示例。
3. 如果没有 Optimization Toolbox，则使用 `fminsearch` 作为基础替代。
4. 如果没有 Symbolic Math Toolbox，则保留数值推导版本。
5. 如果没有 Parallel Computing Toolbox，则所有代码仍可串行运行。

---

## 12. 项目验收标准

完成 8 周学习后，建议用以下标准判断是否达到阶段目标。

### 12.1 MATLAB 能力

1. 能独立创建 `.mlx` 和 `.m` 文件。
2. 能写函数并传入/返回参数。
3. 能使用 `plot`、`tiledlayout`、`contourf`、`surf`。
4. 能读写 `.mat`、`.csv`、`.txt`。
5. 能使用 `help`、`doc` 和报错信息自查。

### 12.2 数值计算能力

1. 能实现并解释数值积分。
2. 能实现并解释数值微分和有限差分。
3. 能解简单 ODE。
4. 能实现一维扩散 PDE 入门模型。
5. 能做线性方程、特征值、SVD。
6. 能做拟合、加权拟合和残差分析。

### 12.3 聚变数据能力

1. 能从模拟数据开始搭建处理 pipeline。
2. 能读取并检查 EFIT `.mat` 文件。
3. 能画 R-Z 平面磁通面。
4. 能读取 DBS 文件中的小时间窗。
5. 能画 FFT、功率谱、谱图和相关函数。

### 12.4 工程能力

1. 能把长脚本拆成函数。
2. 能使用路径配置，不硬编码真实数据。
3. 能写基本测试和断言。
4. 能使用 debugger 定位错误。
5. 能用 `profile` 判断性能瓶颈。
6. 能用 Git 保存学习进度。

---

## 13. 常见风险与规避方案

| 风险 | 表现 | 规避方案 |
|---|---|---|
| 直接上真实数据导致卡住 | 变量名、维度、单位不清楚 | 先模拟数据，再真实数据 |
| 只会运行不会理解 | 看代码能跑，但不会改 | 每章必须有模仿改写练习 |
| 数学和代码脱节 | 会公式但不会实现 | 每个数学概念都配 MATLAB 实现 |
| 脚本越写越乱 | 文件名混乱、路径硬编码 | 第 3 章提前讲工程化组织 |
| 大文件爆内存 | DBS `.mat` 太大 | 使用 `whos -file`、`matfile`、时间窗 |
| 绘图不规范 | 没单位、没图例、难复现 | 第 4 章建立绘图模板 |
| 工具箱缺失 | 示例函数不可用 | 基础版本 + 工具箱增强版本 |
| 物理概念压倒编程 | 学太多理论但不会写代码 | 物理只讲服务代码的最小必要背景 |
| 过早追求复杂仿真 | 调试困难、挫败感高 | 先玩具模型，再真实模块 |

---

## 14. 后续实施顺序

如果后续开始真正生成学习库，建议按以下顺序实施：

1. 创建目录结构、README、数据路径模板、启动脚本。
2. 创建 `docs` 中的术语表、速查表、学习进度检查表初版。
3. 创建 Ch00-Ch03，先打通学习库使用方式和工程结构。
4. 创建 `fusionlearn.plot`、`fusionlearn.io`、`fusionlearn.math` 的最小函数集。
5. 创建 Ch04-Ch08，完成绘图、数据、矩阵、积分微分主线。
6. 创建 Ch09-Ch12，完成 ODE、PDE、拟合、信号处理主线。
7. 创建 Ch13-Ch14，接入 Tokamak、EFIT、Grad-Shafranov 主题。
8. 创建 Ch15-Ch16，补齐调试、测试、性能、Symbolic、Simulink、App Designer。
9. 创建 Ch17-Ch19 四个项目。
10. 补充测试、检查表、答案区和最终总复盘。

---

## 15. 最终交付物清单

后续完整建设完成后，应包含：

1. 20 个 `.mlx` 章节讲义。
2. 每章 5-8 个练习和同章参考答案。
3. 一个可复用 MATLAB 函数库：`+fusionlearn`。
4. 四个综合项目。
5. 模拟数据生成脚本。
6. 外部真实数据路径模板。
7. 测试脚本和 `run_all_tests.m`。
8. MATLAB 函数速查表。
9. 科研绘图速查表。
10. 调试速查表。
11. MATLAB 与聚变术语表。
12. 每章学习检查表。
13. Git 与工程化脚本管理说明。

---

## 16. 建议的第一阶段实施目标

为了避免一开始工程量过大，建议第一阶段先做一个可运行最小版本：

1. 创建目录结构。
2. 完成 Ch00-Ch03。
3. 完成 `startup_learning.m`。
4. 完成 `data_paths_template.m`。
5. 完成基础函数：
   `checkPathExists`、`checkMatFileInfo`、`applyResearchStyle`、`centralDifference1D`。
6. 完成一个模拟信号数据集。
7. 完成一个最小测试脚本。

第一阶段完成后，就已经具备“打开讲义、运行示例、修改代码、学习工程结构”的基本体验。之后再逐章扩展到计算物理、EFIT、DBS 和项目案例。

---

## 17. 本计划的核心原则

1. 小步递进，但目标始终指向真实科研任务。
2. 每个数学概念必须有代码实现。
3. 每个代码实现必须有图、测试或物理解释之一。
4. 每个真实数据流程必须先有模拟数据版本。
5. 每个项目都要从“能跑”走向“可读、可改、可验证”。
6. 中文理解为主，英文术语和表达持续渗透。
7. 不急着写复杂大程序，先建立可靠的小模块。
