%% Lab_6

%% Data exploration and quantification II 

% 
% We will use same neural data from last week:
    load('lfp_simple.mat') %lfp variable
%   loads the variable 'lfp'
% 
%   This is data from an experiment where subjects saw either a face or an
%       object.
%   In this dataset, data from three electrodes are included. each electrode
%       is recording brain activity at a different location as the images are
%       shown to the subject.
%   There are 112 trials where face images are shown, and 110 trials where 
%       clip art object images are shown.
% 
% Set up variables now, we will use these throughout the tutorial.
    e_1_face_condition = lfp.e_1.face;
    e_1_obj_condition = lfp.e_1.obj;
    e_3_face_condition = lfp.e_3.face;
    e_3_obj_condition = lfp.e_3.obj;
    e_5_face_condition = lfp.e_5.face;
    e_5_obj_condition = lfp.e_5.obj;
    
    
% Who remembers the trough detector from last class?
% How did it work?
% 
% I've made a gift for the class! I have turned our trough detector into a
% self contained command. 
% 
% This is an advanced usage of MATLAB that we haven't covered yet. If you
%   have an algorithm that you would like to use over and over in your code,
%   you don't have the re-write all the lines of the code each time. 
% The alternative is to re-write the algorithm as a command (MATLAB 
%   technically refers this as a 'function', in this class the terms 
%   function/command are interchangeable). 
% 
% Once you write a function, to use it as a command in MATLAB you must either:
%   1) Make sure the function file is in your current working directory. 
%       or
%   2) Add the directory, containing the function, to your pathfile
% 
% The MATLAB pathfile:
%   The MATLAB pathfile is a long list that MATLAB uses to keep track of
%       all folders that contain MATLAB code that we may want to run.
% 
%   You can see what your pathfile looks like with the path command:
       path
% 
% Let's add a new folder to this list (the pathfile). The folder we'd like 
%       like to add has some commands/functions I have written for this class:
    addpath('functions') %add directory to pathfile
% 
%   That's it! Now you can easily access these new commands within MATLAB
% 
%   Note - due to the way York has set up their systems, we can't easily save
%       changes to our pathfile, so this change will not be persistent across
%       MATLAB startups. 
%    That is to say, if MATLAB is restarted, in order to use the 
%       functions in the 'M:\hoffman\3010M\Lab 6\functions' folder, you will 
%       have to rerun the addpath command.
 
    
% We now have access to find_trl_mins_3010() and find_trl_maxs_3010()
% 
%   View the code like so:
edit find_trl_maxs_3010
edit find_trl_mins_3010
%
% 
% Example usage:
    win_start = 500;
    win_end = 700;
    [min_values, min_locations] = find_trl_mins_3010(e_1_face_condition,win_start,win_end);
