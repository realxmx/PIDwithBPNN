clear;
close all;

IN = 4;H = 5;Out = 3; %节点数

data = readmatrix("datas.txt"); %环境温度数据
data = data(1:35000);
rate = 0.001;%学习率
rate2 = 0.01;%惯性系数
fx = [1 1000];

%生成随机权重
%wt = 0.5;
%w1 = wt*rands(H,IN);
%w2 = wt*rands(Out,H);

w1 = readmatrix("wi7956.txt");
w1_1 = w1;%缓存上一步的权重
w1_2 = w1;

w2 = readmatrix("wo7956.txt");
w2_1 = w2;
w2_2 = w2;

writematrix(w1);
writematrix(w2);

u_1 = 0;%上一步的pid输出

y_1 = 7;%初始温度

error_1 = 0;%上一步误差
error_2 = 0;
error_3 = 0;
error_4 = 0;
error_5 = 0;

for k = 1:1:35000

    time(k) = k;
    %目标温度
    x(k) = 20;
    %实际温度(根据控制量和环境温差更新）
    y(k) = y_1;
    %误差
    error(k) = x(k) - y(k);
    %神经网络输入
    I1 = [x(k),y(k),error(k),1];
    %[1,4]*[4,5]
    I2 = I1*w1'; 

    O2 = zeros(H,1);

    for j = 1:1:H
        %隐藏层输出
        O2(j) = tanh(I2(j)); 
    end
    %[3,5]*[5,1]
    I3 = w2*O2; 

    for l = 1:1:Out
        %输出层输出
        O3(l) = sigmoid(I3(l)); 
    end

    e = [error(k);error(k) + error_1 + error_2 + error_3 + error_4 + error_5;error(k)-error_1];

    % 输出层输出结果，PID系数
    kp(k) = O3(1);ki(k) = O3(2);kd(k) = O3(3);

    Kpid = [kp(k),ki(k),kd(k)];

    % 计算PID输出
    u(k) = Kpid*e;
    % 计算实际温度
    y(k) = y_1 + u(k) - 0.1*(y_1-data(k));
    %计算实际温度与目标温度的误差
    error(k) = x(k) - y(k);

    %反向传播
    for j = 1:1:Out
        %输出层输入
        dO3(j) = sigmoidGradient(O3(j));
    end

    % 符号函数，实际温度变化量/控制量的变化量（+0.0001避免出现除0）
    du(k) = sign((y(k)-y_1)/(u(k)-u_1+0.0001));

    for l = 1:1:Out
        delta3(l) = error(k)*du(k)*e(l)*dO3(l);
    end

    for l = 1:1:Out
        for i = 1:1:H
            d_w2(l,i) = rate*delta3(l)*O2(i);
        end
    end

    w2 = w2_1+d_w2+rate2*2*(w2_1-w2_2);

    for i = 1:1:H
        %隐藏层输入
        dO2(i) = 1-tanh(I2(i))^2;
    end

    a = delta3*w2;

    for i = 1:1:H
        delta2(i) = dO2(i)*a(i);
    end

    d_w1 = rate*delta2'*I1;

    w1 = w1_1+d_w1+rate2*(w1_1-w1_2);

    %缓存本步参数
    u_1 = u(k);

    y_1 = y(k);

    w2_2 = w2_1;
    w2_1 = w2;

    w1_2 = w1_1;
    w1_1 = w1;

    error_5 = error_4;
    error_4 = error_3;
    error_3 = error_2;
    error_2 = error_1;
    error_1 = error(k);

end

%输出平均误差
sum(abs(error))/k

f1 = figure;
f1.Position(1:2) = [0,350];
plot(time,x,'r',time,y,'b--',time,data);
xlim(fx);
xlabel('时间(6m)');ylabel('温度');
legend('目标','实际','环境');
grid on

f2 = figure;
f2.Position(1:2) = [500,350];
plot(time,u,'r');
xlim(fx);
xlabel('时间(6m)');ylabel('控制量');
grid on

f3 = figure;
f3.Position(1:2) = [1000,350];
subplot(311);

plot(time,kp,'r');
xlim(fx);
xlabel('时间(6m)');ylabel('kp');
grid on
subplot(312);

plot(time,ki,'g');
xlim(fx);
xlabel('时间(6m)');ylabel('ki');
grid on
subplot(313);

plot(time,kd,'b');
xlim(fx);
xlabel('时间(6m)');ylabel('kd');
grid on
