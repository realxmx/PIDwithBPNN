%第一版数据插值
data=readmatrix('data.txt');

sizes=3588;
time=1:sizes;
x=1:0.1:sizes;
y=spline(time,data,x);

plot(y);
xlim([1 24]);
datas=round(y*100)/100;
writematrix(datas);