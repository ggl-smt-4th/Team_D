/*作业请提交在这个目录下*/
contract Payroll {
    uint salary = 1 ether;
    //    设置owner为合约的创建者
    address owner;
    address employee;
    uint constant payDuration = 30 days;
    uint lastPayday = now;

    constructor() public {
        owner = msg.sender;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        if (msg.sender != employee) {
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        lastPayday = nextPayday;
        employee.transfer(salary);
    }

    //    设置新的地址
    function updateAddress(address e) {
        //        先校验调用者是否为owner，否则不可调用
        require(msg.sender == owner);
        //        校验新的地址是否有效
        require(e != 0x0);
        //        计算老员工应得到的工资
        uint paySalary = salary * (now - lastPayday) / payDuration;
        employee = e;
        lastPayday = now;
        employee.transfer(paySalary);
    }

    //    设置新的薪水
    function updateSalary(uint s) {
        //        先校验调用者是否为owner，否则不可调用
        require(msg.sender == owner);
        uint paySalary = salary * (now - lastPayday) / payDuration;
        salary = s * 1 ether;
        lastPayday = now;
        employee.transfer(paySalary);
    }

    //    用一个方法修改两个状态变量
    function updateAddressAndSalary(address e, uint s) {
        //        先校验调用者是否为owner，否则不可调用
        require(msg.sender == owner);
        //        校验新的地址是否有效
        require(e != 0x0);
        uint paySalary = salary * (now - lastPayday) / payDuration;
        employee = e;
        lastPayday = now;
        salary = s * 1 ether;
        employee.transfer(paySalary);
    }

}