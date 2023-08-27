clear;
close all;
% 设置输入和输出数据
X = [1 2 3; 2 3 4; 3 4 5; 4 5 6]; % 输入数据，四个样本，每个样本有三个特征
Y = [2 3 4; 3 4 5; 4 5 6; 5 6 7]; % 输出数据，四个样本，每个样本有三个目标值

% 设置神经网络的参数
input_layer_size = size(X, 2); % 输入层大小为3
hidden_layer_size = 5; % 隐藏层大小为5
output_layer_size = size(Y, 2); % 输出层大小为3
epsilon_init = 0.12; % 随机初始化权重的范围

% 随机初始化权重
Theta1 = rand(hidden_layer_size, input_layer_size + 1) * 2 * epsilon_init - epsilon_init; % 隐藏层权重
Theta2 = rand(output_layer_size, hidden_layer_size + 1) * 2 * epsilon_init - epsilon_init; % 输出层权重

steps=10000; % 训练步数

for i=1:steps

% 前向传播计算代价函数
m = size(X, 1); % 样本数量
a1 = [ones(m, 1) X]; % 添加偏置值
z2 = a1 * Theta1'; % 隐藏层输入
a2 = [ones(m, 1) tanh(z2)]; % 隐藏层输出，添加偏置值并使用tanh激活函数
z3 = a2 * Theta2'; % 输出层输入
h = 100 * tanh(z3); % 输出层输出，使用100 * tanh(x)激活函数
J = 1/(2*m) * sum(sum((h - Y).^2)); % 代价函数

% 反向传播计算梯度
delta3 = (h - Y) .* (1 - tanh(z3).^2) * 100; % 输出层误差
delta2 = delta3 * Theta2(:, 2:end) .* (1 - tanh(z2).^2); % 隐藏层误差
Delta1 = delta2' * a1; % 隐藏层权重梯度
Delta2 = delta3' * a2; % 输出层权重梯度
Theta1_grad = 1/m * Delta1; % 隐藏层权重梯度
Theta2_grad = 1/m * Delta2; % 输出层权重梯度

% 添加正则化项
lambda = 0.1; % 正则化参数
Theta1(:, 1) = 0; % 不对偏置值进行正则化
Theta2(:, 1) = 0; % 不对偏置值进行正则化
Theta1_grad = Theta1_grad + lambda/m * Theta1; % 隐藏层权重梯度加上正则化项
Theta2_grad = Theta2_grad + lambda/m * Theta2; % 输出层权重梯度加上正则化项

% 梯度下降更新权重
alpha = 0.01; % 学习率
Theta1 = Theta1 - alpha * Theta1_grad; % 更新隐藏层权重
Theta2 = Theta2 - alpha * Theta2_grad; % 更新输出层权重

end

writematrix(Theta1);
writematrix(Theta2);
