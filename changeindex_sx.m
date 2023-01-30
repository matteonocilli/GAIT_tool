function [Cycles_sx] = changeindex_sx(listind2,t_imu, wx_sx_smooth, Cycles_sx, fc_IMU)

% This function receives as input the list of cycles to be changed and makes
% the user change the start and end point directly from the plot for each 
% selected cycle 


i=1;
while i <= length(listind2)

    start_imu = Cycles_sx.start_ind(listind2(i))-5*fc_IMU;
    end_imu = Cycles_sx.end_ind(listind2(i))+5*fc_IMU;

     if i == 1 && start_imu<0
         start_imu = 1;
     end


    h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
    plot(t_imu(start_imu:end_imu), wx_sx_smooth(start_imu:end_imu), ...
        'Color','#EDB120'), hold on, zoom on, grid minor
    t = title(['\rmchoose new \bfSTART point\rm for \bfrep #' num2str(listind2(i)) '\rm, then press ENTER'])
    s = subtitle('If you don''t want to change the start point just press ENTER')
    t.FontSize = 18;
    t.FontAngle = "italic"
    t.FontName = 'Century Gothic'
    t.Color = 	'#A2142F';
    s.FontSize = 18;
    s.FontAngle = "italic"
    s.FontName = 'Century Gothic'
    xline(Cycles_sx.start_ind(listind2(i))/fc_IMU, 'Color', 'r', 'LineWidth', 2)
    xline(Cycles_sx.end_ind(listind2(i))/fc_IMU)
    
    [startind,y] = ginput();


    if length(startind) == 0

        Cycles_sx.start_ind(listind2(i)) = Cycles_sx.start_ind(listind2(i))
    else
        Cycles_sx.start_ind(listind2(i)) = round(startind*fc_IMU);
    end


    h.myfig = figure('units','normalized','outerposition',[0 0 1 1])
    plot(t_imu(start_imu:end_imu),wx_sx_smooth(start_imu:end_imu), ...
        'Color','#EDB120'), hold on, zoom on, grid minor
    t = title(['\rmchoose new \bfEND point\rm for \bfrep #' num2str(listind2(i)) '\rm, then press ENTER'])
    s = subtitle('If you don''t want to change the start point just press ENTER')
    t.FontSize = 18;
    t.FontAngle = "italic"
    t.FontName = 'Century Gothic'
    t.Color = 	'#A2142F';
    s.FontSize = 18;
    s.FontAngle = "italic"
    s.FontName = 'Century Gothic'
    xline(Cycles_sx.start_ind(listind2(i))/fc_IMU)
    xline(Cycles_sx.end_ind(listind2(i))/fc_IMU, 'Color', 'r', 'LineWidth', 2)
   

    [endind,y] = ginput();

    if length(endind) == 0
        Cycles_sx.end_ind(listind2(i)) = Cycles_sx.end_ind(listind2(i));
    else
        Cycles_sx.end_ind(listind2(i)) = round(endind*fc_IMU);

    end

close all
    
    i = i+1;
end





