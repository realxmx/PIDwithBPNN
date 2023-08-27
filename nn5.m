% 设置目标温度
target_temperature = 25;

% 初始化实际温度和环境温度
actual_temperature = 20;
T = -20 + (30 - (-20)) * rand();

% 初始化神经网络权重
W1 = rand(3, 10);
W2 = rand(10, 3);

% 误差
error = target_temperature - actual_temperature;
error_prev = error;

% 设置收敛阈值和最大迭代次数
convergence_threshold = 0.1;
max_iterations = 1000;

% 定义sigmoid函数
sigmoid = @(x) 1 ./ (1 + exp(-x));

% 迭代计算
for k = 1:max_iterations
    % 输入神经网络
    input = [target_temperature; actual_temperature; error];
    hidden = sigmoid(W1 * input);
    output = W2 * hidden;

    % 获取神经网络输出的PID参数
    kp = output(1);
    ki = output(2);
    kd = output(3);

    % 计算控制量
    u = kp * error + ki * sum(error) + kd * (error - error_prev);

    % 更新实际温度
    actual_temperature_new = actual_temperature + u - 0.1 * (actual_temperature - T);

    % 计算新的误差
    error_prev = error;
    error = target_temperature - actual_temperature_new;

    % 更新神经网络权重
    delta2 = error * hidden';
    delta1 = (W2' * error) .* hidden .* (1 - hidden);
    delta1 = delta1 * input';
    W2 = W2 + 0.1 * delta2;
    W1 = W1 + 0.1 * delta1;

    % 检查是否达到收敛阈值
    if abs(error) < convergence_threshold
        break;
    end

    % 更新实际温度
    actual_temperature = actual_temperature_new;
end

% 输出结果
fprintf('目标温度: %.2f\n', target_temperature);
fprintf('实际温度: %.2f\n', actual_temperature);
fprintf('迭代次数: %d\n', k);

