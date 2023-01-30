function [Cycles_sx] = acceptorchangecycles_sx_withemg(Cycles_sx, t_imu, ...
    t_emg, wx_sx_smooth, emg_sx, fc_IMU, fc_EMG)


h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);

y(1) = subplot(2,1,1)
plot(t_imu,wx_sx_smooth, 'Color','#EDB120'),
ylabel('Angular Velocity')
xlabel('Time (s)')

for i=1:length(Cycles_sx.nCycle)

    hold on, zoom on
    xline(Cycles_sx.start_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2, ...
        'Label',sprintf(' START CYCLE n. %d ', Cycles_sx.nCycle(i)), ...
        'Color', 'b')
    xline(Cycles_sx.end_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2, ...
        'Label', sprintf(' END CYCLE n. %d ', Cycles_sx.nCycle(i)), ...
        'Color', 'r')
end
grid on, grid minor
t = title(['\bfCheck\rm for the Cycles \bfSTART and END point\rm for' ...
    ' the \bfLEFT FOOT\rm and press Enter to choose whether to ' ...
    'accept or change them'])
s = subtitle(['\rmBe sure to \bfmark down\rm which cycles ' ...
    'you want to change!'])
t.FontSize = 20;
t.FontAngle = "italic"
t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';
s.FontSize = 20;
s.FontAngle = "italic"
s.FontName = 'Century Gothic'

y(2) = subplot(2,1,2)
plot(t_emg, emg_sx, 'Color','#EDB120')
ylabel('EMG signal')
xlabel('Time (s)')
for i=1:length(Cycles_sx.nCycle)
    hold on, zoom on
    xline(Cycles_sx.start_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2, ...
        'Label',sprintf(' START CYCLE n. %d ', Cycles_sx.nCycle(i)), ...
        'Color', 'b')
    xline(Cycles_sx.end_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2, ...
        'Label', sprintf(' END CYCLE n. %d ', Cycles_sx.nCycle(i)), ...
        'Color', 'r')
end
grid on, grid minor
linkaxes(y, 'x')
ax = gca;
ax.XLim = [Cycles_sx.start_ind(1)/fc_IMU-2 Cycles_sx.end_ind(end)/fc_IMU+2];



while ~waitforbuttonpress
    % waitforbuttonpress returns 0 with click, 1 with key press
    % Does not trigger on ctrl, shift, alt, caps lock, num lock, or scroll lock

end

close(h.myfig)

h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
plot(t_imu, wx_sx_smooth, 'Color','#EDB120'),
ax = gca;
ax.XLim = [Cycles_sx.start_ind(1)/fc_IMU-2 Cycles_sx.end_ind(end)/fc_IMU+2];
ylabel('Angular Velocity')
xlabel('Time [sec]')
for i=1:length(Cycles_sx.nCycle)
    hold on, zoom on
    xline(Cycles_sx.start_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2, ...
        'Label',sprintf(' START CYCLE n. %d ', Cycles_sx.nCycle(i)), ...
        'Color', 'b')
    xline(Cycles_sx.end_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2, ...
        'Label', sprintf(' END CYCLE n. %d ', Cycles_sx.nCycle(i)), ...
        'Color', 'r')
end

opts.Interpreter = 'tex';
opts.Default = 'Accept';
answer = questdlg(['\fontsize{11}\fontname{Century Gothic}' ...
    'Do you accept these start and end points?'], ...
    'Accept or Change', ...
    'Accept','Choose which ones to change', 'Change All' , opts);

switch answer

    case 'Accept'

        Cycles_sx = Cycles_sx;

        close(h.myfig)


    case 'Choose which ones to change'

        close(h.myfig)

        for i=1:length(Cycles_sx.nCycle)
            list{i} = sprintf(' Cycle # %d',(Cycles_sx.nCycle(i)));
        end

        [listind2,tf] = listdlg('ListString',list,'Name','nCycle', ...
            'PromptString',['Select the cycles whose indices you want' ...
            ' to change:'],'OKString','Proceed','ListSize',[300,450]);
        [Cycles_sx] = changeindex_sx_withemg(listind2,t_imu, t_emg, wx_sx_smooth, ...
            emg_sx, Cycles_sx, fc_IMU, fc_EMG)

    case 'Change All'

        Cycles_sx = table;
        i = 1;

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        y(1) = subplot(2,1,1)
        plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time [sec]')
        t = title(['\rmchoose new \bfSTART point\rm for \bfcycle #' ...
            num2str(i) '\rm and press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        y(2) = subplot(2,1,2)
        plot(t_emg, emg_sx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time [sec]')
        grid minor
        linkaxes(y, 'x')

        [startind , y] = ginput();
        Cycles_sx.nCycle(i) = i;
        Cycles_sx.start_ind(i) = round(startind*fc_IMU);


        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        y(1) = subplot(2,1,1)
        plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time [sec]')
        t = title(['\rmchoose new \bfEND point\rm for \bfcycle #' ...
            num2str(i) '\rm and press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START CYCLE', 'Color', 'b')

        y(2) = subplot(2,1,2)
        plot(t_emg, emg_sx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time [sec]')
        grid minor
        xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START CYCLE', 'Color', 'b')
        linkaxes(y, 'x')

        [endind , y] = ginput();
        Cycles_sx.end_ind(i) = round(endind*fc_IMU);

        close(h.myfig)

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        y(1) = subplot(2,1,1)
        plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time [sec]')
        t = title(['\rmchoose new \bfEND point\rm for \bfcycle #' ...
            num2str(i) '\rm and press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START CYCLE', 'Color', 'b')
        xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' END CYCLE', 'Color', 'r')

        y(2) = subplot(2,1,2)
        plot(t_emg, emg_sx, 'Color','#EDB120'), hold on, zoom on
        ylabel('EMG signal')
        xlabel('Time [sec]')
        grid minor
        xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START CYCLE', 'Color', 'b')
        xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' END CYCLE', 'Color', 'r')
        linkaxes(y, 'x')



        opts.Interpreter = 'tex';
        opts.Default = 'Continue';
        answer1 = questdlg(['\fontsize{11}\fontname{Century Gothic}' ...
            'Do you want to continue for other cycles?'], ...
            'Continue or Stop', ...
            'Continue','Stop', opts);

        switch answer1

            case 'Continue'

                i = i+1
                q = 1;
                [Cycles_sx] = choosecycles_sx_withemg(Cycles_sx,t_imu, t_emg, ...
                    wx_sx_smooth, emg_sx, q, i, fc_IMU);
                close all

            case 'Stop'
                q = 0;
                close all

        end


end
end