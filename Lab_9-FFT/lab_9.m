%% Lab_9

%% FFT 
%
%
% This week we will revisit a previous analysis (lab 7) but now with a
% new method. 
%
% Who remembers how we were able to compare power differences in lab 7?
%   If there was a particular band of interest what was the process for
%   quantifying differences in this band?
%       Hint: filter -> rectify -> envelope
%
% This class, we will be moving to using the fourier transform. Matlab's
%   impletmentation is called the fast fourier transform: FFT. 
%   (it is just a computationally more efficient version of the original 
%   fourier transform). I will generally refer to the fourier transform as FFT. 
%
% The FFT decomposes a signal into it's component frequencies. Instead of
%   looking at a summation of frequencies over time (what we've been doing up
%   to now), or in the case of filtering, the summation frequencies in an 
%   isolated band over time, the FFT allows us to identify the amplitude of 
%   a list of frequencies within a signal. 
%
% We are moving from temporal to frequency domain.
%   With the FFT, we loose all reference to when a given frequency starts 
%   and stops, and instead only get to know the amount of each frequency 
%   in a signal.
%   I.e. if a signal is 1second long, you won't know *when* the power for a
%   frequency went up and down. The FFT will simply tell you which  
%   frequencies are in the signal, + their corresponding amplitude. 
%
% A new function has appeared! fft_3010()
    addpath('functions\') %add directory to pathfile
%   fft_3010() will return the amount power across a range of frequencies
%       The range of frequencies depends on singal length & sample
%       frequency.
%       The max frequency, for which the FFT will return a power value, will 
%           always be < (sample rate/2)
%       The resolution, (number of frequency points at which power is 
%           measured) will increase as the length of the sample increases
%       But, more on these limitations later.
% 
%
% It's FFT time!
%   First we must create a signal
%       Combination of 15Hz + 40Hz + 80Hz
%
        fs = 1000;                        % Sample frequency (Hz)
        t = 0:1/fs:10-1/fs;               % 10 sec sample
        x = (1.3)*sin(2*pi*15*t) ...      % 15 Hz component
          + (1.7)*sin(2*pi*40*t) ...      % 40 Hz component
          + (2)*sin(2*pi*95*t);           % 95 Hz component
%        Adding some noise to the signal 
        x2  = x + gallery('normaldata',size(t),4); % Normally distributed noise (static)
%
%       Plot signal, and signal with added noise
        subplot(2,1,1)
            plot(x)
            title('15Hz +_ 40Hz + 95Hz');
        subplot(2,1,2)
            plot(x2)
            title('15Hz +_ 40Hz + 95Hz + noise');
        linkaxes %yokes the zoom tool across subplots
% 
%   
% We generated the signal x2 above. Let's see what comes out when we run an
% FFT on it. 
% 
    [frequency, power] = fft_3010(x2, 1000); %signal: x2, sample frequency: 1000Hz
%    returns two vectors of same length.   
%       frequency: list of frequencies for which we have a power measurement
%       power: the amplitude of a given frequency listed in the frequency
%           variable
%
%    for example:
%       These frequencies:
        frequency(1:10)
%       Have a power measurement of 
        power(1:10)
%   It's quite simple to plot this output
    clf
    subplot(2,1,1)
        plot(frequency, power)
    subplot(2,1,2)
        plot(frequency, power)
        xlim([0 100]) %zoom in
%     
%   Sure enough, we see peaks at 15Hz, 40Hz and 95Hz.
%
%
% Example 2: FFT to compare two different voices
%   Voice 1
    clf
    [y,Fs] = audioread('HF.wav'); %load audio, and the sample rate the audio is saved at
    [frequency, power] = fft_3010(y, Fs); %input audio, and it's sample rate to FFT
    subplot(2,1,1)
    plot(frequency, power) %plot voice 1
        ylim([0 10])
        xlim([0 800])
%   Voice 2
    [y,Fs] = audioread('optimistic.wav'); %load audio, and the sample rate the audio is saved at
    [frequency, power] = fft_3010(y, Fs); %input audio, and it's sample rate to FFT
    subplot(2,1,2)
    plot(frequency, power) %plot voice 1
        ylim([0 10])
        xlim([0 800])
%         
%   Based on the frequency distributions, what conclusions can you make 
%      about voice 1, vs voice 2?
%
%
%    Participation quiz!
%
%
% Now, armed with a little intuition of how FFT works, worthwile to examine 
%   the limitations of fft.
fs = 1000;

% frequency resolution increases with sample size
    t = 0:1/fs:.1-1/fs; %.1 second sample duration
    signal_100ms = sin(2*pi*15*t); 
    [frequency, power] = fft_3010(signal_100ms, fs);
    unique(diff(frequency))

    t = 0:1/fs:1-1/fs; %1 second sample duration
    signal_1s = sin(2*pi*15*t); 
    [frequency, power] = fft_3010(signal_1s, fs);
    unique(diff(frequency))

    t = 0:1/fs:10-1/fs; %10 second sample duration
    signal_10s = sin(2*pi*15*t); 
    [frequency, power] = fft_3010(signal_10s, fs);
    unique(diff(frequency))

% max descernable frequency increase with sample rate
    fs = 100;           %100Hz
    t = 0:1/fs:.1-1/fs; %10 second sample duration
    signal_100Hz = sin(2*pi*15*t); 
    [frequency, power] = fft_3010(signal_100Hz, fs);
    max(frequency)

    fs = 1000;           %1000Hz    
    t = 0:1/fs:.1-1/fs; %10 second sample duration
    signal_1000Hz = sin(2*pi*15*t); 
    [frequency, power] = fft_3010(signal_1000Hz, fs);
    max(frequency)

    fs = 10000;           %10000Hz    
    t = 0:1/fs:.1-1/fs; %10 second sample duration
    signal_10000Hz = sin(2*pi*15*t); 
    [frequency, power] = fft_3010(signal_10000Hz, fs);
    max(frequency)




% Let's revisit lab 7 analysis:
load('ecog_e1.mat')
%
% This is human ECoG (Electrocorticography) data
% 
% This data consists of:
%   One electrode: e1
% Data recording during a flicker change detection task: 
%       Examples: http://www2.psych.ubc.ca/~rensink/flicker/download/index.html
%
%       The participants eye movements are being tracked with an eye tracker.
%       A trial ends after a) the target is fixated or b) 30s of searching.
% 
%       Each image shown twice.
%       Novel images have two conditions: Target found and target not found
%
%       Repeated images have two conditions: 
%           Target found: remembered
%           Target not found: forgotten
% 
%       This data features just two conditions from the task
%           1) Novel: Novel image + target found
%           2) Remembered: Repeated image + target found
%           Other conditions not included, where target was not found:
%               3) Novel image + target not found.
%               4) Forgotten: Repeated image + target not found
%  
% We will be working with (1) & (2), [n]ovel found & [r]emembered
% 
% The data is aligned to the last fixation of trial (centered). This is the fixation
% to the changing object/target. 
% 
% Data has 5000 Hz sampling rate. That means each sample is:
sample_dur_s = 1/5000
%
%
%
% 
% A researcher observed an increase in power, for frequencies between 
%   60Hz - 100Hz. They also noted that this power increase seems to occur 
%   earlier in the remembered condition when compared to the novel condition. 
%
% 
% 
% assign easier to read variable names
novel = e1.n;
rem = e1.r;
% 
% Exploring the data:
%   Methods used so far (previous classes):
%       plotting all trials - try to asses variability
%       plotting means - does the average (smoother) tell us anything
%       plotting the power amplitudes, via the band pass filter, 
%           isolating frequencies 60Hz - 100Hz
%
% We will start by taking FFT of each trial, and plotting those
%   averages across conditions. 
%

