pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    mapping(address=>Employee) public employees;

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    function Payroll() payable public {
        // TODO: your code here
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul((now.sub(employee.lastPayday))).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner{
        // TODO: your code here
        var employee = employees[employeeId];
        assert(employee.id == 0x0);

        // update totalSalary
        totalSalary = totalSalary.add(salary.mul(1 ether));
        employees[employeeId] = Employee(employeeId , salary.mul(1 ether), now);
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        // TODO: your code here
        var employee = employees[employeeId];

        // update totalSalary
        totalSalary = totalSalary.sub(employee.salary);

        _partialPaid(employee);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeeExist(oldAddress) {
        // TODO: your code here
        // cannot be owner, employee address only
        require(newAddress != msg.sender);

        Employee memory employee = employees[oldAddress];
        employees[newAddress] = Employee(employee.id, employee.salary, employee.lastPayday);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId){
        // TODO: your code here
        var employee = employees[employeeId];

        // update totalSalary
        totalSalary = totalSalary.add(salary.mul(1 ether));
        totalSalary = totalSalary.sub(employee.salary);

        _partialPaid(employee);
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        require(totalSalary > 0);
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) returns(bool) {
        // TODO: your code here
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        return true;
    }
}
