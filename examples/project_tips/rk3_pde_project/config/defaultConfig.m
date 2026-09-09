function cfg = defaultConfig()
%DEFAULTCONFIG Return parameters for the RK3 advection-diffusion example.

cfg.domainLength_m = 1.0;
cfg.nCells = 160;
cfg.advectionSpeed_mps = 0.45;
cfg.diffusivity_m2ps = 0.003;
cfg.finalTime_s = 0.8;
cfg.cflSafety = 0.75;

cfg.initialCenter_m = 0.30;
cfg.initialWidth_m = 0.07;

cfg.saveFigure = false;
cfg.outputFileName = "rk3_advection_diffusion.png";
end