% Taking fft of each trial, using loops
Fs = 5000;
% for novel trials - loop through each trial, calculate fft
    novel_fft_power = [];
    for trl_num = 1:size(novel,1)
        current_trial = novel(trl_num, :);
        [frequency, power] = fft_3010(current_trial, Fs);
        novel_fft_power = [novel_fft_power; power]; %accumulate values
    end
    novel_fft_frequencies = frequency; % save frequency from last iteration 
                                         % (it will be same for all iterations)
% for rem trials - loop through each trial, calculate fft
    rem_fft_power = [];
    for trl_num = 1:size(rem,1)
        current_trial = rem(trl_num, :);
        [frequency, power] = fft_3010(current_trial, Fs);
        rem_fft_power = [rem_fft_power; power];
    end
    rem_fft_frequencies = frequency;
    
    
%
%
%   Plot the FFT results
clf
s1 = subplot(2,1,1);
plot(novel_fft_frequencies, mean(novel_fft_power))
% ylim([0 5000])
xlim([0 150])

s2 = subplot(2,1,2);
plot(rem_fft_frequencies, mean(rem_fft_power))
% ylim([0 5000])
xlim([0 150])

linkaxes

% Hard to interpret. 1/f noise is getting in the way. 
%   One way to aid vizualization is to rescale the axes from linear to log:
    s2.XScale = 'log';
    s2.YScale = 'log';
    s1.XScale = 'log';
    s1.YScale = 'log';
