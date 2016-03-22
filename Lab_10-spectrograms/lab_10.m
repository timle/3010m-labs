%% Lab_10
% 
% 

%% The spectrogram
% 
% Today we will extend the usage of FFT towards producing spectrograms. 
% Spectrograms offer a compromise between the resolution in time offered by
%   filtering, and the resolution in frequency offered by the FFT. 
% In order to do this, we cut up the signal into many equal windows, and
%   take the FFT of each window. In this manner, we can detect changes in
%   component frequencies, between windows, over time.  
%
% In order to design our spectrogram code, we will have to go through a
% number of steps:
%   determine sensible window, and step sizes
%   loop for each time window
%       loop for each trial
%           take fft
%           save fft results in sensible structure (3 dimensions!)
%   isolate frequency range of interest
%   average across trials, for each frequency
%   plot the results
%       normalize for colormap
%       subtract baseline
% 
%
% Add fft functions, from last class, to path
    addpath('functions\')
%   functions: fft_3010() & fft_trl_wrapper_3010()
%
% We will use the same data as last week:
load('ecog_e1.mat')
% Human ECoG (Electrocorticography) data
%   See lab 7 for full description.
% 
% Flicker change detection task: 
%       This data features two conditions from the task
%           1) Novel: Novel image + target found
%           2) Remembered: Repeated image + target found
%
% The data is aligned to the last fixation of trial (centered).
% This is the fixation to the changing object/target. 
% 
% Data sampled at 5000 Hz.
%
% To start, we will build a spectrogram for the full 4 seconds of the
%   novel condition. This will be 2s pre fixation to 2s post fixation. 
% Our spectrogram will show frequencies from 1 to 50Hz. 
%
novel = e1.n; % loaded from ecog_e1.mat
%
%
%% Determine sensible window, and step sizes
% we would like to be able to resolve down to <1hz, and so have to find how
%   large how sample needs to be for that. this will be our window size. 
%
% remembering back to last week, what affects the distance between
%   discernible frequencies when performing FFT?
%
% let's find a reasonable window size.
% easiest way, is to do a little experimentation
Fs = 5000; %sample rate of our signal
unique(diff(fft_3010(ones(1000,1),Fs))) % dummy signal 1000 samples long
% not sub 1Hz, will try a larger sample

unique(diff(fft_3010(ones(5000,1),Fs))) % dummy signal 5000 samples long
% this will resolve to 0.6104Hz, that will be sufficient for our purposes. 

% we will take 5000 sample chunks from across the signal, and perform
%   the fft on each of those chunks.
% 5000 sample at 5000Hz sample rate = 1s
% so does that mean we will only be able to detect change in the signal at
%   1 second windows?
%   No! we use a trick - overlapping windows. For Example:
%      1st window = 0s:1s
%       2nd window = 0.1s:1.1s
%       3rd window = 0.2s:1.2s 
%   The distance between the overlapping windows is step size. A small step
%       size will make the spectrogram look 'smooth', and a large step size
%       will make the spectrogram look 'choppy'. Smaller step size = more
%       windows = longer to process. 
%   A rule of thumb is to have about 90% overlap between windows, so for
%   our case, we want 10% of the window size betwen windows. Our step size
%   will be 10% of 5000 samples = 500; (5000 * .1 = 500)
%
%   Our first parameters:
window_size = 5000;
step_size = 500;


    
%% set up main spectrogram loop

% define range of signal to perform spectrogram on. we want to do the whole
% signal, so start at sample #1, and end at last sample in data (sample #20001)
start_sample = 1; 
end_sample = size(novel, 2);

% Define the middle position for each of the windows
%   will use this to grab data window for each iteration in loop
wins_mid_pos = start_sample + (window_size/2) : step_size : end_sample - (window_size/2);
% There will be an fft window, centered on every value in this array. 

% Here is a quick visualization to give intuition of overlapping windows
    clf
    win_start = wins_mid_pos - (window_size/2);
    win_end = wins_mid_pos + (window_size/2);
    y = linspace(0,1,numel(win_start));
    plot([win_start; win_end], [y; y],'linewidth',8)
    hold on
    plot(wins_mid_pos, y-.03, 'k.')
    ylim([-.2 1.2])
    xlim([-1000 21000])
    set(gca,'yticklabel',{})
    grid on
    title('overlapping windows viz')


% partifipation quiz!

% takes about 10 seconds to run (tic/toc will start and stop a timer, used
%   for recording how long code takes to run)
tic
all_trl_pow_win = [];
for cur_win_mid = wins_mid_pos
    
    this_win_start = cur_win_mid - (window_size/2);
    this_win_end = cur_win_mid + (window_size/2) - 1;
    this_win_trl_mat = novel(:, this_win_start: this_win_end);
    %125 trials by 5000 samples
    
    % FFT loop, for each trial
    win_trl_mat_power = [];
    for trl_num = 1:size(this_win_trl_mat,1)
        current_trial = this_win_trl_mat(trl_num, :);
        [freq, pow] = fft_3010(current_trial, Fs);
        win_trl_mat_power = [win_trl_mat_power; pow]; %accumulate values
    end
    % trl_mat_power:
    %       rows: 125 trials
    %       columns: frequency power values across 256 points
    
    all_trl_pow_win = cat(3, all_trl_pow_win, win_trl_mat_power);
    % whoa man, 3rd dimension
    
    all_trl_freq = freq; %fft returns power readings at same frequency 
    % positions for each loop through, because 1) sample rate is same and 
    % 2) sample duration is same. so we just need to hold on the freq val 
    % from the final loop through 
