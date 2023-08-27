clear;
close all;

X = [3 5 8; 0 23 4; 6 9 5; 4 1 16];

input_layer_size = size(X, 2); % 输入层大小为3

% 随机初始化权重
Theta1 = readmatrix("Theta1.txt"); % 隐藏层权重
Theta2 = readmatrix("Theta2.txt"); % 输出层权重

% 前向传播计算代价函数
m = size(X, 1); % 样本数量
a1 = [ones(m, 1) X]; % 添加偏置值
z2 = a1 * Theta1'; % 隐藏层输入
a2 = [ones(m, 1) sigmoid(z2)]; % 隐藏层输出，添加偏置值并使用sigmoid激活函数
z3 = a2 * Theta2'; % 输出层输入
h = z3; % 输出层输出，使用线性激活函数
h