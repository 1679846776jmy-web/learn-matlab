# MATLAB 聚变数据处理学习库

这是一个面向 MATLAB 初学者的可运行讲义项目，主题聚焦于聚变数据处理、等离子体平衡入门、湍流输运分析基础和仿真程序调试前置能力。

项目中的 `.mlx` Live Script 可以直接在 MATLAB 中阅读、运行和修改；配套 `.m` 脚本、函数库、示例和测试用于练习、复现和检查代码是否正确。

## 适合谁使用

本项目适合：

1. MATLAB 零基础或基础薄弱的学习者。
2. 希望把 MATLAB 用到科研绘图、数据读写、矩阵计算和计算物理中的学习者。
3. 准备进一步学习 EFIT 平衡数据处理、DBS 湍流分析或聚变仿真调试的人。

不需要一开始就懂等离子体物理。前几章会从界面、语法、绘图和文件组织开始。

## 快速开始

1. 克隆或下载本仓库。
2. 打开 MATLAB。
3. 将 MATLAB 的 Current Folder 切换到仓库根目录。
4. 在 Command Window 中运行：

```matlab
startup_learning
```

5. 打开 `chapters` 文件夹，从下面这份讲义开始学习：

```text
Ch00_如何使用这套讲义_完结版.mlx
```

建议在 MATLAB Live Editor 中打开 `.mlx`，逐节运行、修改参数、观察变量和图形变化。

## 当前章节

| 章节 | 主题 |
|---|---|
| Ch00 | 如何使用这套讲义 |
| Ch01 | MATLAB 界面与 Live Script 工作流 |
| Ch02 | 变量、数组、索引与基础语法 |
| Ch03 | 脚本、函数、路径与工程化组织 |
| Ch04 | 科研绘图基础与图形规范 |
| Ch05 | 二维、三维可视化与磁面图 |
| Ch06 | 数据读写与外部数据路径配置 |
| Ch07 | 矩阵计算、线性方程、特征值与 SVD |
| Ch08 | 数值积分、微分、偏导与插值 |
| Ch09 | ODE 求解与物理模型案例 |
| Ch10 | PDE 有限差分入门与一维输运模型 |

## 目录说明

```text
chapters/       MATLAB Live Script 讲义，每章一个 _完结版.mlx
chapters_src/   讲义对应的 .m 源脚本，便于搜索、版本管理和重新生成
functions/      可复用函数库，包名为 fusionlearn
examples/       独立示例脚本
tests/          自动检查脚本
data/           数据说明、路径模板和小型可复现示例数据
docs/           面向学习者的速查表、术语表和学习检查表
projects/       后续实践项目入口
tools/          辅助工具脚本
```

## 建议学习方式

1. 每章先通读“本章目标”和关键词。
2. 从上到下逐节运行 `.mlx`。
3. 每次只修改一个参数，观察 Workspace、图窗和输出变化。
4. 独立完成练习，再看参考答案。
5. 把自己的理解、错题和改写直接写在本地 `.mlx` 中。

如果命令行环境无法直接 `run` 中文文件名的 `.mlx`，请优先在 Live Editor 中打开运行；也可以运行 `chapters_src` 中对应的 `.m` 源脚本。

## 运行测试

在仓库根目录运行：

```matlab
startup_learning
run("tests/run_all_tests.m")
```

当前测试覆盖基础数据结构、文件读写、绘图函数、矩阵差分、积分/插值、ODE 和一维扩散 PDE 入门函数。

## 运行示例

示例脚本位于 `examples`：

```text
examples/basic_syntax/
examples/plotting/
examples/data_io/
examples/numerical_methods/
```

示例脚本会自动定位仓库根目录并初始化路径，可以从 MATLAB 中直接运行。

## 真实数据说明

本仓库不包含真实 EFIT、DBS 或其他私有实验数据。真实数据应保存在仓库外部，通过本地路径配置读取。

推荐流程：

1. 查看 `data/external_paths/data_paths_template.m`。
2. 复制一份为 `data/external_paths/data_paths_local.m`。
3. 在 `data_paths_local.m` 中填写本机真实数据路径。
4. 不要把 `data_paths_local.m`、真实实验数据、大型输出文件或自动保存文件提交到 Git。

## 公开使用注意

可以公开提交的内容通常包括讲义、示例代码、通用函数、公开小样本数据和说明文档。

不要提交：

1. 本机真实数据路径。
2. 未公开的 EFIT、DBS 或其他实验数据。
3. API key、token、账号信息或私有密钥。
4. MATLAB 自动保存文件，例如 `.asv`。
5. 大型运行输出和临时结果。
