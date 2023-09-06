# PIDwithBPNN
根据某市半年中每月最高最低温度，用三次样条插值生成三万多个温度数据，输入模型中模拟误差
## 模型结构
使用全连接层输出Kp、Ki、Kd，PID结合温度变化模型得出结果，然后输入全连接层不断迭代，类似RNN
![屏幕截图 2023-09-06 162430](https://github.com/realxmx/PIDwithBPNN/assets/95325546/321c1ccf-4833-480e-9f36-d724735dea5c)
![屏幕截图 2023-09-06 165507](https://github.com/realxmx/PIDwithBPNN/assets/95325546/e51b038b-3bfc-4518-ab3a-58e2523ed147)
![屏幕截图 2023-09-06 165421](https://github.com/realxmx/PIDwithBPNN/assets/95325546/79b9008a-5a88-45d0-b473-17190a1100ce)  
PID及温度模型  
![屏幕截图 2023-09-06 165303](https://github.com/realxmx/PIDwithBPNN/assets/95325546/cbe54ec0-c06f-41a6-a84f-33205c8fa86f)
## 模拟结果
纯PID  
![untitled2](https://github.com/realxmx/PIDwithBPNN/assets/95325546/1fcaa316-3293-4720-a5db-c73bbe1f10c3)  
基于神经网络的PID  
![untitled1](https://github.com/realxmx/PIDwithBPNN/assets/95325546/3ffe8634-96fd-401b-a3df-81553791e690)  
Kp、Ki、Kd变化  
![屏幕截图 2023-09-06 162038](https://github.com/realxmx/PIDwithBPNN/assets/95325546/52ead66b-34e8-439f-89d0-f08deebb16c1)
