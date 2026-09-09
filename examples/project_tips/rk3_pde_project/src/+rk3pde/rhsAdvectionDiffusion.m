function dudt = rhsAdvectionDiffusion(u, dx_m, cfg)
%RHSADVECTIONDIFFUSION Evaluate the periodic semi-discrete PDE right side.

arguments
    u (:,1) double
    dx_m (1,1) double {mustBePositive}
    cfg struct
end

uLeft = circshift(u, 1);
uRight = circshift(u, -1);

speed_mps = cfg.advectionSpeed_mps;
if speed_mps >= 0
    advectionDerivative = (u - uLeft) / dx_m;
else
    advectionDerivative = (uRight - u) / dx_m;
end

diffusionDerivative = (uRight - 2*u + uLeft) / dx_m^2;
dudt = -speed_mps * advectionDerivative ...
    + cfg.diffusivity_m2ps * diffusionDerivative;
end
