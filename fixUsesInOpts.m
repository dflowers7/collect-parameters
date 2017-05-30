function opts = fixUsesInOpts(m, con, opts)

if ~isfield(opts, 'UseParams')
    opts.UseParams = true(m.nk,1);
end

ncon = numel(con);
if ~isfield(opts, 'UseSeeds')
    opts.UseSeeds = false(m.ns, ncon);
end
if ~isfield(opts, 'UseInputControls')
    opts.UseInputControls = arrayfun(@(con){false(con.nq,1)}, con(:));
end
if ~isfield(opts, 'UseDoseControls')
    opts.UseDoseControls = arrayfun(@(con){false(con.nh,1)}, con(:));
end

UseParams = opts.UseParams;
UseSeeds = opts.UseSeeds;
UseInputControls = opts.UseInputControls;
UseDoseControls = opts.UseDoseControls;

[UseParams, UseSeeds, UseInputControls, UseDoseControls] = fixUses(...
    m, con, UseParams, UseSeeds, UseInputControls, UseDoseControls);

opts.UseParams = UseParams;
opts.UseSeeds = UseSeeds;
opts.UseInputControls = UseInputControls;
opts.UseDoseControls = UseDoseControls;

end