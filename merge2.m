%生成插值数据2991个，
data_O=[2 -13;7 -7;16 0;17 2;22 7];
data_N=[];
for i=1:5
    for j=1:30
        data_N=[data_N;data_O(i,1)+(10*rand-10),data_O(i,2)+(10*rand-10)];
    end
end
data_temp=zeros(1,300);
data_temp(1:2:end)=data_N(1:end,1);
data_temp(2:2:end)=data_N(1:end,2);

time=1:300;
x=1:0.1:300;
y=spline(time,data_temp,x);
plot(y);
xlim([1 120]);
y=round(y*100)/100;
writematrix(y);