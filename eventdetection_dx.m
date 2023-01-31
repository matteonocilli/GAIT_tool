  function [initSwing, endSwing, toeoff, heelstrike] = ...
eventdetection_dx(Cycles, wx_dx_smooth, fc_IMU)


% This function performs event detection on a set of gait reps. 

% The function first separates positive and negative values from
% "wx_dx_smooth" in order to set a threshold value for detecting
% the start and end of the swing phase based on the mean of positive values.
% The function then detects zero-crossing points in "wx_dx_smooth" 
% and uses the threshold for the swing phase and the
% identified zero-crossing points to determine the start and end of the
% swing phase for each gait rep. 
% TO will be the first minimum before the initSwing point detected, 
% and HS will be the first first minimum after the endSwing point detected.


for n = 1:length(Cycles.nCycle)
    wx_dx_cut = []
    wx_dx_cut = wx_dx_smooth(Cycles.start_ind(n):Cycles.end_ind(n));

    for i = 1:(length(wx_dx_cut))
        if wx_dx_cut(i) < 0                    
            wx_dx_pos(i) = 0;
        else
            wx_dx_pos(i) = wx_dx_cut(i);

        end
    end

    mean_wxdxpos(n) = mean(wx_dx_pos);
    trshldSwing(n) = 2*mean_wxdxpos(n);     

end

for n = 1:length(Cycles.nCycle)
    wx_dx_cut = []
    wx_dx_neg = []
    wx_dx_cut = wx_dx_smooth(Cycles.start_ind(n):Cycles.end_ind(n));

    for i = 1:(length(wx_dx_cut))
        if wx_dx_cut(i) > 0                    
            wx_dx_neg(i) = 0;
        else
            wx_dx_neg(i) = wx_dx_cut(i);

        end
    end


    mean_wxdx_neg(n) = mean(wx_dx_neg);
    trshldHS(n) = mean_wxdx_neg(n)     


end


for i=1:length(wx_dx_smooth)-1

    if wx_dx_smooth(i) > 0 && wx_dx_smooth(i+1) < 0

        zc(i) = i;

    elseif wx_dx_smooth(i) < 0 && wx_dx_smooth(i+1) > 0

        zc(i) = i;

    else

        zc(i) = 0;

    end
end

zc_ind = zc(zc~=0);

k=1;
for n=1:length(Cycles.nCycle)

    for i=1:length(zc_ind)

        if zc_ind(i) > Cycles.start_ind(n) && zc_ind(i) < Cycles.end_ind(n)

            zc_index(k) = zc_ind(i);
            k=k+1;
        end
    end
end

t=1;
k=1;
initSwing = table;
endSwing = table;

for n=1:length(Cycles.nCycle)
    for i=1:length(zc_index)-1

        if zc_index(i) > Cycles.start_ind(n)  && ...
            zc_index(i+1) < Cycles.end_ind(n) && ...
            max(wx_dx_smooth(zc_index(i):zc_index(i+1))) > mean(trshldSwing)

            initSwing.index(t) = zc_index(i);
            initSwing.nCycle(t) = n;
            endSwing.index(k)=   zc_index(i+1);
            endSwing.nCycle(k) = n;
            t=t+1;
            k=k+1;


        end
    end
end


mins = find(islocalmin(wx_dx_smooth, 'MinSeparation',fc_IMU/4)==1);




toeoff = table;
heelstrike = table;



n=1;
for i=1:length(initSwing.index)

if abs(wx_dx_smooth(max(mins(mins<initSwing.index(i))))) > abs(mean(trshldHS)/2)

    toeoff.index(n) = max(mins(mins<initSwing.index(i)));
    toeoff.peak(n) = wx_dx_smooth(toeoff.index(n));
    toeoff.phase(n) = "TO RF";
    toeoff.nCycle(n) = initSwing.nCycle(i);


    if n>1
        if toeoff.index(n) == toeoff.index(n-1)
            toeoff(n,:) = [];
        else
            n=n+1;
        end
    else
        n=n+1;
    end

end
end

n=1
for i=1:length(endSwing.index)

    heelstrike.index(n) = min(mins(mins>endSwing.index(i)));
    heelstrike.peak(n) = wx_dx_smooth(heelstrike.index(n));
    heelstrike.phase(n) = "HS RF";
    heelstrike.nCycle(n) = endSwing.nCycle(i);

    if abs(heelstrike.peak(n)) < abs(mean(trshldHS)/2)
        heelstrike.index(n) = endSwing.index(i)+1;
        heelstrike.peak(n) = wx_dx_smooth(heelstrike.index(n));
    end

    if n==1 && isempty(find(heelstrike.index(n) == toeoff.index(:))) == 0
        heelstrike(n,:) = [];
   
    elseif n>1 && isempty(find(heelstrike.index(n) == toeoff.index(:))) == 0
        heelstrike(n,:) = [];
  
    else 
        n=n+1;
    end
    
%     if n>1 && heelstrike.index(n) == heelstrike.index(n-1)
%         heelstrike(n,:) = [];
%     end



end

end