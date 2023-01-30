function overcoming(RightSwing, LeftSwing, allGaitCycles, wx_dx,wx_sx, Cycles, Cycles_sx, fc_IMU, heelstrike, toeoff, heelstrike_sx, toeoff_sx)


seventyfive_perc_RS = prctile(RightSwing.duration, 75);
twentyfive_perc_RS =  prctile(RightSwing.duration, 25);
range_perc_RS = seventyfive_perc_RS - twentyfive_perc_RS;
UIF_RS = seventyfive_perc_RS + 1.5*range_perc_RS;
LIF_RS = twentyfive_perc_RS-1.5*range_perc_RS;

seventyfive_perc_LS = prctile(LeftSwing.duration, 75);
twentyfive_perc_LS =  prctile(LeftSwing.duration, 25);
range_perc_LS = seventyfive_perc_LS - twentyfive_perc_LS;
UIF_LS = seventyfive_perc_LS + 1.5*range_perc_LS;
LIF_LS = twentyfive_perc_LS-1.5*range_perc_LS;

n=1;
outlier_RS = table;
for i=1:length(RightSwing.duration)

    if RightSwing.duration(i) > UIF_RS

        outlier_RS.duration(n) = RightSwing.duration(i);
        outlier_RS.index(n) = RightSwing.Index(i);
        outlier_RS.nCycle(n) = RightSwing.WalkSequenceID(i);
        n=n+1;

    end
end


r=1;
outlier_LS = table;
for i=1:length(LeftSwing.duration)

    if LeftSwing.duration(i) > UIF_LS

        outlier_LS.duration(r) = LeftSwing.duration(i);
        outlier_LS.index(r) = LeftSwing.Index(i);
        outlier_LS.nCycle(r) = LeftSwing.WalkSequenceID(i);
        r=r+1;

    end
end


if n > 1 && r>1

    n=1;
    overcomings = table;

    for i=1:length(outlier_LS.nCycle)
        for j=1:length(outlier_RS.nCycle)

            if outlier_LS.nCycle(i) == outlier_RS.nCycle(j)

                if abs(outlier_LS.index(i)-outlier_RS.index(j)) == 2


                    overcomings.nCycle(n) = outlier_LS.nCycle(i);
                    overcomings.start_time(n) = ...
                        allGaitCycles.Start_time(min(outlier_LS.index(i), ...
                        outlier_RS.index(j)));
                    overcomings.end_time(n) = ...
                        allGaitCycles.end_time(max(outlier_LS.index(i), ...
                        outlier_RS.index(j)));
                    overcomings.start_index(n) = ...
                        min(outlier_LS.index(i), outlier_RS.index(j));
                    overcomings.end_index(n) = ...
                        max(outlier_LS.index(i), outlier_RS.index(j));

                    n = n+1;

                end
            end
        end
    end

    if isempty(overcomings) == 0
        n=1;
        rowtodelete = [];
        for i=2:length(overcomings.nCycle)

            if overcomings.nCycle(i-1) == overcomings.nCycle(i)

                if (overcomings.end_time(i-1) - overcomings.start_time(i-1)) > ...
                        (overcomings.end_time(i-1) - overcomings.start_time(i-1))

                    rowtodelete(n) = i

                else
                    rowtodelete(n) = i-1;

                end

            end
        end


        overcomings([rowtodelete],:) = []


        figure('units','normalized','outerposition',[0.5 0 0.5 1])
        p1 = plot(wx_dx, 'Color','#EDB120'),
        ax = gca;
        ax.XLim = [Cycles.start_ind(1)-2*fc_IMU Cycles.end_ind(end)+2*fc_IMU];
        hold on, zoom on
        p2 = scatter(heelstrike.index, heelstrike.peak, 'r', 'filled', 'o');
        hold on
        p3 = scatter(toeoff.index,toeoff.peak, 'b', 'filled', 'o');

        title('GAIT ANALYSIS RIGHT FOOT')
        hold on

        p5 = plot(wx_sx, 'Color','#EDB120'),
        hold on, zoom on
        p6 = scatter(heelstrike_sx.index, heelstrike_sx.peak, 'm', 'filled', 'o');
        hold on
        p7 = scatter(toeoff_sx.index,toeoff_sx.peak, 'k', 'filled', 'o');

        title('GAIT ANALYSIS LEFT FOOT')

        for i=1:length(overcomings.nCycle)

            xline(overcomings.start_time(i)*fc_IMU);
            xline(overcomings.end_time(i)*fc_IMU);

        end


        legend([p1 p2 p3 p5 p6 p7], {'Angular velocity around x axes', ...
            'heel strike', 'toe off', 'WX_sx',  'heel strike_sx', 'toe off_sx'})


    end
end
end