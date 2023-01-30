function statistic_analysis(LRdoubleStance, RLdoubleStance, LeftSwing, RightSwing)

mean_LRdoubleStance = mean(LRdoubleStance.duration);
mean_RLdoubleStance = mean(RLdoubleStance.duration);
mean_LeftSwing = mean(LeftSwing.duration);
mean_RightSwing = mean(RightSwing.duration);

std_LRdoubleStance = std(LRdoubleStance.duration);
std_RLdoubleStance = std(RLdoubleStance.duration);
std_LeftSwing = std(LeftSwing.duration);
std_RightSwing = std(RightSwing.duration);




figure('units','normalized','outerposition',[0 0 1 1])

subplot(2,2,1)
bar(LRdoubleStance.duration, 0.5, 'FaceColor', '#D95319'),
title('LRdoubleStances'), subtitle(['deviazione standard = ' ...
    num2str(round(std_LRdoubleStance,2)) ' e media = ' ...
    num2str(round(mean_LRdoubleStance,2)) 's']),
xlabel('index'), ylabel('Time (s)'), hold on,
yline(mean_LRdoubleStance, '--')

subplot(2,2,2)
bar(RLdoubleStance.duration, 0.5, 'FaceColor', '#EDB120'),
title('RLdoubleStances'), subtitle(['deviazione standard = ' ...
    num2str(round(std_RLdoubleStance,2)) ' e media = ' ...
    num2str(round(mean_RLdoubleStance,2)) 's']),
xlabel('Index'), ylabel('Time (s)'), hold on,
yline(mean_RLdoubleStance, '--')

subplot(2,2,3)
bar(LeftSwing.duration, 0.5, 'FaceColor', '#0072BD'),
title('Left Swings'), subtitle(['deviazione standard = ' ...
    num2str(round(std_LeftSwing,2)) ' e media = ' ...
    num2str(round(mean_LeftSwing,2)) 's']),
xlabel('index'), ylabel('Time (s)'), hold on,
yline(mean_LeftSwing, '--')

subplot(2,2,4)
bar(RightSwing.duration, 0.5, 'FaceColor', '#77AC30'),
title('Right Swings'), subtitle(['deviazione standard = ' ...
    num2str(round(std_RightSwing,2)) ' e media = ' ...
    num2str(round(mean_RightSwing,2)) 's']),
xlabel('index'), ylabel('Time (s)'), hold on,
yline(mean_RightSwing, '--')


figure('units','normalized','outerposition',[0 0 1 1])

subplot(2,2,1)
histogram(LRdoubleStance.duration, 15, 'FaceColor', '#D95319'),
title('LRdoubleStances'), subtitle(['deviazione standard = ' ...
    num2str(round(std_LRdoubleStance,2)) ' e media = ' ...
    num2str(round(mean_LRdoubleStance,2)) 's']),
xlabel('number of elements'), ylabel('Time (s)'), hold on,
xline(mean_LRdoubleStance, '--')

subplot(2,2,2)
histogram(RLdoubleStance.duration, 15,  'FaceColor', '#EDB120'),
title('RLdoubleStances'), subtitle(['deviazione standard = ' ...
    num2str(round(std_RLdoubleStance,2)) ' e media = ' ...
    num2str(round(mean_RLdoubleStance,2)) 's']),
xlabel('number of elements'), ylabel('Time (s)'), hold on,
xline(mean_RLdoubleStance, '--')

subplot(2,2,3)
histogram(LeftSwing.duration, 15,  'FaceColor', '#0072BD'),
title('Left Swings'), subtitle(['deviazione standard = ' ...
    num2str(round(std_LeftSwing,2)) ' e media = ' ...
    num2str(round(mean_LeftSwing,2)) 's']),
xlabel('number of elements'),
ylabel('Time (s)'), hold on,
xline(mean_LeftSwing, '--')

subplot(2,2,4)
histogram(RightSwing.duration, 15,   'FaceColor', '#77AC30'),
title('Right Swings'), subtitle(['deviazione standard = ' ...
    num2str(round(std_RightSwing,2)) ' e media = ' ...
    num2str(round(mean_RightSwing,2)) 's']),
xlabel('number of elements'), ylabel('Time (s)'), hold on,
xline(mean_RightSwing, '--')


figure('units','normalized','outerposition',[0 0 1 1])

subplot(2,2,1)
boxplot(LRdoubleStance.duration), title('LRdoubleStances'),
subtitle(['deviazione standard = ' num2str(round(std_LRdoubleStance,2)) ...
    ' e media = ' num2str(round(mean_LRdoubleStance,2)) 's']),
ylabel('Time (s)'), hold on, xline(mean_LRdoubleStance, '--')

subplot(2,2,2)
boxplot(RLdoubleStance.duration), title('RLdoubleStances'),
subtitle(['deviazione standard = ' num2str(round(std_RLdoubleStance,2)) ...
    ' e media = ' num2str(round(mean_RLdoubleStance,2)) 's']),
ylabel('Time (s)'), hold on, xline(mean_RLdoubleStance, '--')

subplot(2,2,3)
boxplot(LeftSwing.duration), title('Left Swings'),
subtitle(['deviazione standard = ' num2str(round(std_LeftSwing,2)) ...
    ' e media = ' num2str(round(mean_LeftSwing,2)) 's']),
ylabel('Time (s)'), hold on, xline(mean_LeftSwing, '--')

subplot(2,2,4)
boxplot(RightSwing.duration, 15), title('Right Swings'),
subtitle(['deviazione standard = ' num2str(round(std_RightSwing,2)) ...
    ' e media = ' num2str(round(mean_RightSwing,2)) 's']),
ylabel('Time (s)'), hold on, xline(mean_RightSwing, '--')

end