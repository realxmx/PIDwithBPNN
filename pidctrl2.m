clear;
close all;

data = readmatrix("datas.txt");

% 定义模型参数
Kp = 0.5; % 比例增益
Ki = 0.1; % 积分增益
Kd = 0.01; % 微分增益
T = 1; % 控制周期
Tf = 1; % 热传递时间常数
Tamb = data(1:35001); % 环境温度
Qloss = 0.1; % 每6m的热损失

% 定义模拟时间和初始条件
t = 0:1:35000;
T0 = 7;

% 初始化PID控制器
e = 0;
ei = 0;
ed = 0;
last_e = 0;

% 开始模拟
for i = 1:length(t)
    
    x(i)=20;
    % 计算误差
    e = 20 - T0(i);
    
    % 计算PID输出
    u = Kp*e + Ki*ei + Kd*ed;
    
    % 累加误差项
    ei = ei + e*T;
    
    % 计算微分项
    ed = (e - last_e)/T;
    
    % 更新上一次误差项
    last_e = e;
    
    % 计算下一个时刻的温度
    T1 = T0(i) + (u - Qloss*(T0(i)-Tamb(i)))/Tf;
    
    % 更新初始条件
    T0(i+1) = T1;
end

% 绘制温度随时间的变化曲线
plot(t,x,'r',t,T0(1:end-1),'b--');
xlim([1 1000]);
xlabel('时间 (6m)');
ylabel('温度 (C)');
title('PID 温控');
