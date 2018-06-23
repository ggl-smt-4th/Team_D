pragma solidity ^0.4.14;
// 在remix中编译，提示要加上这一句，否则报错
pragma experimental ABIEncoderV2;

contract Payroll {

    struct Employee {
        // TODO: your code here
        //        员工信息
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _findEmployee(address employeeId) returns (Employee, uint) {
        // 遍历查找
        for (uint i = 0; i < employees.length; ++i) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function _employeePaid(Employee employee) {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x0);

        employees.push(Employee(employeeAddress, salary * 1 ether, now));
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _employeePaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x0);
        _employeePaid(employee);

        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        uint totalPayment = 0;
        for (uint i = 0; i < employees.length; ++i) {
            totalPayment += employees[i].salary;
        }

        return this.balance / totalPayment;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = now;
        employees[index].id.transfer(employee.salary);
    }
}

