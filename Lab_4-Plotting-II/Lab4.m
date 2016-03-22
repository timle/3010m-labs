
%% Plotting II
% This week we will continue learning about plotting in MATLAB. Covering
% some additional plot types, and manipulating plots through the command
% line. 


%% Line plot
% We learned to make simple line plots last week. The line plot is best
% suited for representing continuous signals. For us, a continuous signal
% will be, for the most part, time-series data, that is, an ordered sequence
% of samples representing a magnitude, over across equal intervals in time.

% load data for today:
load('pupil_diam_2.mat') %variable called pupil_diam

% Hark, a new variable type has appeared!
%
% This variable is called a struct (for structure). Structs are often used
% to help organize collections of data. In general, a struct has multiple
% fields (you can think of these like folders), and data is stored into
% these fields. The struct variable is separated from it's fields with a 
% '.' 
%
% For now, just remember the struct as primarily a tool for helping to 
%   organize data. 
%
% struct syntax looks like this:
%   example_struct.field_name = value
%
% an example:
example_struct.first_field = 1;
example_struct.second_field = [1:10];
example_struct.third_field = ones(4,4);
% Congrats, you just made your first struct!

% Lets take a look at the pupil_diam struct
% pupil_diam = 
%      p_1: [22x526 single]
%      p_2: [4x526 single]
%      p_3: [11x526 single]
%      ...
% Each field in the struct refers to a participant. The content of each 
% field follows the same convention as last class (rows = trials, columns = 
%   pupil diameter, over time)
%
% Accessing the data for a given participant is straight forward:
participant_1_trial_matrix = pupil_diam.p_1;
size(participant_1_trial_matrix)
participant_13_trial_matrix = pupil_diam.p_13;
% again note, pupil_diam is the struct variable, and the items following the 
%   '.' are the fields. The fields contain values like a variable normally
%   would. 


% Plotting a line plot with X axis and Y axis data
%   Grab the first trial from the 3rd participant
    signal = pupil_diam.p_3(1,:); %easy!
    figure %make figure window
%   last week, we were plotting data like this:
    plot(signal)
%   This is actually a shortcut. Glad we did the easy was first, right?
%
%   The shortcut is, that by only providing data points on the y axis
%   MATLAB simply creates the x axis based on the sample number.
    plot(signal)
%   is equivalent to
    xdata = 1:size(signal,2);
    ydata = signal;
    plot(xdata, ydata)
    
%   note the x data labels, on the plot, refers to sample number
% 
%   This shortcut is sometimes fine, but not often. In our case, the eye 
%       tracker records the pupil diameter 60 times a second. That means 
%       each sample in this data (each column) is 1 second / 60 = 16.6667 
%       milliseconds. We need to include this information in our plots.
%
%   So how much time does 526 samples represent?
    526 * (1 / 60)
%   8.77 seconds.
% 
%   How can we add this information to the plot? Surely it is important to
%   	know the scale at which the pupil diameter is changing.
% 
%   We have to create a vector to define time over the x axis
% 
%   Create x axis:
    sample_duration_in_seconds = (1 / 60);
    num_samples = size(signal, 2);
    time_ax = (1:num_samples) .* sample_duration_in_seconds;
%   plot signal with time axis
    plot(time_ax, signal)
%   add some labels
    xlabel('time (s)')
    ylabel('pupil diameter')
% This usage, plot(x_data, y_data), is much more typical in signal
% analysis. plot(y_data) is handy for trouble shooting, or testing
% new ideas, but for anything beyond, you will have to get in the 
% habit of including the x axis data (almost always time series points)



% Manipulating plot appearance in the command line
%   Last week we learned to change the way a plot looks using the plot
%   editor button. Though useful, this method of changing plot appearance
%   is not always convenient when building figures. So often, you will need
%   to rely on using commands to change appearance of figures. 

%   Interacting with figure objects (lines, axes, the legend, etc) is
%   generally performed in two ways. The first is passing arguments along
%   with the initial plot command. For example:
    plot_handle = plot(1:10,'linewidth',100,'color','r')
    text_handle = text(5.5,5.5, 'red stripe', 'fontsize',70,'horizontalalignment','center')
%   You can also alter appearance by using 'handles'. Any command that draws
%   an object on the figure window will create a handle. If you save the
%   handle to a variable (like I did above), you can use it to later change
%   appearance of that object. Handles essentially allow you to access any 
%   figure items from the workspace. This is a very useful feature in MATLAB.
%
%   Handles are a special type of variable. They look a bit like structs,
%   but have a bunch of extra code, within them, that runs whenever the 
%   values within in are changed. It's easiest to think of handles as little
%   computer programs that live in your workspace, ready to do your bidding
%   on the figure.
%
%   Handles list all the properties that can be changed in a graphics object:
    plot_handle % this is my line object, accessible as a variable
    text_handle % this is my text object, accessible as a variable
%
% Lets manipulate the figure properties using the handles.  
    text_handle.Rotation = 45;
    text_handle.FontName = 'Brush Script MT';
    text_handle.FontSize = 130;
    text_handle.Color = 'w';
