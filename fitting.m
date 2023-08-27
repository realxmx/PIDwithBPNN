%拟合数据，
time=1:300;
data=readmatrix("data_temp.txt");
p=polyfit(time,data,5);

x=1:0.1:300;
y=polyval(p,x);
%plot(x,y,time,data);

yy=spline(time,data,x);
plot(time,data,'*',x,yy);
xlim([1,12]);
x=x';
yy=yy';
model=fit(yy,x,'ploy3');
plot(model);