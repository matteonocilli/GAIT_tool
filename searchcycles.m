function [Cycles, Turning] = searchcycles(wx_dx_smooth, mean_stride_new, fc_IMU)

% This function outputs the Cycles table containing all start and end points
% detected by crosscorrelation with a loaded stride pattern.
% Comments on how the algorithm detects the indices are found in the code


Cycles = table;

% Calculate the crosscorrelation function between the pattern and the
% complete signal and put the baseline at zero
[xcor del] = xcorr(wx_dx_smooth, mean_stride_new);
a = find(del == 0); xcor = abs(xcor(a:end)); xcor = xcor/max(xcor);

points(:,1) = find(islocalmin(xcor)==1);
points(:,2) = xcor(points(:,1));
xcor(points(:,1)) = xcor(points(:,1)) - points(:,2);


% Standard deviation of the cross-correlation function to be used as a
% threshold for 'MinPeakHeight' findpeaks function
trshld_xcor = 2.5*std(xcor);


[pks_findcyc locs_findcyc] = findpeaks(xcor, 'MinPeakHeight', trshld_xcor);

% the endturn points of the cycles are all the index that had a distance
% from the previous one of at least 2 times the average of all the
% distances
dif = diff(locs_findcyc);
indices_endturn = find(dif>2*mean(dif))+1;
indices_startturn = find(dif>2*mean(dif));

%these indexes will be placed 1.75s earlier for endtrun and 2.5s later for
% starturn
ind_startTurn = [];
ind_endTurn = [];

for i=1:length(indices_startturn)

    ind_startTurn(i) = locs_findcyc(indices_startturn(i))+round(2.5*fc_IMU);
end


for i=1:length(indices_endturn)

    ind_endTurn(i) = locs_findcyc(indices_endturn(i))-round(1.75*fc_IMU);
end

if isempty(ind_startTurn) == 0 && isempty(ind_endTurn) == 0

for i = 1:length(ind_startTurn)
    if ind_startTurn(i) > ind_endTurn(i)
        ind_endTurn(i) =  ind_startTurn(i) + fc_IMU;
    end
end

% start walk point will be one second before the position of the first
% peak found
ind_startWalk = locs_findcyc(1)-round(fc_IMU);

% to find the end walk point the signal is flipped
% and a cross-correlation with the pattern (also flipped) was
% done again, once the first peak is found this will be the end walk point,
% once the first peak is found this will be the end walk point,
% positioned a second further along
sig_flipped = flip(wx_dx_smooth);
mean_stride_flipped = flip(mean_stride_new);

[xcor_flip del_flip] = xcorr(sig_flipped, mean_stride_flipped);
a = find(del_flip == 0);
xcor_flip = abs(xcor_flip(a:end));

trshld_xcor_flip = 2*std(xcor_flip);

[pks_xcor_flip locs_xcor_flip] = findpeaks(xcor_flip, 'MinPeakHeight', ...
    trshld_xcor_flip);

ind_endWalk = length(wx_dx_smooth)-locs_xcor_flip(1)+round(fc_IMU);

% the Cycles table is created, which will contain information about the
% division of cycles
% Start_ind of the first cycle will be the startWalk and the end_ind will
% be the first start turn
% For the last cycle the start_ind will be the last endturn and the end_ind
% will be the endWalk
% For all other cycles the start_ind (i) will be the endturn (i-1) and the
% end_ind (i) will be the startturn (i)
if isempty(indices_endturn) == 0 && isempty(indices_startturn) == 0

    if ind_startTurn(1) - ind_startWalk > 5*fc_IMU
        Cycles.nCycle(1) = 1;
        Cycles.start_ind(1) = ind_startWalk;
        Cycles.end_ind(1) = ind_startTurn(1);
        n=2;
        for i=2:length(ind_endTurn)
            if ind_startTurn(i) - ind_endTurn(i-1) > 5*fc_IMU

                Cycles.nCycle(n) = n;
                Cycles.start_ind(n) = ind_endTurn(i-1);
                Cycles.end_ind(n) = ind_startTurn(i);
                n=n+1;
            end
        end
        Cycles.nCycle(n) = n;
        Cycles.start_ind(n) = ind_endTurn(end);
        Cycles.end_ind(n) = ind_endWalk;

    else
        n=1;
        for i=2:length(ind_endTurn)
            if ind_startTurn(i) - ind_endTurn(i-1) > 5*fc_IMU

                Cycles.nCycle(n) = n;
                Cycles.start_ind(n) = ind_endTurn(i-1);
                Cycles.end_ind(n) = ind_startTurn(i);
                n=n+1;
            end
        end
        Cycles.nCycle(n) = n;
        Cycles.start_ind(n) = ind_endTurn(end);
        Cycles.end_ind(n) = ind_endWalk;

    end
