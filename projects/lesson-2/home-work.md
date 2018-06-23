先给合约100ETH
加入十个员工
<br>
地址如下：
<br>
0x14723a09acff6d2a60dcdf7aa4aff308fddc160c
<br>
transaction cost: 23115
<br>
execution cost: 1843
<br>
<br>

0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db
<br>
transaction cost: 23891
<br>
execution cost: 2619
<br>
<br>

0x583031d1113ad414f02576bd6afabfb302140225
<br>
transaction cost: 24667
<br>
execution cost: 3395
<br>
<br>

0xdd870fa1b7c4700f2bd7f44238821c26f7392148
<br>
transaction cost: 25443
<br>
execution cost: 4171
<br>
<br>

0x9bf6dc3b8397fb361905f9ba61c7a78875f86e97
<br>
transaction cost: 26219
<br>
execution cost: 4947
<br>
<br>

0xef8e4c39648e8ba81bc8c786b65d2f19f43dbec1
<br>
transaction cost: 26995
<br>
execution cost: 5723
<br>
<br>

0x25da5b8bee45dddfba9cc52977f3f87fbd9cb771
<br>
transaction cost: 27771
<br>
execution cost: 6499
<br>
<br>

0x7091a3e32085d43ff958c8353a7b9128cd2b6d53
<br>
transaction cost: 28547
<br>
execution cost: 7275
<br>
<br>

0x4aefe0f6a65450ee3b339da607a6eac09b1ab099
<br>
transaction cost: 29323
<br>
execution cost: 8051
<br>
<br>

0x028077d9c84f840eef458a2d7b04057f57219070
<br>
transaction cost: 30099
<br>
execution cost: 8827
<br>
<br>

####gas越来越多，是因为employees数组中的数据越来越来越多了，因此相加的次数会变多，gas消耗因此也会变多
####如果是每次调用addEmployee之后要调用calculateRunway，那么可以设置一个状态变量来表示工资的总和，然后在每次调用calculateRunway的时候，将新增的雇员工资加入到这个总的状态变量中，那么就不用每次都遍历整个数组了