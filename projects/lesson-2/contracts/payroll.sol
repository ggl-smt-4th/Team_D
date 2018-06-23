pragma solidity ^0.4.23;

contract Payroll {

    struct Employee {
        // TODO: your code here
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    //uint constant payDuration = 10 seconds;
    uint private totalSalary = 0;

    address owner;
    Employee[] employees;

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private view returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    constructor() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeAddress, salary * 1 ether, now));

        // update totalSalary
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        // update totalSalary
        totalSalary -= employee.salary;

        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var(employee, index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x0);

        // update totalSalary
        totalSalary = totalSalary - employee.salary + salary * 1 ether;

        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        // uint totalSalary = 0;
        // for (uint i=0; i < employees.length; i++) {
        //     totalSalary += employees[i].salary;
        // }
        // return address(this).balance / totalSalary;

        return address(this).balance / totalSalary;
    }

    function getTotalSalary() public view returns(uint) {
        return totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var(employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
