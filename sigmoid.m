% 定义sigmoid函数
function g = sigmoid(z)
% 计算sigmoid函数
g = 1 ./ (1 + exp(-z));
end
