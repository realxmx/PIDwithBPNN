%BP based PID Control
clear;
close all;
xite=0.001;%学习率
alfa=0.01;%惯性系数
fx=[1 1000];

IN=4;H=5;Out=3; %神经网络层数

data=readmatrix("datas.txt"); %环境温度变化数据
data=data(1:35000);

%生成随机权重
wt=0.5;

%wi=wt*rands(H,IN);
wi=readmatrix("wi7956.txt");
wi_1=wi;wi_2=wi;wi_3=wi;

%wo=wt*rands(Out,H);
wo=readmatrix("wo7956.txt");
wo_1=wo;wo_2=wo;wo_3=wo;

writematrix(wi);
writematrix(wo);

x=[0,0,0];

du_1=0;%上一次的pid输出

y_1=7;%上一次的实际温度
y_2=0;
y_3=0;

Oh=zeros(H,1); %Output from NN middle layer

I=Oh; %Input to NN middle layer

error_1=0;%上一次误差
error_2=0;
error_3=0;
error_4=0;
error_5=0;

max_grad = 1; % maximum gradient value

for k=1:1:35000

time(k)=k;

rin(k)=20;%目标温度

yout(k) = y_1;%实际温度(根据控制量和环境温差更新）

error(k) = rin(k) - yout(k);%误差

xi=[rin(k),yout(k),error(k),1];%神经网络输入

I=xi*wi'; % [1,4]*[4,5]

% 中间层激活函数
for j=1:1:H
    Oh(j)=tanh(I(j)); %Middle Layer
end

K=wo*Oh; %Output Layer [3,5]*[5,1]

% 输出层激活函数
for l=1:1:Out
    K(l)=sigmoid(K(l)); %Getting kp,ki,kd
end

x(1)=error(k);

x(2)=error(k) + error_1 + error_2 + error_3 + error_4 + error_5;

x(3)=error(k)-error_1;

epid=[x(1);x(2);x(3)];

% 输出层输出结果，PID系数
kp(k)=K(1);ki(k)=K(2);kd(k)=K(3);

Kpid=[kp(k),ki(k),kd(k)];

% 计算PID输出
du(k)=Kpid*epid;
% 计算实际温度
yout(k) = y_1 + du(k) - 0.1*(y_1-data(k));
%计算实际温度与目标温度的误差
error(k) = rin(k) - yout(k);


%Output layer
% 输出层激活函数求导 
for j=1:1:Out
    dK(j)=sigmoidGradient(K(j));
end

% 符号函数，模型输出变化量/控制增量的变化量（+0.0001避免出现除0）
dyu(k)=sign((yout(k)-y_1)/(du(k)-du_1+0.0001));

for l=1:1:Out
    delta3(l)=error(k)*dyu(k)*epid(l)*dK(l);
end

for l=1:1:Out
    for i=1:1:H
        d_wo(l,i)=xite*delta3(l)*Oh(i)+alfa*(wo_1(l,i)-wo_2(l,i));
    end
end

wo=wo_1+d_wo+alfa*(wo_1-wo_2);

%Hidden layer
% 中间层激活函数求导
for i=1:1:H
    dO(i)=1-tanh(I(i))^2;
end

segma=delta3*wo;

for i=1:1:H
    delta2(i)=dO(i)*segma(i);
end

d_wi=xite*delta2'*xi;

wi=wi_1+d_wi+alfa*(wi_1-wi_2);



%Parameters Update

du_1=du(k);

y_2=y_1;y_1=yout(k);

wo_3=wo_2;

wo_2=wo_1;

wo_1=wo;

wi_3=wi_2;

wi_2=wi_1;

wi_1=wi;

error_5=error_4;
error_4=error_3;
error_3=error_2;
error_2=error_1;

error_1=error(k);

end

wi
wo
sum(abs(error))/k

f1=figure;
f1.Position(1:2)=[0,350];
plot(time,rin,'r',time,yout,'b--',time,data);
xlim(fx);
xlabel('时间(6m)');ylabel('温度');
legend('目标','实际','环境');
grid on

f2=figure;
f2.Position(1:2)=[500,350];
plot(time,du,'r');
xlim(fx);
xlabel('时间(6m)');ylabel('控制量');
grid on

f3=figure;
f3.Position(1:2)=[1000,350];
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