%   And to make the x and y labels easier to read
    s1.XTickLabel = s1.XTick;
    s1.YTickLabel = s1.YTick;
    s2.XTickLabel = s1.XTick;
    s2.YTickLabel = s1.YTick;

% Can can also simply look at average power for a specific band. Here we
% are already interested in 60-100, so let's look at that. 

novel_foi = novel_fft_frequencies >= 60 &  novel_fft_frequencies <= 100; 
novel_foi_power = novel_fft_power(:, novel_foi);

rem_foi = rem_fft_frequencies >= 60 &  rem_fft_frequencies <= 100;
rem_foi_power = rem_fft_power(:, rem_foi);

% mean, for each trial, of the fft power between 60 and 100hz
novel_foi_trl_means = mean(novel_foi_power,2);
rem_foi_trl_means = mean(rem_foi_power,2);

bins = 0:100:2000;
subplot(2,1,1)
bar(bins, histc(novel_foi_trl_means, bins))
title('novel')
ylim([0 20])
subplot(2,1,2)
bar(bins, histc(rem_foi_trl_means, bins))
title('rem')
xlabel('mean band power')
ylabel('count')
ylim([0 20])

median(novel_foi_trl_means)
median(rem_foi_trl_means)
% 
% Nothing conclusive though. 
%
% Who rememberes our original hypothsis though? Why does this analysis fall
% short?

    
% Redux on subsets of the trial
% 2.5s before fixation, and 2.5s after, for each condition
pre_start = 5001;
pre_end = 10000;
post_start = 10001;
post_end = 15001;

novel_prF = e1.n(:, pre_start:pre_end);
novel_poF = e1.n(:, post_start:post_end);
rem_prF = e1.r(:, pre_start:pre_end);
rem_poF = e1.r(:, post_start:post_end);


% A new convinience function has appeared!
%
% To simplified the code a bit, I've taken the liberty of turning this: 
%     rem_fft_power = [];
%     for trl_num = 1:size(rem,1)
%         current_trial = rem(trl_num, :);
%         [frequency, power] = fft_3010(current_trial, Fs);
%         rem_fft_power = [rem_fft_power; power];
%     end
%     rem_fft_frequencies = frequency;
%
% into a function. 
%     

Fs = 5000;
% novel_prF
[novel_prF_f,novel_prF_p] = fft_trl_wrapper_3010(novel_prF, Fs);
% novel_poF
[novel_poF_f,novel_poF_p] = fft_trl_wrapper_3010(novel_poF, Fs);
% rem_prF
[rem_prF_f,rem_prF_p] = fft_trl_wrapper_3010(rem_prF, Fs);
% rem_poF
[rem_poF_f,rem_poF_p] = fft_trl_wrapper_3010(rem_poF, Fs);



% comparing mean power, from teh 60-100hz band, before fixation, between
% novel and repeat

