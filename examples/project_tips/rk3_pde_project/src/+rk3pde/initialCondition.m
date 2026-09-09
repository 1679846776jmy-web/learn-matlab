function u0 = initialCondition(x_m, cfg)
%INITIALCONDITION Build a periodic Gaussian-like initial profile.

arguments
    x_m (:,1) double
    cfg struct
end

distance_m = abs(x_m - cfg.initialCenter_m);
periodicDistance_m = min(distance_m, cfg.domainLength_m - distance_m);
u0 = exp(-(periodicDistance_m / cfg.initialWidth_m).^2);
end
