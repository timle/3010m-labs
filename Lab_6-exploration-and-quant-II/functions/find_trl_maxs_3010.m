function [max_values, max_locations] = find_trl_maxs_3010(trl_mat, win_start, win_end)
%% find_maxs_3010
% Function for 3010M. Based on algorithm developed in Lab 5. 
%   Given a matrix of trial signals (trials as rows,
%   columns as samples), this function will return, for each trial (row) 
%   the max value, and the location in the trial of the max value. 
%   win_start and win_end are used to specifcy a window within the trial,
%   for which the max search should be restricted.
% 
% input:
%   trl_mat: Trial matrix (trials as rows, columns as samples)
%   win_start: Where to start max search in signals. 
%   win_end: Where to end max search in signals. 
% 
% output:
%   min_values: Given an trl_mat with N rows (trials), a vector of
%       length N will be returned. There will a value for each trial, 
%       representing the minimum value.
%   min_locations: Given an trl_mat with N rows (trials), a vector of
%   	length N will be returned. There will a value for each trial, 
%       representing the location of each minimum value.
% 
% see find_mins_3010

    trl_mat(:,1:win_start) = nan;
    trl_mat(:,win_end:end) = nan;
    [max_values, max_locations] = max(trl_mat,[],2);


    
    