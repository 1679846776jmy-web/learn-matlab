function uNext = stepSSPRK3(u, dt_s, rhsFunction)
%STEPSSPRK3 Advance one step with the third-order SSP Runge-Kutta method.

arguments
    u (:,1) double
    dt_s (1,1) double {mustBePositive}
    rhsFunction (1,1) function_handle
end

uStage1 = u + dt_s * rhsFunction(u);
uStage2 = (3/4)*u + (1/4)*(uStage1 + dt_s*rhsFunction(uStage1));
uNext = (1/3)*u + (2/3)*(uStage2 + dt_s*rhsFunction(uStage2));
end
