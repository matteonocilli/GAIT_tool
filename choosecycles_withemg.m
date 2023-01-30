function [Cycles] = choosecycles_withemg(Cycles,t_imu, t_emg, wx_dx_smooth, emg_dx, q, i, fc_IMU)

% This function allows the user to choose from scratch the start and
% end points of Cycles for the right foot


while q == 1;
    h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    y(1) = subplot(2,1,1)
    plot(t_imu, wx_dx_smooth, 'Color','#EDB120'), hold on, zoom on, grid minor
    ylabel('Angular Velocity')
    xlabel('Time [sec]')
    t = title(['\rmchoose new \bfSTART point\rm for \bfcycle #' num2str(i) '\rm and press ENTER'])
    t.FontSize = 20;
    t.FontAngle = "italic"
    t.FontName = 'Century Gothic'
    xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START CYCLE', 'Color', 'b')
    xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', 'Color', 'r')
    y(2) = subplot(2,1,2)
    plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
    ylabel('EMG signal')
    xlabel('Time [sec]')
    grid minor
    linkaxes(y, 'x')
    xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START CYCLE', 'Color', 'b')
    xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', 'Color', 'r')

    [startind , y] = ginput();
    Cycles.nCycle(i) = i;
    Cycles.start_ind(i) = round(startind*fc_IMU);

    close(h.myfig)


    h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    y(1) = subplot(2,1,1)
    plot(t_imu, wx_dx_smooth, 'Color','#EDB120'), hold on, zoom on, grid minor
    ylabel('Angular Velocity')
    xlabel('Time [sec]')
    t = title(['\rmchoose new \bfSTART point\rm for \bfcycle #' num2str(i) '\rm and press ENTER'])
    t.FontSize = 20;
    t.FontAngle = "italic"
    t.FontName = 'Century Gothic'
    xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START CYCLE', 'Color', 'b')
    xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', 'Color', 'r')
    y(2) = subplot(2,1,2)
    plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
    ylabel('EMG signal')
    xlabel('Time [sec]')
    grid minor
    linkaxes(y, 'x')
    xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START CYCLE', 'Color', 'b')
    xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', 'Color', 'r')

    [endind , y] = ginput();
    Cycles.end_ind(i) = round(endind*fc_IMU);

    close(h.myfig)

    h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    y(1) = subplot(2,1,1)
    plot(t_imu, wx_dx_smooth, 'Color','#EDB120'), hold on, zoom on, grid minor
    ylabel('Angular Velocity')
    xlabel('Time [sec]')
    xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START CYCLE', 'Color', 'b')
    xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', 'Color', 'r')
    y(2) = subplot(2,1,2)
    plot(t_emg, emg_dx, 'Color','#EDB120'), hold on, zoom on
    ylabel('EMG signal')
    xlabel('Time [sec]')
    grid minor
    linkaxes(y, 'x')
    xline(Cycles.start_ind/fc_IMU,'LineWidth',2,'Label',' START CYCLE', 'Color', 'b')
    xline(Cycles.end_ind/fc_IMU,'LineWidth',2,'Label',' END CYCLE', 'Color', 'r')


    opts.Interpreter = 'tex';
    opts.Default = 'Continue';
    answer1 = questdlg('\fontsize{11}\fontname{Century Gothic}Do you want to continue for other cycles?', ...
        'Continue or Stop', ...
        'Continue','Stop', opts);

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