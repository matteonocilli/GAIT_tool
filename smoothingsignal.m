function [lenwindx, lenwinsx] = smoothingsignal(wx_dx, wx_sx, fc_IMU)

% This function does a smoothing of the signal with various windows of 
% predefined length. it will be the user to choose the signal he/she wants
wx_dx1 = wx_dx;
wx_dx2 = smooth(wx_dx,round(fc_IMU/20));
wx_dx3 = smooth(wx_dx,round(fc_IMU/10));
wx_dx4 = smooth(wx_dx,round(fc_IMU/5));

wx_sx1 = wx_sx;
wx_sx2 = smooth(wx_sx,round(fc_IMU/20));
wx_sx3 = smooth(wx_sx,round(fc_IMU/10));
wx_sx4 = smooth(wx_sx,round(fc_IMU/5));


h.myfig = figure('units','normalized','outerposition',[0 0 1 1]); % , 'WindowButtonDownFcn',@callBack);

x(1) = subplot(4,1,1)
plot(wx_dx1) 
title('ID number = 1'), subtitle('Raw Signal')

x(2) = subplot(4,1,2)
plot(wx_dx2)
title('ID number = 2'), subtitle('MA filter window length = 0.05s')

x(3) = subplot(4,1,3)
plot(wx_dx3)
title('ID number = 3'), subtitle('MA filter window length = 0.1s')

x(4) = subplot(4,1,4)
plot(wx_dx4)
title('ID number = 4'), subtitle('MA filter window length = 0.2s')

linkaxes(x,'x')
t = sgtitle('Check the signals of Right Foot and press Enter')
t.FontSize = 20, t.FontAngle = "italic", t.FontName = 'Century Gothic', t.Color = '#A2142F';

zoom on


 while ~waitforbuttonpress
      
 end


for i=1:4
    list{i} = num2str(i);
end

answdx = listdlg('ListString',list,'Name','Choose the Smoothed Signal','PromptString','ID number for the RIGHT FOOT','OKString','Proceed','ListSize',[200,100], 'SelectionMode', 'single');



switch answdx

    case 1
        lenwindx = []
    case 2
       lenwindx = round(fc_IMU/20)
    case 3
        lenwindx = round(fc_IMU/10)
    case 4
        lenwindx = round(fc_IMU/5)
end

close(h.myfig)

h.myfig = figure('units','normalized','outerposition',[0 0 1 1]);

x(1) = subplot(4,1,1)
plot(wx_sx1) 
title('ID number = 1'), subtitle('Raw Signal')

x(2) = subplot(4,1,2)
plot(wx_sx2)
title('ID number = 2'), subtitle('MA filter window length = 0.05s')

x(3) = subplot(4,1,3)
plot(wx_sx3)

title('ID number = 3'), subtitle('MA filter window length = 0.1s')

x(4) = subplot(4,1,4)
plot(wx_sx4)
title('ID number = 4'), subtitle('MA filter window length = 0.2s')


linkaxes(x,'x')
t = sgtitle('Check the signals of Left Foot and press Enter')
t.FontSize = 20, t.FontAngle = "italic", t.FontName = 'Century Gothic', t.Color = '#A2142F';
zoom on

 while ~waitforbuttonpress
       
 end


answsx = listdlg('ListString',list,'Name','Choose the Smoothed SIgnal','PromptString','ID number for the LEFT FOOT','OKString','Proceed','ListSize',[200,100], 'SelectionMode', 'single');


switch answsx

    case 1
        lenwinsx = [];
    case 2
       lenwinsx = round(fc_IMU/20)
    case 3
       lenwinsx = round(fc_IMU/10)
    case 4
        lenwinsx = round(fc_IMU/5)
end

close all

end 