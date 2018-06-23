
完成第二课所讲智能合约，添加 100ETH 到合约中

加入十个员工，每个员工的薪水都是 1ETH

每次加入一个员工后调用 calculateRunway() 这个函数，并且记录消耗的 gas。Gas 变化么？如果有，为什么？

如何优化 calculateRunway() 这个函数来减少 gas 的消耗？

calculateRunway gas 变化记录：
1员工后： transaction: 22974，execution: 1702
2员工后： transaction: 23755，execution: 2483
3员工后： transaction: 24536，execution: 3264
4员工后： transaction: 25317，execution: 4045
5员工后： transaction: 26098，execution: 4826
6员工后： transaction: 26879，execution: 5607
7员工后： transaction: 27660，execution: 6388
8员工后： transaction: 28441，execution: 7169
9员工后： transaction: 29222，execution: 7950
10员工后：transaction: 30003，execution: 8731

原因：
每新增一个员工gas就会增加一次，是因为计算runway的时候需要loop一遍所有的员工，ethereum每一次计算都算gas的，所以随着员工的增加，loop的次数越多，gas也就越多了。

优化方案：
在合约中维护一个totalSalary的变量，在每一次增加员工，删除员工，更新员工薪水时同时更新totalSalary变量。这样做就不用每次调用calculateRunway时都要遍历一次所有员工计算总薪酬额度。但是这样做也有个不好的地方就是容易出错，毕竟我们是在多个地方去维护totalSalary变量的。
