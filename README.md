# MATLAB 聚变数据处理学习库

这是一个面向聚变数据处理、等离子体平衡、湍流输运分析和仿真程序调试的 MATLAB 学习库。

你可以把它当成一套可以运行、可以修改、可以模仿的 MATLAB 讲义。学习材料会逐步分三阶段完成：

1. 第一阶段：基础界面、Live Script、基础语法、绘图、数据读写和脚本工程化。
2. 第二阶段：计算物理、数值方法、信号处理、调试、测试和性能优化。
3. 第三阶段：EFIT 平衡数据、DBS 湍流分析和仿真程序调试项目。

## 如何开始

1. 打开 MATLAB。
2. 将 Current Folder 切换到本文件所在目录。
3. 在 Command Window 中运行：

```matlab
startup_learning
```

4. 打开 `chapters` 文件夹中的 `.mlx` 讲义，从 `Ch00_如何使用这套讲义.mlx` 开始。

## 第一批已完成内容

当前已交付第一阶段启动版，并开始补充加厚版和阶段 2 起步版：

1. 阶段拆分计划：`三阶段小计划.md`
2. 总学习计划：`MATLAB聚变数据处理学习计划.md`
3. 启动脚本：`startup_learning.m`
4. 第一阶段原版 Live Script：`chapters/Ch00` 到 `Ch06`
5. 第一阶段加厚版 Live Script：`chapters/Ch00` 到 `Ch06` 的 `_加厚版`
6. 阶段 2 起步 Live Script：`Ch07` 和 `Ch08`
7. 基础函数库：`functions/+fusionlearn`
8. 数据路径模板：`data/external_paths/data_paths_template.m`
9. 基础测试：`tests/run_all_tests.m`

## 学习建议

每章建议按下面顺序学习：

1. 先通读本章目标和关键词。
2. 从上到下运行 `.mlx` 中的每一节。
3. 修改示例中的参数，观察输出变化。
4. 独立完成练习，再看参考答案。
5. 把不理解的问题写进自己的学习日志。

如果你已经在原版 `.mlx` 中写了自己的笔记，请继续保留它们。后续新增内容会尽量放到新的讲义文件或源脚本中，避免覆盖个人学习记录。

## 真实数据说明

真实 EFIT 和 DBS 数据不复制进本学习库，只通过路径配置读取。这样可以避免误删、误改或把大文件混入代码目录。

默认外部路径模板在：

```text
data/external_paths/data_paths_template.m
```

如果后续用 Git 管理学习库，请不要提交自己的本地私有数据文件。
