
%% Lab 3

%% Jumping right in from last lecture
% What were the two big programming concepts we learned last week?
%   1) Loops
%   2) Indexing
%   3) and...


%% if statements
%   if statements are the final of the 'fundamental' concepts for programming
%   in MATLAB we will learn for now. 
%   Loops are for repetition. 
%   Indexing is for situational awareness. 
%   'If statements' are for making decisions. 
%   With these  three concepts in mind, given enough time, almost any idea 
%   can be programmed in MATLAB.


% Remember booleans from previous classes? True/False or 1/0
%   We can use booleans with if statements to craft fairly complex logic
%   tests

% A quick refresher (or intro) to logic operators
    isequal(100,200) %false
    isequal(100,100) %true

%   Logic operators are very handy for chaining together several conditions.
%         We will use ISEQUAL (==), AND (&), OR (|), and NOT(~) in this class.
% 
%   Syntax? Two different ways to write logic operators:

    a = true
    b = true
    
    result_egality = a == b %true
    result_egality =a == 7 % false
    
    result_and = and(a,b) % true, both values are true
    result_and = a & b

    result_or = or(a,b) % true, at least one value is true
    result_or = a | b

    result_not = not(a)
    result_not = ~a

% do AND, OR, NOT, truth tables on white board

%   example truth tables in matlab:
    a = logical([1 1 0 0])'; %logical() converts number to True/False, in this case, I use it so tables are easier to read
    b = logical([1 1 0 0])';
%   IS EQUAL TABLE
    disp(table(a, b, a == b,'variablenames', {'A','B','isequal'})) %disp() prints result to command window. table() combines variables into easy to read table form.
%   AND table
    disp(table(a, b, a & b,'variablenames', {'A','B','AND'}))
%   OR table
    disp(table(a, b, a | b,'variablenames', {'A','B','OR'}))
%    NOT table
    disp(table(a, ~a,'variablenames', {'A','NOT'}))
% 
%   a slightly more complicated example
     disp(table(a, b, a & b, a & ~ b, (a & ~ b) | b, 'variablenames', {'A','B','A_AND_B','A_AND_NOT_B','A_AND_NOT_B__OR_B'}))
% 
%      deeper reading (for those interested):
%         https://en.wikipedia.org/wiki/Logical_conjunction
%         https://en.wikipedia.org/wiki/Logical_disjunction
%         https://en.wikipedia.org/wiki/Logical_equality
%       another (slightly) more complex example:
        a = [1 1 1 2 2 2]
        b = [1 1 1 1 1 1]
        c = [3 5 3 6 3 7]

        a == 2 & b == 1 & c == 3
        % will return true where the values are euqal to all three of these conditions

    
% Back to if satements!
% 
% example if statement #1
    my_boolean = true
    disp('is my_boolean equal to true?');
    if my_boolean
       disp('yes, my my_boolean is equal to true') 
    end

% example if statement #2
    my_boolean = false
    disp('is my_boolean equal to false?');
    if my_boolean == false
       disp('yes, my my_boolean is equal to false') 
    end

% 'my_boolean == false' is equivlent to 'isequal(my_boolean, false)'
    if isequal(my_boolean, false)
       disp('it''s false!') 
    end
    
% example if statement #3
    disp('is my_boolean equal to false?');
    my_boolean = true
    if my_boolean == false
       disp('it''s false!') 
    end
    % nothing displayed! because my_boolean is not false


%% (note lab 2 ended here)


% let's pickup from last class, and load the grades file:
load('grades.mat')


% what do you think will happen here, if the mean is 24.8?
if mean(grades) < 25
   disp('The average is very low!') 
end
if mean(grades) > 75
   disp('The average is very high!') 
end
if (mean(grades) > 25) & (mean(grades) < 75) %can use the & (like we talked about above) to chain boolean statements together
   disp('The average is just right!') 
end




% A final note on if statements:
%   A programmer is going to the grocery store and his wife tells him, 
%   "Buy a gallon of milk, and if there are eggs, buy a dozen." So the 
%   programmer goes, buys everything, and drives back to his house. Upon 
%   arrival, his wife angrily asks him, "Why did you get 13 gallons of 
%   milk?" The programmer says, "There were eggs!"

    milk = 1
    eggs = true
    if eggs
        milk = milk + 12
    end



%% The MATrix

% First, load the following file:
load('pupil_diam.mat') %creates variable pupil_diam
% 
%   a little about the 'pupil_diam' variable in this file:
%       This data is pupil diameter from a single participant over 11 trials
%       The pupil diameter data was recorded by an eye tracker
%       For each trial, an image shown on screen, and in response 
%           a change in pupil size should be visible in the data.
% 
% The pupil_diam variable is our first matrix! We couldn't avoid it forever.
%
% pupil_diam:
%   Each row is a trial
%   Each column is a sample of data in time (the diameter of the pupil over time)
size(pupil_diam)
%   11 trials
%   Each trial is 525 samples long. Side note: 'Samples' in signal processing means 'data
%   point' from a continuous signal. Not size of participant pool, like in statistics! 
% 
% This format (rows as trials, columns as samples from time series data) is
%   very common in MATLAB, and for good reason, it takes advantage of the
%   default behaviour of many MATLAB commands. 

% Indexing a matrix
% Remeber, with a vector, we just had to provide one argument for indexing:
example = 1:10;
example(4) ==  4 %true

% With a matrix, specify two arguments for indexing, one for the
% row and one for the column.
example = randi(4,4) % generate a 4x4 matrix of random numbers

