function [i, heelstrike_sx, toeoff_sx] = acceptchanges_sx(Cycles_sx, wx_dx_smooth, wx_sx_smooth, heelstrike_sx, toeoff_sx, fc_IMU, i, start_imu, end_imu)

figure('units','normalized','outerposition',[0 0 1 1]);

plot(wx_sx_smooth(start_imu:end_imu)),
hold on
plot(wx_dx_smooth(start_imu:end_imu), 'Color', [1 0 0 0.2])
scatter(heelstrike_sx.index(heelstrike_sx.nCycle == i)-start_imu, ...
    heelstrike_sx.peak(heelstrike_sx.nCycle == i), 'r', 'filled', 'o');
scatter(toeoff_sx.index(toeoff_sx.nCycle == i)-start_imu, ...
    toeoff_sx.peak(toeoff_sx.nCycle == i), 'b', 'filled', 'o');
zoom on
legend('Signal Right Foot', 'Signal Left Foot', 'Heel Strike', 'Toe Off')

t = title(['\rmCheck the events for \bfrep #' ...
    num2str(i) ' \rm, then press ENTER to continue']);
t.FontSize = 20;
t.FontAngle = "italic"
t.FontName = 'Century Gothic'
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
        [heelstrike_sx, toeoff_sx, i] = modifyevents_sx(Cycles_sx, wx_dx_smooth, wx_sx_smooth, heelstrike_sx, toeoff_sx, fc_IMU, i)

    case 'Modify'

        [heelstrike_sx, toeoff_sx, i] = modifyevents_sx(Cycles_sx, wx_dx_smooth, wx_sx_smooth, heelstrike_sx, toeoff_sx, fc_IMU, i)
end
end