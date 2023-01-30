function [heelstrike, toeoff, i] = modifyevents(Cycles, wx_dx_smooth, wx_sx_smooth, heelstrike, toeoff, fc_IMU, i)


while i <= length(Cycles.nCycle)

    close all

    a=1, b=1, h=1, j=1, HStoremove = [], TOtoremove = [], HStoadd = [], TOtoadd = [], events = [];
    start_imu = Cycles.start_ind(i)-fc_IMU;
    end_imu = Cycles.end_ind(i)+fc_IMU;

    if start_imu <= 0
        start_imu = 1;
    end
    if end_imu > length(wx_dx_smooth)
        end_imu = length(wx_dx_smooth)
    end

    events = [heelstrike.index(heelstrike.nCycle == i);toeoff.index(toeoff.nCycle == i)]
    nHS = length(heelstrike.index(heelstrike.nCycle == i));

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

    t = title(['Cycle #' num2str(i) ' Right Foot']), t.FontSize = 20, t.FontAngle = "italic",
    t.FontName = 'Century Gothic', t.Color = '#A2142F';
    s = subtitle(['\bfLeft click\rm to delete events, press \bfH\rm to add' ...
        ' Heelstrike, \bfT\rm to add Toeoff, \bfEnter\rm to proceed with next Cycle'])
    s.FontSize = 20, s.FontAngle = "italic", s.FontName = 'Century Gothic'

    [x,y,button] = ginput();

    if isempty(button) == 0
        for n=1:length(button)

            if button(n) == 104
                locmin = round(Cycles.start_ind(i)-(11/10*fc_IMU) + round(x(n)) + find(islocalmin(wx_dx_smooth(Cycles.start_ind(i)-ceil(11/10*fc_IMU) + round(x(n)):Cycles.start_ind(i)-ceil(9/10*fc_IMU) + round(x(n))),  'MaxNumExtrema',1)==1) - 1)
                if isempty(locmin) == 1
                    HStoadd(a,1) = start_imu + round(x(n));
                    HStoadd(a,2) = wx_dx_smooth(HStoadd(a,1));
                    a = a+1;
                else
                    HStoadd(a,1) = locmin;
                    HStoadd(a,2) = wx_dx_smooth(locmin);
                    a=a+1;
                end

            elseif button(n) == 116
                locmin = round(Cycles.start_ind(i)-(11/10*fc_IMU) + round(x(n)) + find(islocalmin(wx_dx_smooth(Cycles.start_ind(i)-ceil(11/10*fc_IMU) + round(x(n)):Cycles.start_ind(i)-ceil(9/10*fc_IMU) + round(x(n))),  'MaxNumExtrema',1)==1) - 1)
                if isempty(locmin) == 1
                    TOtoadd(b,1) = start_imu + round(x(n));
                    TOtoadd(b,2) = wx_dx_smooth(TOtoadd(b,1));
                    b=b+1;
                else
                    TOtoadd(b,1) = locmin;
                    TOtoadd(b,2) = wx_dx_smooth(locmin);
                    b=b+1;
                end

                elseif button(n) == 1
                    indtoremove = round(x(n) + start_imu)
                    [c indmin] = min(abs(indtoremove-events))
                    if indmin <= nHS
                        HStoremove(h) = events(indmin)
                        h=h+1;
                    else
                        TOtoremove(j) = events(indmin)
                        j=j+1;
                    end
                end
            end
        end

        if isempty(HStoremove)  == 0
            for n=1:length(HStoremove)
                heelstrike([find(heelstrike.index==HStoremove(n))], :) = [];
            end
        end

        if isempty(TOtoremove)  == 0
            for n=1:length(TOtoremove)
                toeoff([find(toeoff.index==TOtoremove(n))], :) = [];
            end
        end

        if isempty(TOtoadd) == 0
            for n=1:size(TOtoadd,1)
                toeoff.index(end+1) = TOtoadd(n,1)
                toeoff.peak(end) = TOtoadd(n,2)
                toeoff.phase(end) = "TO RF";
                toeoff.nCycle(end) = i;
            end
        end

        if isempty(HStoadd) == 0
            for n=1:size(HStoadd,1)
                heelstrike.index(end+1) = HStoadd(n,1);
                heelstrike.peak(end) = HStoadd(n,2);
                heelstrike.phase(end) = "HS RF";
                heelstrike.nCycle(end) = i;
            end
        end

        heelstrike = sortrows(heelstrike);
        toeoff = sortrows(toeoff);

        [i, heelstrike, toeoff] = acceptchanges(Cycles, wx_dx_smooth, wx_sx_smooth, heelstrike, toeoff, fc_IMU, i, start_imu, end_imu)


    end

end