% 
%   verify, plot first 5 trials, with their min locations demarcated:
    figure
    clf
    hold on;
    plot(e_1_face_condition(1:5,:)');
    plot(min_locations(1:5,:), min_values(1:5,:),'.','markersize',20);
%   Looks good!
% 
%  Now lets try trial maxes
    win_start = 500;
    win_end = 700;
    [max_values, max_locations] = find_trl_maxs_3010(e_1_face_condition,win_start,win_end);
%   verify, plot first 5 trials, with their min locations demarcated:
    clf
    hold on;
    plot(e_1_face_condition(1:5,:)');
    plot(max_locations(1:5), max_values(1:5),'.','markersize',20);
%   Looks good!
% 
% 
%  We talked about ways of quantifying the evoked response last week.
%  Remeber any of the ideas we came up with?
%
% * Time to evoked trough
% * Time to evoked peak
% * Peak to trough distance
% 
% 
% 
% Let's review where we left off last week. We were comparing the latency
%   to evoked trough, between conditions. 
%   This will be a little easier now that we have the find_trl_mins_3010
%   function written.
% Compare the latency, to trough minimum, of the the evoked response,
%   between the object and face conditions, for electrode 3:
    win_start = 500;
    win_end = 700;
   % condition A - face images
    [A_min_values, A_min_locations] = find_trl_mins_3010(e_3_face_condition,win_start,win_end);
   % condition B - Object images
   [B_min_values, B_min_locations] = find_trl_mins_3010(e_3_obj_condition,win_start,win_end);
   
   mean(A_min_locations)
   mean(B_min_locations)
       
% The means are very similar!
% Is there a better way to try and visualize the differences bettween
%   theses two distributions of trough latencies?
% 
% Introducing our new friend, histc().
%   histc will return counts within binned values.
%   We can then plot those counts using bar().
%   This is quite valuable, since we can start to compare the shape of 
%       distributions. 
%       Memories (nightmares) from stats class?!
% 
% Distribution of trough locations for face 
clf
bins = 450:10:700;
subplot(2,1,1)
    bin_counts = histc(A_min_locations, bins);
    bar(bins, bin_counts)
    title('min evoked response location, face condition, e3')
    xlabel('bin')
    ylabel('count')
% Distribution of trough locations for obj 
subplot(2,1,2)
    bin_counts = histc(B_min_locations, bins);
    bar(bins, bin_counts)
    title('min evoked response location, obj condition, e3')
    xlabel('bin')
    ylabel('count')
% Talk a bit about how to read histogram
% Also mention use of subplots here.

% Shape of distribution is similar, with one notable exception. 
% The object condition appears to be bi-modal. Very interesting case, where
%   the means are similar, but distributions are not. 
% In this case, because the distributions are not normal, if you wanted to
%   test for significance, you would have to use a non-parametric test. 
% That's all I'll say on non-parametric now, we will dive deeper into the
%   tapic at a later date. Just note, the term will keep popping up!
% 
%
% Participation quiz!
% 
%
% For now, the takeaway is that visulaizing the distributions is
%   important!! If we hadn't, we would have missed this possible effect 
%   (bimodal distributions of min evoked time on object but not face 
%   condition).

 

% What about one of the most promising metrics, which we identified - peak
% to trough distance?
% 
%  How can we calculate the peak to trough distance? 
%   Hint: There is a simple method, using our new find_trl_maxs_3010 and
%   find_trl_mins_3010 command. Any ideas?
%   This is the crux of programming, figuring out how to use the tools at
%   hand to solve an unknown.
% 
% 
%   peak to trough (min to max) for e_3_face_condition
    win_start = 500;
    win_end = 700;
    trl_matrix = e_3_face_condition;
    [max_values] = find_trl_maxs_3010(trl_matrix, win_start, win_end);
    [min_values] = find_trl_mins_3010(trl_matrix, win_start, win_end);

    pk_trgh_diff_cond_a = max_values - min_values;
     
%   and now for e_3_obj_condition
    win_start = 500;
    win_end = 700;
    trl_matrix = e_3_obj_condition;
    [max_values] = find_trl_maxs_3010(trl_matrix, win_start, win_end);
    [min_values] = find_trl_mins_3010(trl_matrix, win_start, win_end);

    pk_trgh_diff_cond_b = max_values - min_values;

%   let's compare:
    mean(pk_trgh_diff_cond_a)
    mean(pk_trgh_diff_cond_b)
    
    
% Now with histograms:
%   Distribution of trough locations for obj 
    clf
    bins = 0:20:400;
    subplot(2,1,1)
        bin_counts = histc(pk_trgh_diff_cond_a, bins);
        bar(bins, bin_counts)
        title('max - min evoked response, face condition, e3')
        xlabel('bin')
        ylabel('count')
    % Distribution of trough locations for face 
    subplot(2,1,2)
        bin_counts = histc(pk_trgh_diff_cond_b, bins);
        bar(bins, bin_counts)
        title('max - min evoked response, object condition, e3')
        xlabel('bin')
        ylabel('count')
% Talk a bit about how to read histogram
% Generally - We see trend toward much larger responses during the face 
%   condition, for e3
% 
% 
% Is this effect significant? I.e., what is the likelihood that the
%   observed difference in means would come from the same population. 
%   Stats I -> Hypothesis testing. 
%       What is the Null?
%       What is the alternative?
% 
% What would be the first choice for testing these two groups? 
%   (pk_trgh_diff_cond_a vs. pk_trgh_diff_cond_b)
% 
%   
% We (unfortunately) do not have access to ttest with this version of
%   MATLAB. 
% 
%   For normally distributed data, a permutation test (also called label 
%       swap/reshuffling methods/monte carlo test approximation/many other names) 
%       is a non-parametric test which closely approximates the T statistic. 
%       Additionally, for non-normal data, the permutation test performs 
%       far better (more power!) than the classic ttest. 
%   (Also, the permutation test is trivial to program in MATLAB)
% 
%   So, for most of this class, we will proceed with using the permutation 
%   test as a stand in for the ttest. 
% 
%   As quick note, in the interest of speed, the perm_test_3010() function 
%   is accurate only down to p<.001. More permutations increase accuracy,
%   but take much longer to calculate.
%   For the purposes of this class, p<.001 will be just fine.
% 
% Let's test the hypothesis that the Face condition differs in evoked
%   response magnitude (as measured from evoked peak to trough) compared to
%   the object condition. 
p = perm_test_3010(pk_trgh_diff_cond_a, pk_trgh_diff_cond_b);

% p < .001
% Example write up:
%   There is a significantly larger evoked response (p<.001), on electrode 3,
%   for the face condition when compared to the object condition, the face 
%   condition evoked response being 122.4% larger than the object condition.





