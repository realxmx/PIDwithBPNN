%第一版数据3588个
data_O=[2 -13;7 -7;16 0;17 2;22 7];
data_N=[];
for i=1:5
    for j=1:30
        data_N=[data_N;data_O(i,1)+(20*rand-10),data_O(i,2)+(20*rand-10)];
    end
end
data_temp=zeros(1,300);
data_temp(1:2:end)=data_N(1:end,1);
data_temp(2:2:end)=data_N(1:end,2);
data=[];
for i=1:299
    data_rand = data_temp(i) + (data_temp(i+1)-data_temp(i)).*rand(1,11);
    if data_temp(i)>data_temp(i+1)
        data_rand = sort(data_rand,'descend');
    else 
        data_rand = sort(data_rand);
    end
    data = [data,data_temp(i) data_rand ];
end
time=1:3588;
plot(time,data);
xlim([1,24]);
ylim([-20,20]);

data_temp=round(data*100)/100;
writematrix(data_temp);
data=round(data*100)/100;
writematrix(data);