function [x_m, dx_m] = buildGrid(cfg)
%BUILDGRID Build a cell-centered periodic one-dimensional grid.

arguments
    cfg struct
end

validateattributes(cfg.domainLength_m, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'positive'});
validateattributes(cfg.nCells, {'numeric'}, ...
    {'scalar', 'integer', '>=', 8});

dx_m = cfg.domainLength_m / cfg.nCells;
x_m = ((0:cfg.nCells-1).' + 0.5) * dx_m;
end
