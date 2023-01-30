function [data] = loading_data(rec, EMGans)

AcqType = {rec.AcquisitionType};

for i=1:length(AcqType)
    if AcqType{i} == "DelsysIMU"
        imurow = i;
    elseif AcqType{i} == "DelsysEMG"
        emgrow = i;
    end
end

nameimu = fieldnames(rec(imurow).Data);
[b,c] = strtok(nameimu, '_');
d = strtok(c,'_');
a = strcat(b,d);

for i=1:length(nameimu)
    listimu{i,:} = sprintf('rec(%d).Data.%s', imurow, nameimu{i})
end

n=1;
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:length(listimu)
    sig(:,n:n+1) = table2array(eval(listimu{i}));
    x(i) = nexttile, plot(sig(:,n+1)), title(sprintf('%s', a{i}))
    n=n+2;
end
t = sgtitle('Check IMU signals, then press ENTER for choosing stage')
t.FontSize = 20, t.FontAngle = "italic", t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';
linkaxes(x,'x')
zoom on
pause;


[listind,tf] = listdlg('ListString',nameimu,'Name','IMU choice', ...
    'PromptString',['Select the name of the Gyro Signal for RIGHT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');


data.GYROX_R=table2array(eval(listimu{listind})); 
data.GYROX_R = data.GYROX_R(:,2);


[listind,tf] = listdlg('ListString',nameimu,'Name','IMU choice', ...
    'PromptString',['Select the name of the Gyro Signal for LEFT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');


data.GYROX_L=table2array(eval(listimu{listind}));
data.GYROX_L = data.GYROX_L(:,2);




for i=2:length(data.GYROX_R)

    if isnan(data.GYROX_R(i)) == 1
        data.GYROX_R(i) = data.GYROX_R(i-1)
    end
end



for i=2:length(data.GYROX_L)

    if isnan(data.GYROX_L(i)) == 1
        data.GYROX_L(i) = data.GYROX_L(i-1)
    end
end

data.fs_IMU = round(rec(imurow).SamplingFrequency);
data.time_IMU = linspace(0,size(data.GYROX_L,1)/data.fs_IMU,size(data.GYROX_L,1));

switch EMGans

    case 'Yes'


nameemg = fieldnames(rec(emgrow).Data)

for i=1:length(nameemg)
    listemg{i,:} = sprintf('rec(%d).Data.%s', emgrow, nameemg{i})
end

figure('units','normalized','outerposition',[0 0 1 1]);

for i=1:length(listemg)
    emg = table2array(eval(listemg{i}));
    EMG(:,i) = emg(:,2)/max(emg(:,2));
    emg = [];
    x(i) = nexttile
    plot(EMG(:,i))
    title(sprintf(nameemg{i}))
end
t = sgtitle('Check EMGs signals, then press ENTER for choosing stage')
t.FontSize = 20, t.FontAngle = "italic", t.FontName = 'Century Gothic'
t.Color = 	'#A2142F';
linkaxes(x, 'x')
zoom on
pause;


[listind,tf] = listdlg('ListString',nameemg,'Name','EMG choice', ...
    'PromptString',['Select the name of the EMG Signal for RIGHT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');

data.EMG_R = table2array(eval(listemg{listind}));
data.EMG_R = data.EMG_R(:,2);

[listind,tf] = listdlg('ListString',nameemg,'Name','EMG choice', ...
    'PromptString',['Select the name of the EMG Signal for LEFT foot'],'OKString','Proceed','ListSize',[250,500], 'SelectionMode', 'single');

data.EMG_L = table2array(eval(listemg{listind}));
data.EMG_L = data.EMG_L(:,2);


for i=2:length(data.EMG_R)

    if isnan(data.EMG_R(i)) == 1
        data.EMG_R(i) = data.EMG_R(i-1)
    end
end

for i=2:length(data.EMG_L)

    if isnan(data.EMG_L(i)) == 1
        data.EMG_L(i) = data.EMG_L(i-1)
    end
end

data.fs_EMG = round(rec(emgrow).SamplingFrequency);
data.time_EMG = linspace(0,size(data.EMG_L,1)/data.fs_IMU,size(data.EMG_L,1));

end


close all

end