else
    Cycles.nCycle(1) = 1;
    Cycles.start_ind(1) = ind_startWalk;
    Cycles.end_ind(1) = ind_endWalk;

end

if Cycles.end_ind(end) > length(wx_dx_smooth)
    Cycles.end_ind(end) = length(wx_dx_smooth);
end


% Move the indexes where the signal is flat to avoid them being caught
% in parts of useful signal

for i = 1:length(Cycles.nCycle)-1

    if abs(wx_dx_smooth(Cycles.start_ind(i))) >  0.1

        wave_start = sign(wx_dx_smooth(Cycles.start_ind(i)-fc_IMU: ...
            Cycles.start_ind(i)));

        if wave_start(end) == 1

            if isempty(max(find(diff(wave_start)==-2)))==0

                shiftind = max(find(diff(wave_start)==-2));
                Cycles.start_ind(i) = Cycles.start_ind(i)-(length(wave_start)-shiftind);

            end

        elseif wave_start(end) == -1

            if isempty(max(find(diff(wave_start)==2)))==0

                shiftind = max(find(diff(wave_start)==2));
                Cycles.start_ind(i) = Cycles.start_ind(i)-(length(wave_start)-shiftind);

            end
        end

        wave_start = [];

    end
end

for i = 1:length(Cycles.nCycle)-1

    if abs(wx_dx_smooth(Cycles.end_ind(i))) >  0.1

        wave_end = sign(wx_dx_smooth(Cycles.end_ind(i): ...
            Cycles.end_ind(i)+fc_IMU));

        if wave_end(1) == 1

            if isempty(min(find(diff(wave_end)==-2)))==0

                shiftind = min(find(diff(wave_end)==-2));
                Cycles.end_ind(i) = Cycles.end_ind(i)+shiftind;
            end

        elseif wave_end(1) == -1

            if isempty(min(find(diff(wave_end)==2))) == 0

                shiftind = min(find(diff(wave_end)==2));
                Cycles.end_ind(i) = Cycles.end_ind(i)+shiftind;
            end
        end

        wave_end = [];

    end

end



% Create a table of Turning events

Turning = table;
for i=1:length(Cycles.nCycle)-1

    Turning.start(i) = Cycles.end_ind(i);
    Turning.end(i) = Cycles.start_ind(i+1);
    Turning.id(i) = i;

end

% Starting from the index found previously, the first and last peak of
% the rectified derived signal among the chosen turning points are chosen as the
% new start and end points of the turning phase, respectively

for i = 1:length(Turning.id)

    if Turning.start(i) > Turning.end(i)
        Turning.end(i) = Turning.start(i) + fc_IMU;
    end

    start = [];
    wx_dx_cut = [];
    peakturn = [];
    locturn = [];
    wx_dx_cut = abs(diff(wx_dx_smooth(Turning.start(i):Turning.end(i))));
    wx_dx_cut = wx_dx_cut/max(wx_dx_cut);
    start = Turning.start(i);


    [peakturn locturn] = findpeaks(wx_dx_cut, 'MinPeakHeight', 0.2);

    if isempty(locturn) == 0

        Turning.start(i) = round(locturn(1)+start-1*fc_IMU);
        Turning.end(i) = round(locturn(end)+start+1*fc_IMU);



    end

end



for i=1:length(Cycles.nCycle)-1

    Cycles.end_ind(i) = Turning.start(i);
    Cycles.start_ind(i+1) = Turning.end(i);

end

for i=1:length(Cycles.nCycle)
    durationcyc(i) = Cycles.end_ind(i) - Cycles.start_ind(i);
end
n=1;
cyctoremove = [];
for i=1:length(durationcyc)
    if durationcyc(i) < mean(durationcyc)/3
        cycremove(n) = i;
        n=n+1;
    end
end

if isempty(cyctoremove) == 0
    Cycles(cycremove,:) = [];
end

else

    Cycles.start_ind = 1;
    Cycles.end_ind = length(wx_dx_smooth);
    Cycles.nCycle = 1;
    Turning = [];
end

end







