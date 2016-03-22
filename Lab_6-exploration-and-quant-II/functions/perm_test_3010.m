function [ p, simulated_differences, real_difference ] = perm_test_3010( cond_a, cond_b, n_perms, fun )
%PERM_TEST_3010 Do a permutation to test if there is a significant mean
%   difference between two conditions. 
%   This function will always run a two tailed test.
%   The n of each condition need not match. 
%   This is not a full permutation test, and so is considered a monte carlo
%   simulation.
%   The test statistic is the difference in means.   
% 
%   For more information on this family of significance tests see:
%       https://en.wikipedia.org/wiki/Resampling_(statistics)
%   By default, a mean difference will be run. However, alternative test
%   statistics can be passed in using the fun argument. 
% 
%   Introduced in Lab 6, as an alternative to t-tests.
% 
%   
%   Input:
%       cond_a: Vector of measurements, representing condition a. If a
%       matrix is inputted, it will be treated as if a list of
%       measurements.
%       cond_b: Vector of measurements, rerpesenting condition b. If a
%       matrix is inputted, it will be treated as if a list of
%       measurements.
%       n_perms: (optional) override the default behaviour of 1000
%           permutations. 
%       fun: (optional) by default, mean difference is tested. override
%           this behaviour by specificing other function to use (i.e.
%           median)
% 
%   Output: 
%       p: Based on a simulated distribution of all possible mean combinations, 
%           the probability of the observed difference in means having occured.


rng(3010) % Seeds the random number generator using the nonnegative integer 
          % seed so that rand, randi, and randn produce a predictable 
          % sequence of numbers.
          % Important for class, so that we all get the same predictable
          % results.
          % If you use this script outside of class, you are advised to
          % remove the rng() command.

if ~exist('fun','var')||isempty(fun);fun=@mean;end %default settings for n_perms

if ~exist('n_perms','var')||isempty(n_perms);n_perms=1000;end %default settings for n_perms

cond_a_numel = numel(cond_a); % size of condition A
cond_b_numel = numel(cond_b); % size of condition B

cond_ab_grouped = [cond_a(:); cond_b(:)]; % reshape and pool into single column

perm_results = nan(size(n_perms));
for ii = 1:n_perms
    % make a list of shuffled indexes as long as the pooled list
    this_perm_index = randperm(cond_a_numel + cond_b_numel);
    % use 1:cond_a_numel of this list, to make a new grp a, from cond_ab_grouped 
    cond_a_new = cond_ab_grouped(this_perm_index(1:cond_a_numel));
    % use cond_a_numel+1:end of this list, to make a new grp b, from cond_ab_grouped 
    cond_b_new = cond_ab_grouped(this_perm_index(cond_a_numel+1:end));
    % run the test statistic (in this case difference in means)
    perm_results(ii) = fun(cond_a_new) - fun(cond_b_new);
end
%  calculat observed difference
real_difference = mean(cond_a) - mean(cond_b);

% Because we are looking at a difference measure, taking the absoute values
%   is an easy trick for adjusting our results to be a two tailed test.
two_tail_perm_result = abs(perm_results);
two_tail_real_difference = abs(real_difference);
% Finally calculate P - the probability of the difference in observed means
%   having occured in our simulated distribution of mean difference values.
p = sum(two_tail_perm_result>=two_tail_real_difference)/n_perms;

simulated_differences = two_tail_perm_result;
real_difference = two_tail_real_difference;
end

