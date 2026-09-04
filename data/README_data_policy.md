# 数据目录说明

本学习库默认只保存小型模拟数据和可公开复现的示例数据。

真实 EFIT、DBS 或其他实验数据不要复制到本目录中，而应通过路径配置读取。

推荐做法：

1. 在 `data/external_paths/data_paths_template.m` 查看路径格式。
2. 如果要使用自己的路径，复制一份为 `data_paths_local.m`。
3. 在 `data_paths_local.m` 中填写本机真实数据路径。
4. 不要把 `data_paths_local.m` 提交到 Git。

DBS 大文件读取时，先使用：

```matlab
whos("-file", filePath)
```

再决定是否使用：

```matlab
m = matfile(filePath);
```

避免一次性加载完整大文件。

