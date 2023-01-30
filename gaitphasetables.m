function [LRdoubleStance, RLdoubleStance, LeftSwing, RightSwing] = gaitphasetables(allGaitCycles)

% This function divide the single phases from the "allGaitCycles" table to
% do a next statistic analysis on the duration of each phase.

j = 1;
k = 1;
q = 1;
t = 1;

LRdoubleStance = table;
RLdoubleStance = table;
LeftSwing = table;
RightSwing = table;


for i=1:length(allGaitCycles.phase)

    switch allGaitCycles.phase(i)

        case "LRdoubleStance"

            LRdoubleStance.duration(j) = ...
                allGaitCycles.end_time(i) - allGaitCycles.Start_time(i);
            LRdoubleStance.WalkSequenceID(j) = ...
                allGaitCycles.walkSequenceId(i);
            j = j+1;


        case "RLdoubleStance"

            RLdoubleStance.duration(k) = ...
                allGaitCycles.end_time(i) - allGaitCycles.Start_time(i);
            RLdoubleStance.WalkSequenceID(k) = ...
                allGaitCycles.walkSequenceId(i);
            k = k+1;



        case "LeftSwing"

            LeftSwing.duration(q) = ...
                allGaitCycles.end_time(i) - allGaitCycles.Start_time(i);
            LeftSwing.WalkSequenceID(q) = ...
                allGaitCycles.walkSequenceId(i);
            LeftSwing.Index(q) = i;
            q = q+1;



        case "RightSwing"

            RightSwing.duration(t) = ...
                allGaitCycles.end_time(i) - allGaitCycles.Start_time(i);
            RightSwing.WalkSequenceID(t) = ...
                allGaitCycles.walkSequenceId(i);
            RightSwing.Index(t) = i;
            t = t+1;

    end
end
end