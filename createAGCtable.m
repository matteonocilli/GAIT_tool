function [allGaitCycles] = createAGCtable(allSteps, Cycles, fc_IMU)

% This function create the output table "AllGaitCycles" table following
% this rules:
% -RightSwing     -->  from TO rightfoot to HS rightfoot
% -RLdoubleStance -->  from HS rightfoot to TO leftfoot
% -LeftSwing      -->  from TO leftfoot  to HS leftfoot
% -LRdoubleStance -->  from HS leftfoot  to TO rightfoot


allGaitCycles = table;                                                                                                 
j=1;    

                                                                                                                        
for i=1:length(allSteps.phase)-1                                                                                        
                                                                                                                        
    if allSteps.phase(i) == "HS LF" && allSteps.phase(i+1) == "TO RF" && ...
        allSteps.cycle(i) == allSteps.cycle(i+1)

        allGaitCycles.Start_time(j) = allSteps.time(i);
        allGaitCycles.end_time(j) = allSteps.time(i+1);
        allGaitCycles.phase(j) = "LRdoubleStance";
        allGaitCycles.walkSequenceId(j) = allSteps.cycle(i);
        j = j+1;

    elseif allSteps.phase(i) == "HS RF" && ...
           allSteps.phase(i+1) == "TO LF"  && ...
           allSteps.cycle(i) == allSteps.cycle(i+1)

        allGaitCycles.Start_time(j) = allSteps.time(i);
        allGaitCycles.end_time(j) = allSteps.time(i+1);
        allGaitCycles.phase(j) = "RLdoubleStance";
        allGaitCycles.walkSequenceId(j) = allSteps.cycle(i);
        j = j+1;


    elseif allSteps.phase(i) == "TO RF" && ...
           allSteps.phase(i+1) == "HS RF" && ...
           allSteps.cycle(i) == allSteps.cycle(i+1)

        allGaitCycles.Start_time(j) = allSteps.time(i);
        allGaitCycles.end_time(j) = allSteps.time(i+1);
        allGaitCycles.phase(j) = "RightSwing";
        allGaitCycles.walkSequenceId(j) = allSteps.cycle(i);
        j = j+1;

    elseif allSteps.phase(i) == "TO LF" && ...
           allSteps.phase(i+1) == "HS LF"  && ...
           allSteps.cycle(i) == allSteps.cycle(i+1)

        allGaitCycles.Start_time(j) = allSteps.time(i);
        allGaitCycles.end_time(j) = allSteps.time(i+1);
        allGaitCycles.phase(j) = "LeftSwing";
        allGaitCycles.walkSequenceId(j) = allSteps.cycle(i);
        j = j+1;
    end

    i = i+1;
end

n=1
turning = table;
for i=1:length(Cycles.start_ind)-1

    turning.Start_time(n) = Cycles.end_ind(i)/fc_IMU;
    turning.end_time(n) = Cycles.start_ind(i+1)/fc_IMU;
    turning.phase(n) = "Turning";
    turning.walkSequenceId(n) = i;
    n=n+1;

end

for i=1:length(Cycles.nCycle)-1

    id = max(find(allGaitCycles.walkSequenceId == i));
    allGaitCycles = [allGaitCycles(1:id, :); turning(i,:); ...
        allGaitCycles(id+1:end, :)];
    id = []

end

end