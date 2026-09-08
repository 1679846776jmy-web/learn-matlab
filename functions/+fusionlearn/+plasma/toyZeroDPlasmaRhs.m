function dydt = toyZeroDPlasmaRhs(t, y, params)
%TOYZERODPLASMARHS Right-hand side for a teaching zero-dimensional plasma model.
%
% State vector:
%   y(1) = normalized density in 1e20 m^-3
%   y(2) = electron temperature in keV
%
% The model is deliberately simple. It is useful for learning ode45,
% parameter scans, and sanity checks; it is not a predictive plasma model.

arguments
    t (1,1) double
    y (:,1) double
    params (1,1) struct
end

if numel(y) ~= 2
    error("fusionlearn:StateSize", "State y must contain [density20; Te_keV].");
end

requiredFields = [
    "nTarget20"
    "tauParticle_s"
    "edgeTe_keV"
    "heatingGain_keV"
    "heatingRamp_s"
    "tauEnergy_s"
    "radiationCoeff_per_s"
    "densityFloor20"
];

for k = 1:numel(requiredFields)
    if ~isfield(params, char(requiredFields(k)))
        error("fusionlearn:MissingParameter", ...
            "Missing parameter field: %s", requiredFields(k));
    end
end

n20 = max(y(1), params.densityFloor20);
Te_keV = y(2);

dn20_dt = (params.nTarget20 - n20) / params.tauParticle_s;

driveTe_keV = params.edgeTe_keV + ...
    params.heatingGain_keV * (1 - exp(-t / params.heatingRamp_s));
radiationLoss_keV_per_s = params.radiationCoeff_per_s * n20 * ...
    max(Te_keV - params.edgeTe_keV, 0);
dTe_dt = (driveTe_keV - Te_keV) / params.tauEnergy_s - radiationLoss_keV_per_s;

dydt = [dn20_dt; dTe_dt];
end
