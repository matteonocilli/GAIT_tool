clear
close all
clc
warning off

% Loading Data
[file, path] = uigetfile('*.mat', 'Load');
filename = sprintf('%s%s', path, file);
load(filename)

opts.Interpreter = 'tex';
opts.Default = 'Yes';
EMGans = questdlg(['\fontsize{11}\fontname{Arial}Are you in use of EMG signals?'], ...
    'EMG or not', ...
    'Yes','No' , opts);


if exist('data') == 1
    datas = data;
    clear data;
    [data] = loading_data_old(datas, EMGans);
else
    [data] = loading_data(rec, EMGans);
    
end

close all

fc_IMU = data.fs_IMU;
t_imu = data.time_IMU;
% Data normalized at Z value
wx_dx = (data.GYROX_R-mean(data.GYROX_R))/std(data.GYROX_R);

wx_sx = (data.GYROX_L-mean(data.GYROX_L))/std(data.GYROX_L);

switch EMGans
    case 'Yes'

fc_EMG = data.fs_EMG;
t_emg = data.time_EMG;
emg_dx = (data.EMG_R-mean(data.EMG_R))/std(data.EMG_R);
emg_sx = (data.EMG_L-mean(data.EMG_L))/std(data.EMG_L);

end


% choose the window length for the moving average filter
[lenwindx, lenwinsx] = smoothingsignal(wx_dx, wx_sx, fc_IMU);

if isempty(lenwindx) == 1
    wx_dx_smooth = wx_dx;
else
    wx_dx_smooth = smooth(wx_dx, lenwindx);
end

if isempty(lenwinsx) == 1
    wx_sx_smooth = wx_sx;
else
    wx_sx_smooth = smooth(wx_sx, lenwinsx);
end

basicwaitbar;


%%  AUTOMATIC SEARCH FOOR INDICES THAT DELIMIT THE CYCLES FOR THE RIGHT FOOT

% Loading the pattern signal for the Cycles recognition
load("mean_stride_new.mat");
mean_stride_new = resample(mean_stride_new, round(fc_IMU), 2000);

% Automatic division of cycles
[Cycles, Turning] = searchcycles(wx_dx_smooth, mean_stride_new, fc_IMU);

% Display of division into cycles and choice of whether to accept
% or change them
switch EMGans  
    case 'No'
[Cycles, Turning] = accept_or_change_cycles(Cycles, t_imu, wx_dx_smooth, ...
     fc_IMU);
    case 'Yes'
        [Cycles, Turning] = acceptorchangecycles_withemg(Cycles, t_imu, t_emg, ...
    wx_dx_smooth, emg_dx, fc_IMU, fc_EMG)
end


close all

Cycles_sx = Cycles;
switch EMGans
    case 'No'
[Cycles_sx] = accept_or_change_cycles_sx(Cycles_sx, t_imu, ...
    wx_sx_smooth, fc_IMU);
    case 'Yes'
        [Cycles_sx] = acceptorchangecycles_sx_withemg(Cycles_sx, t_imu, ...
    t_emg, wx_sx_smooth, emg_sx, fc_IMU, fc_EMG)
        end

close all



%% FIND PEAKS AND ASSIGN THEM TO THE EVENTS OF STEP CYCLE FOR THE RIGHT FOOT




[initSwing, endSwing, toeoff, heelstrike] = eventdetection_dx(Cycles, ...
    wx_dx_smooth, fc_IMU);


%% REMOVE AND ADD EVENTS RIGHT FOOT

i=1;
[heelstrike, toeoff, i] = modifyevents(Cycles, wx_dx_smooth, wx_sx_smooth, heelstrike, toeoff, fc_IMU, i);


%% FIND PEAKS AND ASSIGN THEM TO THE PHASES OF STEP CYCLE FOR THE left FOOT


[initSwingsx, endSwingsx, toeoff_sx, heelstrike_sx] =  ...
    eventdetection_sx(Cycles_sx, wx_sx_smooth, fc_IMU);



%% REMOVE AND ADD EVENTS LEFT FOOT

i=1;
[heelstrike_sx, toeoff_sx, i] = modifyevents_sx(Cycles_sx, wx_dx_smooth, wx_sx_smooth, heelstrike_sx, toeoff_sx, fc_IMU, i);

%% PLOT FINAL EVENTS

close all

% Move the events from the smoothing signal to the original signal
[heelstrike, toeoff, heelstrike_sx, toeoff_sx] = ...
    moveEventinNoFiltSig(heelstrike, toeoff, heelstrike_sx, ...
    toeoff_sx, wx_dx, wx_sx, fc_IMU);

plotfinalevents(wx_dx,Cycles, heelstrike, toeoff, wx_sx, Cycles_sx, heelstrike_sx, toeoff_sx, fc_IMU);



%% CREATE ALLSTEP TABLE

events_index = sort([heelstrike.index; heelstrike_sx.index; ...
    toeoff.index; toeoff_sx.index]);
allsteps = [heelstrike; heelstrike_sx; toeoff; toeoff_sx];
allSteps = table;

for i=1:length(events_index)
    for j=1:length(events_index)

        if events_index(i) == allsteps.index(j)
            allSteps.peaks(i) = allsteps.peak(j);
            allSteps.index(i) = allsteps.index(j);
            allSteps.time(i) = allsteps.index(j)/fc_IMU;
            allSteps.phase(i) = allsteps.phase(j);
            allSteps.cycle(i) = allsteps.nCycle(j);

        end
    end
end

%% CREATE allGaitCycles TABLE

[allGaitCycles] = createAGCtable(allSteps, Cycles, fc_IMU);

%%  CREATE SINGLE TABLES

 [LRdoubleStance, RLdoubleStance, LeftSwing, RightSwing] = gaitphasetables(allGaitCycles);

%% STATISTIC ANALYSIS

 statistic_analysis(LRdoubleStance, RLdoubleStance, LeftSwing, RightSwing);



%% SEARCH FOR OVERCOMINGS

overcoming(RightSwing, LeftSwing, allGaitCycles, wx_dx, wx_sx, Cycles, Cycles_sx, fc_IMU, heelstrike, toeoff, heelstrike_sx, toeoff_sx);

%%
close all

figure,
plot(wx_dx), hold on, plot(wx_sx), scatter(heelstrike.index, ...
    heelstrike.peak, 'r', 'filled'), scatter(heelstrike_sx.index, ...
    heelstrike_sx.peak, 'r', 'filled'),
xline(heelstrike.index), xline(heelstrike_sx.index)
scatter(toeoff.index, toeoff.peak, 'b', 'filled'),
scatter(toeoff_sx.index, toeoff_sx.peak, 'b', 'filled'),
xline(toeoff.index), xline(toeoff_sx.index)