%
%   color can be changed in two ways, with the color code shortcut
%
    text_handle.Color = 'r';
    text_handle.Color = 'g';
    text_handle.Color = 'b';
    text_handle.Color = 'k';
    text_handle.Color = 'y';
    text_handle.Color = 'm';
    
    % or with rbg values
    text_handle.Color = [1 1 1];
    text_handle.Color = [1 0 0];
    text_handle.Color = [0 1 0];
    text_handle.Color = [200 50 200]/255;
    clf

%   As an example, we will plot two participants trials, and each 
%       participants' mean signal
%
%   A.k.a our fanciest plot yet.
% 
%   data to plot
    partcp_1 = pupil_diam.p_3; 
    partcp_2 = pupil_diam.p_13; 
%   make time axis
    time_ax = (1:size(partcp_1,2)) .* (1/60);
%   prep figure
    clf
    hold on;
%   plot first 
    for cur_sig = partcp_1' % hey neat trick, why does this work!?
       p_1_hndls = plot(time_ax, cur_sig, 'color','b','linestyle',':');
    end
%   plot mean
    p_1_mean_hndl = plot(time_ax, mean(partcp_1),'linewidth',2,'color','b')
%   plot second 
    for cur_sig = partcp_2'
       p_2_hndls = plot(time_ax, cur_sig, 'color','r','linestyle',':');
    end
%   plot mean
    p_2_mean_hndl = plot(time_ax, mean(partcp_2),'linewidth',2,'color','r')
%   add a legend
    legend([p_1_mean_hndl, p_2_mean_hndl, p_1_hndls, p_2_hndls],...
        {'p 1 mean', 'p 2 mean','p 1','p 2'})
    
    % unpack the legend command
        % A new variable type appears!
        % Cell variables used to make lists of items where each item can
        % have a different length. With a matrix, each row must be the same
        % length. And so Cells are useful for lists of text, since text
        % lists seldom have items of matching length.
        % For the time being we will use cells for text lists, and not much
        % more.
        % the syntax for cell lists/arrays is simple, use {} instead of []
         my_list_of_equal_lengths = ['tim';'tom';'rod';'tod'];       
            % creates matrix
         my_list_of_unequal_lengths = ['hi';'hello';'holla';'hey'];       
            % creates matrix   
         my_list_of_unequal_lengths = {'hi';'hello';'holla';'hey'};       
         my_list_of_equal_lengths = {'tim';'tom';'rod';'tod'};       

    
    
 
% Line plots are great for continuous data. But what about other data
% types?
%   Participation question time!
% The bar plot
%   simulate class marks for 250 students, over 3 tests:
    simulated_class_marks = randi([1 80],250,3);
%   rows as students, tests as columns
    simulated_class_marks(:,2) = simulated_class_marks(:,2) * 1.2; % make the grades better on the second test
    simulated_class_marks(:,1) = simulated_class_marks(:,1) * .8; % make the grades worse on the first test
%   because the test means are columns, easy to do this:
    test_means = mean(simulated_class_marks);

%   how would you represent this data?
    clf
    bar_handle = bar(test_means);
%   lets add labels to bars    
    axis_handle = gca;
    % see: doc gca
    % for more information on why this works.
    axis_handle.XTickLabel = {'test 1','test 2','test 3'};  %a cell array!
    % alternative method:
    set(gca,'xticklabel',{'test 1','test 2','test 3'});

%   add some more marks:
    simulated_class_marks(:,4) = randi([1 30],250,1); %low grades
    simulated_class_marks(:,5) = randi([1 40],250,1);
    simulated_class_marks(:,6) = randi([10 50],250,1); %higher
    simulated_class_marks(:,7) = randi([20 60],250,1);
    simulated_class_marks(:,8) = randi([30 100],250,1); %higher still
%   now the list is 250 rows, representing students, and 8 columns 
%   representing tests.
%
%   I'd like to make a bar plot, for the mean of each test, with each
%   bar having a different color:
%   To do this, we need to use a loop, and plot each bar separately. 
%   Remember how the plot command takes arguments like this ?
%   plot(x_axis, y_axis) ?
%   The bar() command is no different, we'll take advantage of this 
%   feature now. 
    figure
    clf
    hold on;
    for ii = 1:size(simulated_class_marks,2)
        x_pos = ii;
        disp(['Plotting the first bar at x = ' num2str(x_pos)])

        test_number = ii;
        this_tests_marks = simulated_class_marks(:, test_number);
        this_tests_mean = mean(this_tests_marks);
        bar_h = bar(x_pos, this_tests_mean);
        bar_h.FaceColor = [ii/8 0 1];
        %here I am changing the face color of the bar based on the counter
        %values
        drawnow
        pause(.5)
    end

% In this example our counter variable (ii) is doing a lot of hard work. 
% What are the three things we are using it for?

% 1) X axis location
% 2) Test number to plot
% 3) Manipulating colour



%% task

% for participant 13, plot each trial in a blue dotted line.
% plot the max of all participant 13 trials value in thick blue
% plot the min of all participant 13 trials value in thick red
% plot the median of all participant 13 trials value in thick magenta
% be sure to include the time axis. 
% Bonus task - when plotting each trial, vary the color so that each trial
% is a different color.
%
% This code will be very similar to last week, but now you will also be
% changing the way the lines look as you plot them. 

%% your matlab code starts

load('pupil_diam_2.mat') %variable called pupil_diam

participant_13_trial_matrix = pupil_diam.p_13;



% start with last weeks code! No freebies from me today!


