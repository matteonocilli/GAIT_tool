function [Cycles, Turning] = acceptorchangecycles_withemg(Cycles, t_imu, t_emg, ...
    wx_dx_smooth, emg_dx, fc_IMU, fc_EMG)

% Plot the signal with the indices selected
h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);

y(1) = subplot(2,1,1)
plot(t_imu,wx_dx_smooth, 'Color','#EDB120'),
ylabel('Angular Velocity')
xlabel('Time [sec]')

for i=1:length(Cycles.nCycle)

    hold on, zoom on
    xline(Cycles.start_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label' ...
        ,sprintf(' START CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'b')
    xline(Cycles.end_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' END CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'r')
end
grid on, grid minor

t = title(['\bfCheck\rm for the Cycles \bfSTART and END point\rm for the' ...
    ' \bfRIGHT FOOT\rm and press Enter to choose whether to accept or' ...
    ' change them'])
s = subtitle('\rmBe sure to \bfmark down\rm which cycles you want to change!')
t.FontSize = 20;
t.FontAngle = "italic"
t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';
s.FontSize = 20;
s.FontAngle = "italic"
s.FontName = 'Century Gothic'

y(2) = subplot(2,1,2)
plot(t_emg, emg_dx, 'Color','#EDB120')
ylabel('EMG signal')
xlabel('Time [sec]')
for i=1:length(Cycles.nCycle)
    hold on, zoom on
    xline(Cycles.start_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' START CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'b')
    xline(Cycles.end_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' END CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'r')
end
grid on, grid minor
linkaxes(y, 'x')
ax = gca;
ax.XLim = [Cycles.start_ind(1)/fc_IMU-2 Cycles.end_ind(end)/fc_IMU+2];



while ~waitforbuttonpress
end

close(h.myfig)

h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
plot(t_imu, wx_dx_smooth, 'Color','#EDB120'),
ax = gca;
ax.XLim = [Cycles.start_ind(1)/fc_IMU-2 Cycles.end_ind(end)/fc_IMU+2];
ylabel('Angular Velocity')
xlabel('Time [sec]')
for i=1:length(Cycles.nCycle)
    hold on, zoom on
    xline(Cycles.start_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' START CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'b')
    xline(Cycles.end_ind(Cycles.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' END CYCLE n. %d ', Cycles.nCycle(i)), 'Color', 'r')
end

% User choice between accepting or modifying indexes
opts.Interpreter = 'tex';
opts.Default = 'Accept';
answer = questdlg(['\fontsize{11}\fontname{Century Gothic}Do you accept' ...
    ' these start and end points?'], ...
    'Accept or Change', ...
    'Accept','Choose which ones to change', 'Change All' , opts);

switch answer

    case 'Accept'

        close(h.myfig)


    case 'Choose which ones to change'

        close(h.myfig)

        for i=1:length(Cycles.nCycle)
            list{i} = sprintf(' Cycle # %d',(Cycles.nCycle(i)));
        end

        [listind,tf] = listdlg('ListString',list,'Name','nCycle', ...
            'PromptString',['Select the cycles whose indices you want to' ...
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
        xlabel('Time [sec]')
        t = title(['\rmchoose new \bfSTART point\rm for \bfcycle' ...
            ' #' num2str(i) '\rm and press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        y(2) = subplot(2,1,2)
        plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time [sec]')
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
        xlabel('Time [sec]')
        t = title(['\rmchoose new \bfEND point\rm for \bfcycle #' ...
            num2str(i) '\rm and press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START CYCLE', 'Color', 'b')

        y(2) = subplot(2,1,2)
        plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time [sec]')
        grid minor
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START CYCLE', ...
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
        xlabel('Time [sec]')
        t = title(['\rmchoose new \bfEND point\rm for \bfcycle #' ...
            num2str(i) '\rm and press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START CYCLE', 'Color', 'b')
        xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', ...
            'Color', 'r')

        y(2) = subplot(2,1,2)
        plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time [sec]')
        grid minor
        xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START CYCLE', 'Color', 'b')
        xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', ...
            'Color', 'r')
        linkaxes(y, 'x')



        opts.Interpreter = 'tex';
        opts.Default = 'Continue';
        answer1 = questdlg(['\fontsize{11}\fontname{Century Gothic}' ...
            'Do you want to continue for other cycles?'], ...
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
