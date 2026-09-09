function dt_s = stableTimeStep(dx_m, cfg)
%STABLETIMESTEP Estimate a conservative explicit time step.

arguments
    dx_m (1,1) double {mustBePositive}
    cfg struct
end

if cfg.advectionSpeed_mps == 0
    advectionLimit_s = inf;
else
    advectionLimit_s = dx_m / abs(cfg.advectionSpeed_mps);
end

if cfg.diffusivity_m2ps == 0
    diffusionLimit_s = inf;
else
    diffusionLimit_s = dx_m^2 / (2 * cfg.diffusivity_m2ps);
end

dt_s = cfg.cflSafety * min(advectionLimit_s, diffusionLimit_s);
if ~isfinite(dt_s)
    error("rk3pde:NoDynamics", ...
        "At least one of advection speed and diffusivity must be nonzero.");
end
end
