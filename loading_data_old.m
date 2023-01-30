function [data] = loading_data_old(datas, EMGans)


nameimu = fieldnames(datas)
for i=1:length(nameimu)
listimu{i,:} = sprintf('datas.%s', nameimu{i})
end

n=1;
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:length(listimu)
    x(i) = nexttile, plot(eval(listimu{i})), title(sprintf('%s', nameimu{i}))
end
t = sgtitle('Check signals, then press ENTER for choosing stage')
t.FontSize = 20, t.FontAngle = "italic", t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';
linkaxes(x,'x')
zoom on
pause;

[listind,tf] = listdlg('ListString',nameimu,'Name','IMU choice', ...
            'PromptString',['Select the name of the Gyro Signal for RIGHT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');

data.GYROX_R= eval(listimu{listind});
for i=2:length(data.GYROX_R)

    if isnan(data.GYROX_R(i)) == 1
        data.GYROX_R(i) = data.GYROX_R(i-1)
    end
end

[listind,tf] = listdlg('ListString',nameimu,'Name','IMU choice', ...
            'PromptString',['Select the name of the Gyro Signal for RIGHT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');

data.GYROX_L= eval(listimu{listind});
for i=2:length(data.GYROX_L)

    if isnan(data.GYROX_L(i)) == 1
        data.GYROX_L(i) = data.GYROX_L(i-1)
    end
end

data.fs_IMU = 2000;
data.time_IMU = 0:1/data.fs_IMU:length(data.GYROX_L)/data.fs_IMU;
data.time_IMU = data.time_IMU(1:end-1);

switch EMGans
    case 'Yes'

[listind,tf] = listdlg('ListString',nameimu,'Name','EMG choice', ...
            'PromptString',['Select the name of the EMG Signal for RIGHT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');

data.EMG_R = eval(listimu{listind});

for i=2:length(data.EMG_R)

    if isnan(data.EMG_R(i)) == 1
        data.EMG_R(i) = data.EMG_R(i-1)
    end
end

[listind,tf] = listdlg('ListString',nameimu,'Name','EMG choice', ...
            'PromptString',['Select the name of the EMG Signal for LEFT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');

data.EMG_L = eval(listimu{listind});

for i=2:length(data.EMG_L)

    if isnan(data.EMG_L(i)) == 1
        data.EMG_L(i) = data.EMG_L(i-1)
    end
end


data.fs_EMG = 2000;
data.time_EMG = 0:1/data.fs_EMG:length(data.EMG_L)/data.fs_EMG;
data.time_EMG = data.time_EMG(1:end-1);

end


close all
clear datas

end

