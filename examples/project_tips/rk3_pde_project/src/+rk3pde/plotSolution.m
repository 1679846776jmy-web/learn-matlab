function fig = plotSolution(x_m, uInitial, uFinal, finalTime_s)
%PLOTSOLUTION Compare the initial and final profiles.

fig = figure("Color", "w");
plot(x_m, uInitial, "--", "LineWidth", 1.3);
hold on;
plot(x_m, uFinal, "LineWidth", 1.6);
xlabel("x (m)");
ylabel("u (a.u.)");
title(sprintf("RK3 advection-diffusion result at t = %.3f s", finalTime_s));
legend("Initial", "Final", "Location", "best");
grid on;
end
