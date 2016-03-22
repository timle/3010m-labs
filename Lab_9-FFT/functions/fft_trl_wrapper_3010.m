
function [trl_mat_frequencies, trl_mat_power] = fft_trl_wrapper_3010(trl_mat, Fs)
% simple wrapper to run fft_3010() on each row of a trial matrix (rows a
% trials, samples in time as columns)
%
% see fft_3010() for more information on running ffts
%
% for novel trials - loop through each trial, calculate fft
trl_mat_power = [];
for trl_num = 1:size(trl_mat,1)
    current_trial = trl_mat(trl_num, :);
    [frequency, power] = fft_3010(current_trial, Fs);
    trl_mat_power = [trl_mat_power; power]; %accumulate values
end
trl_mat_frequencies = frequency; % save frequency from last iteration (it will be same for all iterations, as all trials are same length)

