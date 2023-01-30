function [i, heelstrike, toeoff] = acceptchanges(Cycles, wx_dx_smooth, wx_sx_smooth, heelstrike, toeoff, fc_IMU, i, start_imu, end_imu)

figure('units','normalized','outerposition',[0 0 1 1]);

plot(wx_dx_smooth(start_imu:end_imu)),
hold on
plot(wx_sx_smooth(start_imu:end_imu), 'Color', [1 0 0 0.2])
scatter(heelstrike.index(heelstrike.nCycle == i)-start_imu, ...
    heelstrike.peak(heelstrike.nCycle == i), 'r', 'filled', 'o');
scatter(toeoff.index(toeoff.nCycle == i)-start_imu, ...
    toeoff.peak(toeoff.nCycle == i), 'b', 'filled', 'o');
zoom on
legend('Signal Right Foot', 'Signal Left Foot', 'Heel Strike', 'Toe Off')

t = title(['\rmCheck the events for \bfrep #' ...
    num2str(i) ' \rm, then press ENTER to continue']);
t.FontSize = 20, t.FontAngle = "italic", t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';

opts.Interpreter = 'tex';
opts.Default = 'Accept';
answer = questdlg(['\fontsize{11}Do you accept' ...
    ' these events?'], ...
    'Accept or Modify', ...
    'Accept','Modify', opts);

switch answer

    case 'Accept'

        i = i+1;
        [heelstrike, toeoff, i] = modifyevents(Cycles, wx_dx_smooth, wx_sx_smooth, heelstrike, toeoff, fc_IMU, i)

    case 'Modify'

        [heelstrike, toeoff, i] = modifyevents(Cycles, wx_dx_smooth, wx_sx_smooth, heelstrike, toeoff, fc_IMU, i)
end
end