function [m,con] = distributeFitParameters(m, con, T, UseParams, UseSeeds, UseInputControls, UseDoseControls)
% [m,con] = distributeFitParameters(m, con, T, UseParams, UseSeeds, UseInputControls, UseDoseControls)
% Assign an array of fit parameters T to model and experiment structs m and
% con.
% 
% Input arguments:
%   m
%       An array of models. Each model should have the same number of
%       parameters. The number of models should match the number of
%       provided fit parameter sets (the number of columns of T) and the
%       number of sets of experiments (the number of columns of con).
%   con
%       An array of experiments. The rows are different experiments
%       belonging to a single fit, while the columns are the 
%   T
%   UseParams
%   UseSeeds
%   UseInputControls
%   UseDoseControls
% m and con arrays are supported. For con arrays, each row should be a
% different experiment and each column should be a different sample.

% Calculate the number of fit parameters
[~,nTk,nTs_icon,nTq_icon,nTh_icon] = countFitParameters(UseParams, UseSeeds, UseInputControls, UseDoseControls);
nTs = sum(nTs_icon);
nTq = sum(nTq_icon);
nTh = sum(nTh_icon);
nk = numel(UseParams);
ns = size(UseSeeds,1);
nq_icon = cellfun(@numel, UseInputControls);
nh_icon = cellfun(@numel, UseDoseControls);
ncon = numel(UseInputControls);
nsamples = size(T,2);

% If no model or experiment set is provided, create dummy ones to store the
% parameters in. Missing parameters will be set to NaN.
if isempty(m)
    m = struct('k', repmat({nan(nk,1)},nsamples,1) );
end
if isempty(con)
    emptys = repmat({nan(ns,1)},1,nsamples);
    clear con
    for i = ncon:-1:1
        emptyq_i = repmat({nan(nq_icon(i),1)},1,nsamples);
        emptyh_i = repmat({nan(nh_icon(i),1)},1,nsamples);
        con(i,:) = struct('s', emptys, 'q', emptyq_i, 'h', emptyh_i);
    end
end

% If only one model and/or experiment set is provided, replicate them over
% the number of samples
if isscalar(m)
    m = repmat(m, nsamples, 1);
end
if isequal(size(con), [ncon,1])
    con = repmat(con, 1, nsamples);
end

% Check that the size of m and con matches the number of provided samples
assert(numel(m) == nsamples, 'distributeFitParameters:IncorrectModelArraySize', ...
    'The number of elements of m does not match the number of columns of T.')
assert(size(con,2) == nsamples, 'distributeFitParameters:IncorrectExperimentArraySize', ...
    'The number of columns of con does not match the number of columns of T.')

% Extract parameters from m and con arrays
ks = [m.k];
[ss,qs,hs] = deal(cell(ncon,1));
for i = 1:ncon
    ss{i} = [con(i,:).s];
    qs{i} = [con(i,:).q];
    hs{i} = [con(i,:).h];
end

% Assign parameters to extracted arrays
ks(UseParams,:) = T(1:nTk,:);
for i = 1:ncon
    UseSeeds_i = UseSeeds(:,i);
    startind_s = nTk + sum(nTs_icon(1:i-1)) + 1;
    endind_s = startind_s + nTs_icon(i) - 1;
    
    UseInputControls_i = UseInputControls{i};
    startind_q = nTk + nTs + sum(nTq_icon(1:i-1)) + 1;
    endind_q = startind_q + nTq_icon(i) - 1;
    
    UseDoseControls_i = UseDoseControls{i};
    startind_h = nTk + nTs + nTq + sum(nTh_icon(1:i-1)) + 1;
    endind_h = startind_h + nTh_icon(i) - 1;
    
    ss{i}(UseSeeds_i,:) = T(startind_s:endind_s,:);
    qs{i}(UseInputControls_i,:) = T(startind_q:endind_q,:);
    hs{i}(UseDoseControls_i,:) = T(startind_h:endind_h,:);
end

% Assign extracted arrays back into structs
splitSamplesIntoCells = @(x)mat2cell(x, size(x,1), ones(size(x,2),1));
ks = splitSamplesIntoCells(ks);
if isfield(m(1), 'Update')
    mupdate = m(1).Update;
    m = cellfun(mupdate, ks);
else
    [m.k] = deal(ks{:});
end
for i = 1:ncon
    ss{i} = splitSamplesIntoCells(ss{i});
    qs{i} = splitSamplesIntoCells(qs{i});
    hs{i} = splitSamplesIntoCells(hs{i});
    
    if isfield(con(1), 'Update')
        conupdate_i = con(i,1).Update;
        con(i,:) = cellfun(conupdate_i, ss{i}, qs{i}, hs{i});
    else
        [con(i,:).s] = deal(ss{i}{:});
        [con(i,:).q] = deal(qs{i}{:});
        [con(i,:).h] = deal(hs{i}{:});
    end
end

end