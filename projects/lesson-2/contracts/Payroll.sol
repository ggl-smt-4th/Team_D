pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        // TODO: your code here
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint totalSalary;
    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
        totalSalary = 0;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        uint index = findEmployee(employeeAddress);
        assert(index == employees.length);
        uint salaryInEther = salary * 1 ether;
        employees.push(Employee(employeeAddress, salaryInEther, now));
        totalSalary += salaryInEther;
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        uint index = findEmployee(employeeId);
        assert(index != employees.length);
        partialPaid(index);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length--;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        uint index = findEmployee(employeeAddress);
        assert(index != employees.length);
        partialPaid(index);
        totalSalary -= employees[index].salary;
        uint salaryInEther = salary * 1 ether;
        employees[index].salary = salaryInEther;
        employees[index].lastPayday = now;
        totalSalary += salaryInEther;
        
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        require(employees.length > 0);
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        uint index = findEmployee(msg.sender);
        assert(index != employees.length);

        uint nextPayday = employees[index].lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);
    }
    
    function partialPaid(uint empIndex) private {
        uint partialPay = ( (now - employees[empIndex].lastPayday) * employees[empIndex].salary) / payDuration;
        employees[empIndex].id.transfer(partialPay);
    }
    
    function findEmployee(address empIndex) private view returns (uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == empIndex) {
                return i;
            }
        }
        return employees.length;
    }
    
    
}

