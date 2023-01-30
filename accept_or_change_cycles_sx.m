function [Cycles_sx] = accept_or_change_cycles_sx(Cycles_sx, t_imu, ...
    wx_sx_smooth, fc_IMU)

% Plot the signal with the indices selected
h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);

plot(t_imu,wx_sx_smooth, 'Color','#EDB120'),
ylabel('Angular Velocity')
xlabel('Time (s)')

for i=1:length(Cycles_sx.nCycle)

    hold on, zoom on
    xline(Cycles_sx.start_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2,'Label' ...
        ,sprintf(' START REP #%d ', Cycles_sx.nCycle(i)), 'Color', 'b')
    xline(Cycles_sx.end_ind(Cycles_sx.nCycle(i))/fc_IMU,'LineWidth',2,'Label', ...
        sprintf(' END REP #%d ', Cycles_sx.nCycle(i)), 'Color', 'r')
end
grid on, grid minor

t = title(['\bfCheck\rm for \bfSTART and END points\rm of Reps for' ...
    ' \bfLEFT FOOT\rm, Enter to choose whether to accept or' ...
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
ax.XLim = [Cycles_sx.start_ind(1)/fc_IMU-2 Cycles_sx.end_ind(end)/fc_IMU+2];

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

        for i=1:length(Cycles_sx.nCycle)
            list{i} = sprintf(' Cycle # %d',(Cycles_sx.nCycle(i)));
        end

        [listind,tf] = listdlg('ListString',list,'Name','nCycle', ...
            'PromptString',['Select the reps whose indices you want to' ...
            ' change:'],'OKString','Proceed','ListSize',[300,450]);
        [Cycles_sx] = changeindex_sx(listind,t_imu, wx_sx_smooth, ...
            Cycles_sx, fc_IMU);


    case 'Change All'

        Cycles_sx = table;
        i = 1;

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on,
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
        Cycles_sx.nCycle(i) = i;
        Cycles_sx.start_ind(i) = round(startind*fc_IMU);

        close(h.myfig)


        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time (s)')
        t = title(['\rmchoose new \bfEND point\rm for \bfrep #' ...
            num2str(i) '\rm, then press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START REP', 'Color', 'b')
      
     

        [endind , y] = ginput();
        Cycles_sx.end_ind(i) = round(endind*fc_IMU);

        close(h.myfig)

        h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);
        plot(t_imu, wx_sx_smooth, 'Color','#EDB120'), hold on, zoom on,
        grid minor
        ylabel('Angular Velocity')
        xlabel('Time (s)')
        t = title(['\rmchoose new \bfEND point\rm for \bfrep #' ...
            num2str(i) '\rm and press ENTER'])
        t.FontSize = 20;
        t.FontAngle = "italic"
        t.FontName = 'Century Gothic'
        xline(Cycles_sx.start_ind/fc_IMU,'LineWidth',2,'Label', ...
            ' START REP', 'Color', 'b')
        xline(Cycles_sx.end_ind/fc_IMU,'LineWidth',2,'Label',' END REP', ...
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
                [Cycles_sx] = choosecycles_sx(Cycles_sx, t_imu, wx_sx_smooth, ...
                    q, i, fc_IMU);

            case 'end'
                q = 0;
                close all

        end

end

Turning = table;
for i=1:length(Cycles_sx.nCycle)-1
    Turning.start(i) = Cycles_sx.end_ind(i);
    Turning.end(i) = Cycles_sx.start_ind(i+1);
    Turning.id(i) = i;
end

end
