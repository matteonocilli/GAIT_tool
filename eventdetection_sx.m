function [initSwingsx, endSwingsx, toeoff_sx, heelstrike_sx] = ...
    eventdetection_sx(Cycles_sx, wx_sx_smooth, fc_IMU)


% This function is responsible for detecting events for the right foot.
% To do this, the start and end points of the Swing are first detected 
% with a zero crossing of the signal and a thresholding on the maxima 
% between zerocrossing points. 
% The TO will be the first minimum before the initSwing point detected,
% and the HS will be the first maximum after the endSwing point detected.

for n = 1:length(Cycles_sx.nCycle)
    wx_sx_cut = []
    wx_sx_neg = []
    wx_sx_cut = wx_sx_smooth(Cycles_sx.start_ind(n):Cycles_sx.end_ind(n));

    for i = 1:(length(wx_sx_cut))
        if wx_sx_cut(i) < 0
            wx_sx_pos(i) = 0;
        else
            wx_sx_pos(i) = wx_sx_cut(i);

        end
    end

    mean_wxsxpos(n) = mean(wx_sx_pos);
    trshldSwing2(n) = 2*mean_wxsxpos(n);

end


for n = 1:length(Cycles_sx.nCycle)
    wx_sx_cut = []
    wx_sx_neg = []
    wx_sx_cut = wx_sx_smooth(Cycles_sx.start_ind(n):Cycles_sx.end_ind(n));

    for i = 1:(length(wx_sx_cut))
        if wx_sx_cut(i) > 0
            wx_sx_neg(i) = 0;
        else
            wx_sx_neg(i) = wx_sx_cut(i);

        end
    end


    mean_wxsx_neg(n) = mean(wx_sx_neg);
    trshldHSsx(n) = mean_wxsx_neg(n)


end


for i=1:length(wx_sx_smooth)-1

    if wx_sx_smooth(i) > 0 && wx_sx_smooth(i+1) < 0

        zc2(i) = i;

    elseif wx_sx_smooth(i) < 0 && wx_sx_smooth(i+1) > 0

        zc2(i) = i;

    else

        zc2(i) = 0;

    end
end

zc_ind2 = zc2(zc2~=0);

k=1;
for n=1:length(Cycles_sx.nCycle)

    for i=1:length(zc_ind2)

        if zc_ind2(i) > Cycles_sx.start_ind(n) && ...
            zc_ind2(i) < Cycles_sx.end_ind(n)

            zc_index2(k) = zc_ind2(i);
            k=k+1;
        end
    end
end

t=1;
k=1;

initSwingsx = table;
endSwingsx = table;

for n=1:length(Cycles_sx.nCycle)
    for i=1:length(zc_index2)-1

        if zc_index2(i) > Cycles_sx.start_ind(n) && zc_index2(i) && ...
           zc_index2(i+1) > Cycles_sx.start_ind(n) && ...
           zc_index2(i+1) < Cycles_sx.end_ind(n) && ...
           max(wx_sx_smooth(zc_index2(i):zc_index2(i+1))) > mean(trshldSwing2)
                

            initSwingsx.index(t) = zc_index2(i);
            initSwingsx.nCycle(t) = n;
            endSwingsx.index(k)=   zc_index2(i+1);
            endSwingsx.nCycle(k) = n;


            t=t+1;
            k=k+1;



        end
    end
end




mins2 = find(islocalmin(wx_sx_smooth, 'MinSeparation',fc_IMU/4)==1);



heelstrike_sx = table;
toeoff_sx = table;


n=1;
for i=1:length(initSwingsx.index)

    if abs(wx_sx_smooth(max(mins2(mins2<initSwingsx.index(i))))) > abs(mean(trshldHSsx)/2)

    toeoff_sx.index(n) = max(mins2(mins2<initSwingsx.index(i)));
    toeoff_sx.peak(n) = wx_sx_smooth(toeoff_sx.index(n));
    toeoff_sx.phase(n) = "TO LF";
    toeoff_sx.nCycle(n) = initSwingsx.nCycle(i);

    

    if n>1
        if toeoff_sx.index(n) == toeoff_sx.index(n-1)
            toeoff_sx(n,:) = [];
        else
            n=n+1;
        end
    else
        n=n+1;
    end

    end

end

n=1;
for i=1:length(endSwingsx.index)

    heelstrike_sx.index(n) = min(mins2(mins2>endSwingsx.index(i)));
    heelstrike_sx.peak(n) = wx_sx_smooth(heelstrike_sx.index(n));
    heelstrike_sx.phase(n) = "HS LF";
    heelstrike_sx.nCycle(n) = endSwingsx.nCycle(i);

    if abs(heelstrike_sx.peak(n)) < abs(mean(trshldHSsx)/2)
        heelstrike_sx.index(n) = endSwingsx.index(i)+1;
        heelstrike_sx.peak(n) = wx_sx_smooth(heelstrike_sx.index(n));

    end

    if n==1 && isempty(find(heelstrike_sx.index(n) == toeoff_sx.index(:))) == 0
        heelstrike_sx(n,:) = [];
   
    elseif n>1 && isempty(find(heelstrike_sx.index(n) == toeoff_sx.index(:))) == 0
        heelstrike_sx(n,:) = [];
  
    else 
        n=n+1;
    end


end


end