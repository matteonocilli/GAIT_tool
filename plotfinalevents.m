function plotfinalevents(wx_dx,Cycles, heelstrike, toeoff, wx_sx, Cycles_sx, heelstrike_sx, toeoff_sx, fc_IMU)

figure('units','normalized','outerposition',[0.5 0 0.5 1])

for i=1:length(Cycles.nCycle)
    p1 = plot(wx_dx, 'Color','#EDB120'),
    ax = gca;
    ax.XLim = [Cycles.start_ind(1)-2*fc_IMU Cycles.end_ind(end)+2*fc_IMU];
    hold on, zoom on
    xline(Cycles.start_ind(Cycles.nCycle(i)),'LineWidth',2, ...
        'Label',sprintf(' START REP #%d ', Cycles.nCycle(i)), ...
        'Color', 'b')
    xline(Cycles.end_ind(Cycles.nCycle(i)),'LineWidth',2,'Label', ...
        sprintf(' END REP #%d ', Cycles.nCycle(i)), 'Color', 'r')
end
hold on
p2 = scatter(heelstrike.index, heelstrike.peak, 'r', 'filled', 'o');
hold on
p3 = scatter(toeoff.index,toeoff.peak, 'b', 'filled', 'o');

title('GAIT ANALYSIS RIGHT FOOT')
legend([p1 p2 p3], {'Angular velocity around x axes', ...
    'heel strike', 'toe off'})


figure('units','normalized','outerposition',[0 0 0.5 1])

for i=1:length(Cycles_sx.nCycle)
    p5 = plot(wx_sx, 'Color','#EDB120'),
    ax = gca;
    ax.XLim = [Cycles_sx.start_ind(1)-2*fc_IMU Cycles_sx.end_ind(end)+2*fc_IMU];
    hold on, zoom on
    xline(Cycles_sx.start_ind(Cycles_sx.nCycle(i)),'LineWidth',2, ...
        'Label',sprintf(' START REP #%d ', Cycles_sx.nCycle(i)), 'Color', 'b')
    xline(Cycles_sx.end_ind(Cycles_sx.nCycle(i)),'LineWidth',2, ...
        'Label', sprintf(' END REP #%d ', Cycles_sx.nCycle(i)), ...
        'Color', 'r')
end
hold on
p6 = scatter(heelstrike_sx.index, heelstrike_sx.peak, 'r', 'filled', 'o');
hold on
p7 = scatter(toeoff_sx.index,toeoff_sx.peak, 'b', 'filled', 'o');

title('GAIT ANALYSIS LEFT FOOT')
legend([p5 p6 p7], {'Angular velocity around x axes', ...
    'heel strike', 'toe off'})
end