%pid控制器
data=readmatrix("datas.txt");
dt=data(1,1:1000);

sys=tf(2,[10 1]);
c=pid(1,0.1,0.01);
t=feedback(sys*c,1);
%step(t);

%time=1:1:numel(dt);
%dt=dt';

y=zeros(1000,1);
for i=1:1:numel(dt)
    y(i)=lsim(t,dt(i),i);
end

plot(y);
%r=20;
%e=zeros(3588);
%u=zeros(3588);
%ts=0.1;
%set(c,'SampleTime',ts);

%for i=1:3588
%    temp=data(i);
%    e(i)=r-temp;
%    u(i)=c(e(i));
%end

%x=-2*pi:pi/20:2*pi;   
%y1=sin(x);  

%temp=ones(1000,1);
