function [nT,nTk,nTs_icon,nTq_icon,nTh_icon] = countFitParameters(UseParams, UseSeeds, UseInputControls, UseDoseControls)

nTk = sum(UseParams);
nTs_icon = sum(UseSeeds, 1);
nTs = sum(nTs_icon);
nTq_icon = cellfun(@sum, UseInputControls);
nTq = sum(nTq_icon);
nTh_icon = cellfun(@sum, UseDoseControls);
nTh = sum(nTh_icon);

nT = nTk + nTs + nTq + nTh;

end