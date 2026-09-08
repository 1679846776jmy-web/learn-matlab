%CONVERT_CHAPTERS_TO_MLX Convert chapter source scripts to MATLAB live scripts.
%
% Run from the learning library root:
%
%   startup_learning
%   run("tools/convert_chapters_to_mlx.m")
%
% By default, this script does not overwrite existing .mlx files. The final
% teaching files in chapters/ may contain user-authored learning notes and
% should be treated as the canonical co-created lectures. Set the following
% flag to true only when you intentionally want to regenerate outputs after
% preserving or merging those notes.

overwriteExisting = false;

rootDir = fileparts(fileparts(mfilename("fullpath")));
srcDir = fullfile(rootDir, "chapters_src");
dstDir = fullfile(rootDir, "chapters");

if ~isfolder(dstDir)
    mkdir(dstDir);
end

chapterMap = {
    "Ch00_HowToUseThisCourse.m", "Ch00_如何使用这套讲义_完结版.mlx"
    "Ch01_MATLABInterfaceAndLiveScript.m", "Ch01_MATLAB界面与LiveScript工作流_完结版.mlx"
    "Ch02_VariablesArraysIndexingSyntax.m", "Ch02_变量数组索引与基础语法_完结版.mlx"
    "Ch03_ScriptsFunctionsPathProjectStructure.m", "Ch03_脚本函数路径与工程化组织_完结版.mlx"
    "Ch04_ResearchPlottingBasics.m", "Ch04_科研绘图基础与图形规范_完结版.mlx"
    "Ch05_2D3DVisualizationFluxSurfaces.m", "Ch05_二维三维可视化与磁面图_完结版.mlx"
    "Ch06_DataIOAndExternalPaths.m", "Ch06_数据读写与外部数据路径配置_完结版.mlx"
    "Ch07_MatrixComputingLinearAlgebra.m", "Ch07_矩阵计算线性方程特征值与SVD_完结版.mlx"
    "Ch08_IntegrationDifferentiationInterpolation.m", "Ch08_数值积分微分偏导与插值_完结版.mlx"
    "Ch09_ODEPhysicalModelCases.m", "Ch09_ODE求解与物理模型案例_完结版.mlx"
    "Ch10_PDEFiniteDifferenceTransport.m", "Ch10_PDE有限差分入门与一维输运模型_完结版.mlx"
};

for k = 1:size(chapterMap, 1)
    sourceFile = char(fullfile(srcDir, chapterMap{k, 1}));
    destinationFile = char(fullfile(dstDir, chapterMap{k, 2}));

    if ~isfile(sourceFile)
        error("Missing chapter source: %s", sourceFile);
    end

    if isfile(destinationFile) && ~overwriteExisting
        fprintf("Skipping existing file: %s\n", chapterMap{k, 2});
        continue;
    end

    fprintf("Converting %s -> %s\n", chapterMap{k, 1}, chapterMap{k, 2});
    matlab.internal.liveeditor.openAndSave(sourceFile, destinationFile);
end

fprintf("Converted %d chapter files.\n", size(chapterMap, 1));
