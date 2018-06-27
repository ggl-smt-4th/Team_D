pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary;
    
    mapping(address => Employee) public employees;
    
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    
    modifier payOff(address employeeId) {
        var employee = employees[employeeId];
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
        _;
    }
    

    function addEmployee(address employeeId, uint salary) public onlyOwner{
        var empl = employees[employeeId];
        assert(empl.id == 0x0);
        
        uint sal = sal.mul(1 ether);
        totalSalary = totalSalary.add(sal);
        employees[employeeId] = Employee(employeeId, sal, now);
    }
    

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) payOff(employeeId) {
        var empl = employees[employeeId];
        
        totalSalary = totalSalary.sub(empl.salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeeExist(oldAddress) {
        var empl = employees[oldAddress];
        
        employees[newAddress] = Employee(newAddress, empl.salary, empl.lastPayday);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) payOff(employeeId) {
        var empl = employees[employeeId];
        
        uint sal = salary.mul(1 ether);
        totalSalary = totalSalary.sub(empl.salary).add(sal);
        empl.salary = sal;
        empl.lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) {
        var empl = employees[msg.sender];
        
        uint nextPayday = empl.lastPayday.sub(payDuration);
        assert(nextPayday < now);
        
        empl.lastPayday = nextPayday;
        empl.id.transfer(empl.salary);
    }
}
