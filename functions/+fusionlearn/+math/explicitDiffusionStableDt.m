function dtStable = explicitDiffusionStableDt(dx, diffusivity, safetyFactor)
%EXPLICITDIFFUSIONSTABLEDT Estimate stable dt for explicit 1-D diffusion.
%
% For du/dt = chi*d2u/dx2 on a uniform grid, the basic explicit Euler
% stability condition is chi*dt/dx^2 <= 1/2.

arguments
    dx (1,1) double {mustBePositive}
    diffusivity (1,1) double {mustBePositive}
    safetyFactor (1,1) double {mustBePositive} = 0.8
end

if safetyFactor > 1
    error("fusionlearn:SafetyFactorTooLarge", ...
        "safetyFactor should be <= 1 for the explicit diffusion estimate.");
end

dtStable = safetyFactor * dx^2 / (2 * diffusivity);
end
