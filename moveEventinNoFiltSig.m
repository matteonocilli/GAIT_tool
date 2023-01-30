function [heelstrike, toeoff, heelstrike_sx, toeoff_sx] = ...
    moveEventinNoFiltSig(heelstrike, toeoff, heelstrike_sx, ...
    toeoff_sx, wx_dx, wx_sx, fc_IMU)

% This function move the point detected on the smoothed signal in the
% original signal searching for a minimum in a window of 0.2s centered in
% the index of the detected point


for i=1:length(heelstrike.index)
    locmin = (heelstrike.index(i)-ceil(fc_IMU/10)) + ...
        find(islocalmin(wx_dx(heelstrike.index(i)-ceil(fc_IMU/10): ...
        heelstrike.index(i)+ceil(fc_IMU/10)), 'MaxNumExtrema',1)==1) - 1;

    if isempty(locmin) == 1
        heelstrike.index(i) = heelstrike.index(i)
        heelstrike.peak(i) = wx_dx(heelstrike.index(i));
        locmin = [];
    else
        heelstrike.index(i) = locmin;
        heelstrike.peak(i) = wx_dx(locmin);
        locmin = [];
    end
end


for i=1:length(toeoff.index)
    locmin = (toeoff.index(i)-ceil(fc_IMU/10)) + ...
        find(islocalmin(wx_dx(toeoff.index(i)-ceil(fc_IMU/10): ...
        toeoff.index(i)+ceil(fc_IMU/10)), 'MaxNumExtrema',1)==1) - 1;

    if isempty(locmin) == 1
        toeoff.index(i) = toeoff.index(i)
        toeoff.peak(i) = wx_dx(toeoff.index(i))
        locmin = [];
    else
        toeoff.index(i) = locmin;
        toeoff.peak(i) = wx_dx(locmin);
        locmin = [];
    end
end

for i=1:length(heelstrike_sx.index)
    locmin = (heelstrike_sx.index(i)-ceil(fc_IMU/10)) + ...
        find(islocalmin(wx_sx(heelstrike_sx.index(i)-ceil(fc_IMU/10): ...
        heelstrike_sx.index(i)+ceil(fc_IMU/10)), 'MaxNumExtrema',1)==1) - 1;

    if isempty(locmin) == 1
        heelstrike_sx.index(i) = heelstrike_sx.index(i)
        heelstrike_sx.peak(i) = wx_sx(heelstrike_sx.index(i))
        locmin = [];
    else
        heelstrike_sx.index(i) = locmin;
        heelstrike_sx.peak(i) = wx_sx(locmin);
        locmin = [];
    end
end


for i=1:length(toeoff_sx.index)
    locmin = (toeoff_sx.index(i)-ceil(fc_IMU/10)) + ...
        find(islocalmin(wx_sx(toeoff_sx.index(i)-ceil(fc_IMU/10): ...
        toeoff_sx.index(i)+ceil(fc_IMU/10)), 'MaxNumExtrema',1)==1) - 1;

    if isempty(locmin) == 1
        toeoff_sx.index(i) = toeoff_sx.index(i)
        toeoff_sx.peak(i) = wx_sx(toeoff_sx.index(i))
        locmin = [];
    else
        toeoff_sx.index(i) = locmin;
        toeoff_sx.peak(i) = wx_sx(locmin);
        locmin = [];
    end
end


end