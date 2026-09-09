# 三阶 Runge-Kutta 一维对流扩散小项目

这是 Ch11 使用的通用工程布局示例。它求解周期边界条件下的一维对流扩散方程：

```text
du/dt + c du/dx = chi d2u/dx2
```

空间离散使用一阶迎风格式和二阶中心差分，时间推进使用三阶 SSP Runge-Kutta 方法。这个项目的重点是学习文件职责和调用关系，不用于高精度物理预测。

```text
rk3_pde_project/
├─ main_run_case.m           入口脚本：组织完整计算流程
├─ config/defaultConfig.m    参数配置：集中保存网格、物理量和输出设置
├─ src/+rk3pde/              算法函数：用 package 避免命名冲突
├─ tests/test_rk3_project.m  项目自己的快速验证
└─ outputs/                  运行结果目录，自动创建且不提交生成文件
```

在 MATLAB 中打开本目录并运行：

```matlab
run("main_run_case.m")
run("tests/test_rk3_project.m")
```

建议先只修改 `defaultConfig.m` 中的一项参数，例如 `advectionSpeed_mps` 或 `diffusivity_m2ps`，再比较结果。
