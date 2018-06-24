pragma solidity ^0.4.14;


contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant PAY_DURATION = 30 days;

    address owner;
    Employee[] employees;
    uint totalSalary;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salaryInEther) public {
        require(msg.sender == owner);
        uint i = findEmployee(employeeAddress);
        assert(i == employees.length);

        employees.push(Employee(employeeAddress, salaryInEther * 1 ether, now));
        totalSalary += salaryInEther * 1 ether;
    }

    function removeEmployee(address employeeAddress) public {
        require(msg.sender == owner);
        uint i = findEmployee(employeeAddress);
        assert(i < employees.length);

        partialPay(employees[i]);
        totalSalary -= employees[i].salary;
        delete employees[i];
        employees[i] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salaryInEther) public {
        require(msg.sender == owner);
        uint i = findEmployee(employeeAddress);
        assert(i < employees.length);

        partialPay(employees[i]);
        totalSalary += salaryInEther * 1 ether - employees[i].salary;
        employees[i].salary = salaryInEther * 1 ether;
        employees[i].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    /// @dev Instead of looping, use recorded total salary directly.
    function calculateRunway() public view returns (uint) {
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        uint i = findEmployee(msg.sender);
        assert(i < employees.length);
        Employee storage employee = employees[i];

        uint nextPayday = employee.lastPayday + PAY_DURATION;
        assert(nextPayday < now);

        // Update storage.
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    function partialPay(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / PAY_DURATION;
        employee.id.transfer(payment);
    }

    /// @dev Use length of employee array to indicate "not found".
    function findEmployee(address employeeAddress) private view returns (uint index) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeAddress) {
                return i;
            }
        }
        return employees.length;
    }
}

