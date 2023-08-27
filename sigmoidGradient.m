% 计算sigmoid函数的导数
function g = sigmoidGradient(z)
g = sigmoid(z) .* (1 - sigmoid(z));
end