end
toc


% A note on cat (concatenate)
% C = cat(dim, A, B)concatenates the arrays A and B along array the dimension specified by dim.
%   A new way to write a syntax you are already familiar with - the [ ]
%       brackets
% 
    a = zeros(1,3)
    b = ones(1,3)
% 
    c1 = [a; b] %combine as rows (dim 1)
    c2 = cat(1, a, b) %combine on dim 1
    isequal(c1, c2)
% 
    c3 = [a b] %combine as columns (dim 2)
    c4 = cat(2, a, b) %combine on dim 2
    isequal(c3, c4)
% 
%   There is no simple syntax for combining on dims > 2 (beyond rows and
%       columns) and so we must resort to using cat. 
%
size(all_trl_pow_win)
% 125   4096   31
%   So what exactly does this mean?
%
%   trial x power x window matrix
%
% indexing works same as with 2 dimensions (rows & cols)
% (dim 1, dim 2, dim 3)
% 
% to get our trial power matrix (trials as rows, power readings as columns)
% for the first window, looks like this:
    win_1 = all_trl_pow_win(:, :, 1);
    size(win_1)
%   125   4096    125 trials by 4096 power readings

    win_2 = all_trl_pow_win(:, :, 2);
%   etc
%
% for trial 1, window 5:
    trl_1_win_5 = all_trl_pow_win(1, :, 5);
%
% Though at first, indexing across more than two dimensions may seem
%   needlessly complicated, it is in fact a very efficient tool.
% In this way, we can quickly select any subset of our 
%   trial x power x window matrix. 
%
%% Isolate frequency range of interest

foi_locs = all_trl_freq >= 1 & all_trl_freq <= 50;
foi_vals = all_trl_freq(foi_locs);
% restrict our power measurements to just these frequencies
foi_trl_pow_win = all_trl_pow_win(:, foi_locs, :);
size(foi_trl_pow_win)
% (125 trials x 80 power measurements, at foi_vals, for each trial) x 31 windows


foi_mean_pow_win = mean(foi_trl_pow_win);
% (mean of (125 trials) x 80 power measurements, at foi_vals) x 31 windows

%%   plot the results
% We will plot our mean power values as if they were an image. 
% Images are matrices after all! rows and columns, with values representing
% color. 
% Example image:
clf
s = load('clown') 
image(s.X)
colormap(s.map) % maps values in matrix to chosen colors
% 
% Each row, col pair has color value. 
%
% In our spectrogram 'image', low power values will get mapped to dark blue
% colors, and high power values will be mapped to bright yellow colors. 
%
% The first step is to reformat the data into a matrix where the power 
% readings are rows, and each window is a column. rows: power cols: win #
%  
% That is, by reassigning the shape of foi_mean_pow_win to a power x win matrix, 
% we can then treat the matrix it as if it were an image, and directly show
% that image/matrix 



pow_win = [];
pow_win(:,:) = foi_mean_pow_win(1,:,:);
% power to rows, win to columns

% set colormap
colormap(parula(100)) 
    % parula is the colormap name, 100 -> use 100 different colors
% draw image
image(pow_win,'CDataMapping','scaled')
    % by default matlab plots images with yaxis reversed, so fix that:
    set(gca,'YDir','normal')
% still need to do a little bit of work to make sense of things
    % add our HZ values for the y tick. first get their index values:
    y_tick_locs = get(gca,'ytick');
    % and apply that to our foi_vals list:
    y_tick_Hz = foi_vals(y_tick_locs);
    % and finally, set the text
    set(gca,'yticklabels', y_tick_Hz)
    % the x tick labels below, is a new approach to this class, not
    % expected you'll know it. however didn't want to leave plot incomplete
    x_tick_pos = round(linspace(1,numel(wins_mid_pos),11));
    x_tick_S = wins_mid_pos(x_tick_pos) / 5000; % convert to senconds
    set(gca,'xtick', x_tick_pos ,'xticklabel', x_tick_S)
    % finally, label axis
    ylabel('power')
    xlabel('seconds')
    colorbar %add colorbar

%% normalize/subtract average power over trial
% a word on normalization
%   few different methods
%   much more valid to use a baseline (we did not here)
pow_win_log = log(pow_win); %log to help remove 1/f
image(pow_win_log,'CDataMapping','scaled')

% subtract average power, from each row 
pow_mean = mean(pow_win_log,2);
% mean power across 4 seconds
pow_win_bln = bsxfun(@minus, pow_win_log, pow_mean);
% bsxfun is used here to subtract array from matrix. handy if you know how
% to use it!!
image(pow_win_bln,'CDataMapping','scaled')

% axis fixes
    set(gca,'YDir','normal')
    y_tick_locs = get(gca,'ytick');
    y_tick_Hz = foi_vals(y_tick_locs);
    set(gca,'yticklabels', y_tick_Hz)
    x_tick_pos = round(linspace(1,numel(wins_mid_pos),11));
    x_tick_S = wins_mid_pos(x_tick_pos) / 5000; % convert to senconds
    set(gca,'xtick', x_tick_pos ,'xticklabel', x_tick_S)
    ylabel('hz')
    xlabel('seconds')
    colorbar %add colorbar
    