example(2,3) %from the 2nd row, 3rd column, return the value

example(4,3) %from the 4th row, 3rd column, return the value

example(:,2) %for all rows, return the values on the 2nd column

example(4,:) %for the 4th row, return the values on all columns


% In our pupil_diam variable, because each trial is a row, you can use
% matrix indexing to extract out a given trial:

trial_example = pupil_diam(1,:) % "all coloumns of first row" or "from the first trial, all time points"

trial_example = pupil_diam(4,:) %for the 4th trial

trial_example = pupil_diam(1, 1:100) %first trial, timepoints 1 to 100


% before we go any furthur, it's time to learn basics of plotting


%% plotting
% basics:
%   lets look at one example
    trial_1 = pupil_diam(1,:) % "give me the first trial (row 1), and all data from that trial (all the columns)"
    size(trial_1) % check the size

%   what does the data look like?
%       lets try the variable editor
    open('trial_1')
%       not very helpful, lets try visualizing instead
%       close the variable editor

% our first plot:
    figure %create a figure, dock it manually
    plot(trial_1)
%   add some labels
    ylabel('Pupil diameter')
    xlabel('Sample #')
    title('The first trial')

%   explain plot tools interface

%   saving figures using the UI

%   clear the plot (without closing figure window)
    clf %clear figure

%   close all figure windows
    close all


% plotting multiple trials on the same figure
    figure
    plot(pupil_diam(1,:))
    plot(pupil_diam(2,:))
    plot(pupil_diam(3,:))
%   each plot replaces the previous, how do we prevent this?
    clf %clear figure
    hold on 
    %   Tells matlab to hold any figure contents, instead of clearing, each time the plot() command is called 
    plot(pupil_diam(1,:))
    plot(pupil_diam(2,:))
    plot(pupil_diam(3,:))
%      now there will be 3 lines in the figure window


% plotting in a loop - remember loops?!
%   plot the first five trials from the pupil_diam matrix
    clf % clear the figure window
    hold on % tell matlab not to overwrite figures each time plot() is run
    my_counter = 1:5
    for ii = my_counter
        current_trial = pupil_diam(ii,:);
        plot(current_trial)
    end
 %  this is quite convinient if you wish to plot many trials


%   lets plot all the trials, along with the mean of all trials
    clf % clear the figure window
    hold on % tell matlab not to overwrite figures each time plot() is run
    number_trials = size(pupil_diam, 1) % number of rows
    for ii = 1:number_trials
        current_trial = pupil_diam(ii,:);
        plot(current_trial)
    end
    %calculate the mean
    mean_of_trials = mean(pupil_diam)
    plot(mean_of_trials,'linewidth',4)%we'll talk a bit more about commands like 'linewidth' next week
    
    
% a note on the mean() command
% Remember this?
%   This format (rows as trials, columns as samples from time series data) is
%       very common in MATLAB, and for good reason, it takes advantage of the
%       default behaviour of many MATLAB commands. 
% mean() is the first command that we will learn which takes advantage of
%   this matrix structure.
%
% By default, when the mean() command is given a matrix, MATLAB will return 
% the mean of each column of the matrix. 
% This is exactly how we calculate the mean of a number of signals, if each
%   signal is represented by a row in the matrix. 
%   For each time point (columns) take the mean of all trials at that time
%   point.
%
% Explained another way (from the MATLAB technical documentation):
    doc mean
%   M = mean(A) returns the mean of the elements of A along the first array 
%       dimension whose size does not equal 1
%   If A is a vector, then mean(A) returns the mean of the elements.
%   If A is a matrix, then mean(A) returns a row vector containing the mean 
%       of each column.
%
% Another example:
    my_mat = repmat(1:6,5,1)
    mean(my_mat)
    % same as this:
    [mean(my_mat(:,1)) mean(my_mat(:,2)) mean(my_mat(:,3)) mean(my_mat(:,4)) mean(my_mat(:,5)) mean(my_mat(:,6))]




% Plotting a subset of the data:
%   plot only the first 200 samples
    clf % clear current figure
    hold on
    number_trials = size(pupil_diam, 1) % number of rows
    for ii = 1:number_trials
        current_trial = pupil_diam(ii,1:200);
        plot(current_trial)
    end




%% Ttask
% Plot only trials whos evoked response is greater than the mean Evoked response
% Evoked response is the difference between the pupil before and after the
% image presentaiton.
% to simplify the task, use only the first 200 samples of each trial, and
% consider the difference between the max and min of those 200 samples the
% value of the evoked response
%
% Calculate the evoked repose like this: max(trial) - min(trial)

% ## Your code starts here

% I've given you a few hits, to help you along the way:
clf 
hold on

pupil_diam_reduced = pupil_diam(:, 1:200) % could also be pupil_diam(1:11, 1:200)

mean_signal = %your code here, calculate the mean for pupil_diam_reduced
% your mean_signal matrix will be 11 x 200 (11 rows by 200 columns)

mean_evoked_size = max(mean_signal) - min(mean_signal)

%% 
number_trials = size(pupil_diam_reduced, 1) % number of rows
for ii = 1:number_trials
    current_trial = pupil_diam_reduced(ii,:);
    
    current_trial_max = %find the max
    current_trial_min = %find the min
    current_trial_evoked_size = %calculate evoked response
    
    if %if current_trial_evoked_size is bigger than  mean_evoked_size
        %plot the trial
    end
    
end


%finally, plot the mean signal


% ## Your code ends here