foi_locs = novel_prF_f >= 60 & novel_prF_f <= 100;
% Can reuse foi_locs between variables.
% Because sample rate, and duration of samples is same across
% variables, our freqency values returned by the fft function will be the
% same! Proof:
isequal(novel_prF_f, novel_poF_f, rem_prF_f, rem_poF_f)
novel_prF_foi_pow_trls = novel_prF_p(:, foi_locs);
rem_prF_foi_pow_trls = rem_prF_p(:, foi_locs);

novel_prF_foi_pow_trls_mn = mean(novel_prF_foi_pow_trls, 2);
rem_prF_foi_pow_trls_mn = mean(rem_prF_foi_pow_trls, 2);


clf
bins = 0:100:3500;
subplot(2,1,1)
    bar(bins, histc(novel_prF_foi_pow_trls_mn, bins))
    title('novel, mean 60Hz-100Hz power, pre fixation')
subplot(2,1,2)
    bar(bins, histc(rem_prF_foi_pow_trls_mn, bins))
    title('remembered, mean 60Hz-100Hz  pre fixation')
    ylabel('count')
    xlabel('Mean Trl Power in band')
    
addpath('M:\hoffman\3010M\Lab 6\functions')
perm_test_3010(novel_prF_foi_pow_trls_mn, rem_prF_foi_pow_trls_mn)

%% Moved to next week start
% This next portion section will be covered next week (lab 10). 
    % Low power effect. Can we think of a better way of describing the
    % effect?
    % comparing power difference of 60-100hz band, before and after fixation, 
    %   between novel and rem conditinos:
    novel_prF_foi_pow_trls = novel_prF_p(:, foi_locs);
    novel_poF_foi_pow_trls = novel_poF_p(:, foi_locs);
    rem_prF_foi_pow_trls = rem_prF_p(:, foi_locs);
    rem_poF_foi_pow_trls = rem_poF_p(:, foi_locs);

    novel_prF_foi_pow_trls_mn = mean(novel_prF_foi_pow_trls ,2);
    novel_poF_foi_pow_trls_mn = mean(novel_poF_foi_pow_trls ,2);
    rem_prF_foi_pow_trls_mn = mean(rem_prF_foi_pow_trls ,2);
    rem_poF_foi_pow_trls_mn = mean(rem_poF_foi_pow_trls ,2);

    clf
    bins = -300:20:300;
    subplot(2,1,1)
        novel_diff = novel_poF_foi_pow_trls_mn - novel_prF_foi_pow_trls_mn; % within trial pwoer difference
        bar(bins, histc(novel_diff, bins))
        title('novel, 60-80hz band power difference, post - pre fixation')
    subplot(2,1,2)
        rem_diff = rem_poF_foi_pow_trls_mn - rem_prF_foi_pow_trls_mn; 
        bar(bins, histc(rem_diff, bins))
        title('rem, 60-80hz band power difference, post - pre fixation')


    perm_test_3010(novel_diff, rem_diff)
% portion for next week ends here
%% Moved to next week end

%% task
% Using FFT, make a plot that will display mean trial power, for the novel 
%   condition, between 75 and 85hz, for the four periods below.
% 
% As part of the lab quiz, you will be submitting your plot. 
%
% Period a: 1:5000
% Period b: 5001:10000
% Period c: 10001:15000
% Period d: 15001:20000
%
% Code example:

% for period A
% novel_A = e1.n(:, 1:5000);

% [novel_A_f, novel_A_p] = fft_trl_wrapper_3010(novel_A, Sample_frequency);

% foi_locs = novel_A_f between 75 and 85hz;

% novel_A_f_foi = for all trials, select the foi_locs columns from novel_A_f;

% mean_novel_A_p = mean of each row (power for each trial) of novel_A_f_foi;

% bar_1_value = mean of mean_novel_A_p (the overall mean of the mean of each trials power in the 75 - 85 hz band)

% size of bar_1_value should be [1 1];

...
    
% plot([bar_1_value bar_2_value bar_3_value bar_4_value])
% xlabel('sensible x label')
% ylabel('sensible y label')
% title('sensible title')







