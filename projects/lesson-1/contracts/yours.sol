/*作业请提交在这个目录下*/

pragma solidity ^0.4.24;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    constructor() public {
        owner = msg.sender;
    }

    function updateEmployee(address e, uint s) public returns(bool) {
        require(msg.sender == owner);

        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
        return true;
    }

    function addFund() public payable returns (uint) {
        require (msg.sender == owner);

        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance / salary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public returns(bool) {
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
        return true;
    }

    /****** HOMEWORK ******/

    //UPDATE employee address
    function updateEmployeeAddress(address e) public returns(bool) {
        require(msg.sender == owner);
        require(msg.sender != e && e != 0x0);

        if(payoff()) {
            employee = e;
        }
        return true;
    }

    //UPDATE employee salary
    function updateEmployeeSalary(uint s) public returns(bool) {
        require(msg.sender == owner);
        require(s > 0);

        if(payoff()) {
            salary = s;
        }
        return true;
    }

    //清算工资
    function payoff() private returns (bool) {
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            if (payment < address(this).balance) {
                employee.transfer(payment);
            }
        }

        lastPayday = now;
        return true;
    }
}
