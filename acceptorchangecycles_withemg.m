function [Cycles, Turning] = acceptorchangecycles_withemg(Cycles, t_imu, t_emg, ...
    wx_dx_smooth, emg_dx, fc_IMU, fc_EMG)

% This function is used to select or modify start and end points
% of a series of reps of walking when EMG signals are included. 
% The function creates a figure with two subplots, one for the
% angular velocity and one for the EMG signal, used as an additional aid 
% to the user.
% The reps are indicated by the vertical blue lines (start) and 
% red lines (end) on the plot, which are annotated with their rep number.
% 
% The function displays the plot and waits for the user to choose whether
% to accept the reps or modify them. If the user chooses to accept, 
% the plot is closed. If the user chooses to modify, they are prompted 
% to select which reps to change. If the user chooses to change all reps,
% new start and end points for each cycle are selected interactively by
% clicking on the plot.
% 
% The output is the modified Cycles table.

h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);

y(1) = subplot(2,1,1)
plot(t_imu,wx_dx_smooth, 'Color','#EDB120'),
ylabel('Angular Velocity')
xlabel('Time (s)')

for i=1:length(Cycles.nCycle)

    hold on, zoom on
    xline(Cycles.start_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label' ...
        ,sprintf(' START CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'b')
    xline(Cycles.end_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' END CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'r')
end
grid on, grid minor

t = title(['\bfCheck\rm for \bfSTART and END points\rm of Reps for' ...
    ' \bfRIGHT FOOT\rm, Enter to choose whether to accept or' ...
    ' change them'])
s = subtitle('\rmBe sure to \bfmark down\rm which cycles you want to change!')
t.FontSize = 18;
t.FontAngle = "italic"
t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';
s.FontSize = 18;
s.FontAngle = "italic"
s.FontName = 'Century Gothic'

y(2) = subplot(2,1,2)
plot(t_emg, emg_dx, 'Color','#EDB120')
ylabel('EMG signal')
xlabel('Time (s)')
for i=1:length(Cycles.nCycle)
    hold on, zoom on
    xline(Cycles.start_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' START REP n. %d ', Cycles.nCycle(i)), 'Color', 'b')
    xline(Cycles.end_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' END REP n. %d ', Cycles.nCycle(i)), 'Color', 'r')
end
grid on, grid minor
linkaxes(y, 'x')
ax = gca;
ax.XLim = [Cycles.start_ind(1)/fc_IMU-2 Cycles.end_ind(end)/fc_IMU+2];



pause;


% User choice between accepting or modifying indexes
opts.Interpreter = 'tex';
opts.Default = 'Accept';
answer = questdlg(['\fontsize{11}\fontname{Arial}Do you accept' ...
    ' these start and end points?'], ...
    'Accept or Change', ...
    'Accept','Choose which ones to change', 'Change All' , opts);

switch answer

    case 'Accept'

        close(h.myfig)


    case 'Choose which ones to change'

        close(h.myfig)

        for i=1:length(Cycles.nCycle)
            list{i} = sprintf(' Rep # %d',(Cycles.nCycle(i)));
        end

        [listind,tf] = listdlg('ListString',list,'Name','Choose Reps to edit', ...
            'PromptString',['Select the reps whose indices you want to' ...
            ' change:'],'OKString','Proceed','ListSize',[300,450]);
        [Cycles] = changeindex_withemg(listind,t_imu, t_emg, wx_dx_smooth, ...
            emg_dx, Cycles, fc_IMU, fc_EMG);


    case 'Change All'

        Cycles = table;
        i = 1;

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        y(1) = subplot(2,1,1)
        plot(t_imu, wx_dx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time (s)')
        t = title(['\rmchoose new \bfSTART point\rm for \bfrep' ...
            ' #' num2str(i) '\rm, then press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        y(2) = subplot(2,1,2)
        plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time (s)')
        grid minor
        linkaxes(y, 'x')


        [startind , y] = ginput();
        Cycles.nCycle(i) = i;
        Cycles.start_ind(i) = round(startind*fc_IMU);

        close(h.myfig)


        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        y(1) = subplot(2,1,1)
        plot(t_imu, wx_dx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time (s)')
        t = title(['\rmchoose new \bfEND point\rm for \bfrep #' ...
            num2str(i) '\rm, then press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START REP', 'Color', 'b')

        y(2) = subplot(2,1,2)
        plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time (s)')
        grid minor
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START REP', ...
            'Color', 'b')
        linkaxes(y, 'x')




        [endind , y] = ginput();
        Cycles.end_ind(i) = round(endind*fc_IMU);

        close(h.myfig)

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        y(1) = subplot(2,1,1)
        plot(t_imu, wx_dx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time (s)')
        t = title(['\rmchoose new \bfEND point\rm for \bfrep #' ...
            num2str(i) '\rm, then press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START REP', 'Color', 'b')
        xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', ...
            'Color', 'r')

        y(2) = subplot(2,1,2)
        plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time (s)')
        grid minor
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START REP', 'Color', 'b')
        xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', ...
            'Color', 'r')
        linkaxes(y, 'x')



       
        opts.Interpreter = 'tex';
        opts.Default = 'Continue';
        answer1 = questdlg(['\fontsize{11}\fontname{Arial}' ...
            'Do you want to add other reps?'], ...
            'Continue or Stop', ...
            'Continue','End', opts);

        switch answer1

            case 'Continue'

                i = i+1
                q = 1;
                close all
                [Cycles] = choosecycles_withemg(Cycles, t_imu, t_emg, wx_dx_smooth, ...
                    emg_dx, q, i, fc_IMU);

            case 'end'
                q = 0;
                close all

        end

end

Turning = table;
for i=1:length(Cycles.nCycle)-1
    Turning.start(i) = Cycles.end_ind(i);
    Turning.end(i) = Cycles.start_ind(i+1);
    Turning.id(i) = i;
end

end
