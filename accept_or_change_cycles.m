function [Cycles, Turning] = accept_or_change_cycles(Cycles, t_imu, ...
    wx_dx_smooth, fc_IMU)

% This function is used to select or modify start and end points
% of a series of reps of walking. 
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

plot(t_imu,wx_dx_smooth, 'Color','#EDB120'),
ylabel('Angular Velocity')
xlabel('Time (s)')

for i=1:length(Cycles.nCycle)

    hold on, zoom on
    xline(Cycles.start_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label' ...
        ,sprintf(' START REP #%d ', Cycles.nCycle(i)), 'Color', 'b')
    xline(Cycles.end_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' END REP #%d ', Cycles.nCycle(i)), 'Color', 'r')
end
grid on, grid minor

t = title(['\bfCheck\rm for \bfSTART and END points\rm of Reps for' ...
    ' \bfRIGHT FOOT\rm, Enter to choose whether to accept or' ...
    ' change them'])
s = subtitle('\rmBe sure to \bfmark down\rm which reps you want to change!')
t.FontSize = 18;
t.FontAngle = "italic"
t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';
s.FontSize = 18;
s.FontAngle = "italic"
s.FontName = 'Century Gothic'
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
        [Cycles] = changeindex(listind,t_imu, wx_dx_smooth, ...
            Cycles, fc_IMU);


    case 'Change All'

        Cycles = table;
        i = 1;

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        plot(t_imu, wx_dx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time (s)')
        t = title(['\rmchoose new \bfSTART point\rm for \bfrep' ...
            ' #' num2str(i) '\rm, then press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        grid minor
        


        [startind , y] = ginput();
        Cycles.nCycle(i) = i;
        Cycles.start_ind(i) = round(startind*fc_IMU);

        close(h.myfig)


        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
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
        
     

        [endind , y] = ginput();
        Cycles.end_ind(i) = round(endind*fc_IMU);

        close(h.myfig)

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
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
        grid minor
      



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
                [Cycles] = choosecycles(Cycles, t_imu, wx_dx_smooth, ...
                    q, i, fc_IMU);

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
