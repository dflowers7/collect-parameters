function T = collectFitParameters(m, con, UseParams, UseSeeds, UseInputControls, UseDoseControls)

ncon = numel(con);

ks = [m.k];
Tk = ks(UseParams,:);

[Ts,Tq,Th] = deal(cell(ncon,1));
for i = 1:ncon
    Ts{i} = [con(i,:).s];
    UseSeeds_i = UseSeeds(:,i);
    Ts{i} = Ts{i}(UseSeeds_i,:);
    
    Tq{i} = [con(i,:).q];
    UseInputControls_i = UseInputControls{i};
    Tq{i} = Tq{i}(UseInputControls_i,:);
    
    Th{i} = [con(i,:).h];
    UseDoseControls_i = UseDoseControls{i};
    Th{i} = Th{i}(UseDoseControls_i,:);
end
Ts = vertcat(Ts{:});
Tq = vertcat(Tq{:});
Th = vertcat(Th{:});

T = [Tk;Ts;Tq;Th];

end