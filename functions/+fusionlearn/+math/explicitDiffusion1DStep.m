function [uNext, stabilityNumber] = explicitDiffusion1DStep(u, dx, dt, diffusivity, boundaryValue)
%EXPLICITDIFFUSION1DSTEP Advance one explicit Euler step for 1-D diffusion.
%
% The equation is du/dt = chi*d2u/dx2 on a uniform grid with fixed boundary
% values. This teaching helper uses Dirichlet boundary values at both ends.

arguments
    u (:,1) double
    dx (1,1) double {mustBePositive}
    dt (1,1) double {mustBePositive}
    diffusivity (1,1) double {mustBePositive}
    boundaryValue (1,1) double = 0
end

if numel(u) < 3
    error("fusionlearn:NotEnoughPoints", ...
        "At least three grid points are required for 1-D diffusion.");
end

stabilityNumber = diffusivity * dt / dx^2;
if stabilityNumber > 0.5
    error("fusionlearn:UnstableTimeStep", ...
        "Explicit diffusion requires diffusivity*dt/dx^2 <= 0.5.");
end

uNext = u;
uNext(2:end-1) = u(2:end-1) + stabilityNumber * ...
    (u(3:end) - 2*u(2:end-1) + u(1:end-2));
uNext(1) = boundaryValue;
uNext(end) = boundaryValue;
end
