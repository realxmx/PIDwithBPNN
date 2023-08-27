
% 定义输入数据
X = [1 2 3 1; 2 3 4 1; 3 4 5 1; 4 5 6 1]; % 4个输入样本，每个样本4个特征，最后一个特征是偏置值

% 定义输出数据
Y = [2 3 4; 3 4 5; 4 5 6; 5 6 7]; % 对应的4个输出标签，每个输出标签有3个值

% 定义输入层和隐藏层的神经元个数
input_layer_size = 4; % 输入层神经元个数
hidden_layer_size = 5; % 隐藏层神经元个数

% 初始化神经网络的参数
Theta1 = randn(hidden_layer_size, input_layer_size + 1); % 输入层到隐藏层的权重矩阵，包括偏置项
Theta2 = randn(3, hidden_layer_size + 1); % 隐藏层到输出层的权重矩阵，包括偏置项

%接下来进行神经网络的训练：

% 训练神经网络
num_iters = 10000; % 迭代次数
lambda = 0.1; % 正则化系数
alpha = 0.1; % 学习率

for i = 1:num_iters
    % 前向传播，计算每个隐藏层神经元和输出层神经元的输出值
    a1 = X'; % 输入数据转置，每个样本占一列
    z2 = Theta1 * [ones(1, size(X, 1)); a1]; % 加上偏置项，计算隐藏层输入
    a2 = sigmoid(z2); % 计算隐藏层输出
    z3 = Theta2 * [ones(1, size(X, 1)); a2]; % 加上偏置项，计算输出层输入
    a3 = z3; % 线性激活函数，输出层直接输出输入值

    % 计算输出层的误差，反向传播误差到隐藏层和输入层
    d3 = a3 - Y'; % 计算输出层的误差
    d2 = Theta2(:, 2:end)' * d3 .* sigmoidGradient(z2); % 反向传播误差到隐藏层

    % 根据误差更新神经网络的参数
    Theta2_grad = d3 * [ones(1, size(X, 1)); a2'] / size(X, 1); % 计算隐藏层到输出层的权重梯度
    Theta1_grad = d2 * [ones(1, size(X, 1)); a1'] / size(X, 1); % 计算输入层到隐藏层的权重梯度

    % 添加正则化项，并使用梯度下降法更新神经网络的参数
    Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + lambda / size(X, 1) * Theta2(:, 2:end); % 添加正则化项
    Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + lambda / size(X, 1) * Theta1(:, 2:end); % 添加正则化项

    alpha = 0.1; % 学习率
    Theta2 = Theta2 - alpha * Theta2_grad; % 更新隐藏层到输出层的权重
    Theta1 = Theta1 - alpha * Theta1_grad; % 更新输入层到隐藏层的权重
end