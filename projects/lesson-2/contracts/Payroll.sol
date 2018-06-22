pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
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
    
    function _payOff(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmpl(address id) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            if(employees[i].id == id) {
                return (employees[i], i);
            }
        }
        return;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmpl(employeeAddress);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeAddress, salary * 1 ether, now));
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmpl(employeeId);
        assert(employee.id != 0x0);
        _payOff(employee);
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmpl(employeeAddress);
        assert(employee.id != 0x0);
        _payOff(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        uint sumSalary;
        for(uint i = 0; i < employees.length; i++) {
            sumSalary += employees[i].salary;
        }
        
        return this.balance / sumSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee, index) = _findEmpl(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
