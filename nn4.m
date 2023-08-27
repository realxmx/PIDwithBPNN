clear;
close all;

% 神经网络参数
IN = 3;
H = 5;
Out = 3;

% 学习率和惯性系数
xite = 0.20;
alfa = 0.05;

% 初始化权重
wi = 0.5 * rand(H, IN);
wo = 0.5 * rand(Out, H);

% 初始化变量
y_1 = 0.001;
du_1 = 0;
error_1 = 0;
error_2 = 0;
error_3 = 0;
error_4 = 0;
error_5 = 0;

% 模拟时间
sim_time = 6000;

% 预分配数组
rin = zeros(1, sim_time);
yout = zeros(1, sim_time);
error = zeros(1, sim_time);
kp = zeros(1, sim_time);
ki = zeros(1, sim_time);
kd = zeros(1, sim_time);
du = zeros(1, sim_time);

% 环境温度数据
data = readmatrix("datas.txt");
data = data(1:sim_time);

for k = 1:sim_time
    % 目标温度
    rin(k) = 0.1;

    % 计算误差
    error(k) = rin(k) - y_1;

    % 神经网络输入
    xi = [rin(k), y_1, error(k)];

    % 前向传播
    I = xi * wi';
    Oh = tanh(I);
    K = wo * Oh';
    Kpid = tanh(K);

    % 计算PID参数
    kp(k) = Kpid(1);
    ki(k) = Kpid(2);
    kd(k) = Kpid(3);

    % 计算控制量
    x = [error(k), error(k) + error_1 + error_2 + error_3 + error_4 + error_5, error(k) - error_1];
    du(k) = kp(k) * x(1) + ki(k) * x(2) + kd(k) * x(3);

    % 计算新的实际温度
    yout(k) = y_1 + du(k) - 0.1 * (y_1 - data(k));

    % 更新误差
    error(k) = rin(k) - yout(k);

    % 反向传播
    dK = 1 - tanh(K).^2;
    delta3 = error(k) * sign((yout(k) - y_1) / (du(k) - du_1 + 0.0001)) .* x .* dK;
    for l=1:1:Out
        for i=1:1:H
            d_wo(l,i)=xite*delta3(l)*Oh(i);
        end
    end

    wo = wo + d_wo;

    dO = 1 - tanh(I).^2;
    delta2 = dO .* (delta3 * wo);
    d_wi = xite * delta2' .* xi;
    wi = wi + d_wi;

    % 更新变量
    y_1 = yout(k);
    du_1 = du(k);
    error_5 = error_4;
    error_4 = error_3;
    error_3 = error_2;
    error_2 = error_1;
    error_1 = error(k);
end

% 绘制结果
fx=[1 10];
figure;
subplot(2, 1, 1);
plot(1:sim_time, rin, 'r', 1:sim_time, yout, 'b--');
xlim(fx);
xlabel('Time (s)');
ylabel('Temperature');
legend('Target Temperature', 'Actual Temperature');
grid on;

subplot(2, 1, 2);
plot(1:sim_time, error, 'r');
xlim(fx);
xlabel('Time (s)');
ylabel('Error');
grid on;
