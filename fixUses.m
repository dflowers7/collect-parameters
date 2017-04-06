function [UseParams, UseSeeds, UseInputControls, UseDoseControls] = fixUses(m, con, UseParams, UseSeeds, UseInputControls, UseDoseControls)
% [UseParams, UseSeeds, UseInputControls, UseDoseControls] = fixUses(m, con, UseParams, UseSeeds, UseInputControls, UseDoseControls)
% Standardizes the Use* options as logical arrays.

nk = m.nk;
ns = m.ns;
ncon = numel(con);
nq_icon = [con.nq];
nh_icon = [con.nh];

UseParams = fixUseParams(UseParams, nk);
UseSeeds = fixUseSeeds(UseSeeds, ns, ncon);
UseInputControls = fixUseControls(UseInputControls, ncon, nq_icon);
UseDoseControls = fixUseControls(UseDoseControls, ncon, nh_icon);