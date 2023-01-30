function [Cycles_sx] = choosecycles_sx_withemg(Cycles_sx,t_imu, t_emg, wx_sx_smooth, emg_sx, q, i, fc_IMU)

% This function allows the user to choose from scratch the start and
% end points of Cycles for the left foot


while q == 1;
    h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    y(1) = subplot(2,1,1)
    plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on, grid minor
    ylabel('Angular Velocity')
    xlabel('Time (s)')
    t = title(['\rmchoose new \bfSTART point\rm for \bfrep #' num2str(i) '\rm, then press ENTER'])
    t.FontSize = 18;
    t.FontAngle = "italic"
    t.FontName = 'Century Gothic'
    xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label',' START REP', 'Color', 'b')
    xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', 'Color', 'r')
    y(2) = subplot(2,1,2)
    plot(t_emg, emg_sx, 'Color','#EDB120'), hold on, zoom on
    ylabel('EMG signal')
    xlabel('Time (s)')
    grid minor
    linkaxes(y, 'x')
    xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label',' START REP', 'Color', 'b')
    xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', 'Color', 'r')

    [startind , y] = ginput();
    Cycles_sx.nCycle(i) = i;
    Cycles_sx.start_ind(i) = round(startind*fc_IMU);


    h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    y(1) = subplot(2,1,1)
    plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on, grid minor
    ylabel('Angular Velocity')
    xlabel('Time (s)')
    t = title(['\rmchoose new \bfSTART point\rm for \bfrep #' num2str(i) '\rm, then press ENTER'])
    t.FontSize = 18;
    t.FontAngle = "italic"
    t.FontName = 'Century Gothic'
    xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label',' START REP', 'Color', 'b')
    xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', 'Color', 'r')
    y(2) = subplot(2,1,2)
    plot(t_emg, emg_sx, 'Color','#EDB120'), hold on, zoom on
    ylabel('EMG signal')
    xlabel('Time (s)')
    grid minor
    linkaxes(y, 'x')
    xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label',' START REP', 'Color', 'b')
    xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', 'Color', 'r')



    [endind , y] = ginput();
    Cycles_sx.end_ind(i) = round(endind*fc_IMU);

    close(h.myfig)

    h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    y(1) = subplot(2,1,1)
    plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on, grid minor
    ylabel('Angular Velocity')
    xlabel('Time (s)')
    xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label',' START REP', 'Color', 'b')
    xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', 'Color', 'r')
    y(2) = subplot(2,1,2)
    plot(t_emg, emg_sx, 'Color','#EDB120'), hold on, zoom on
    ylabel('EMG signal')
    xlabel('Time (s)')
    grid minor
    linkaxes(y, 'x')
    xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label',' START REP', 'Color', 'b')
    xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', 'Color', 'r')


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
            close(h.myfig)

        case 'Stop'
            q = 0;
            close(h.myfig)

    end
end



end