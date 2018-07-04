pragma solidity ^0.4.14;
// 在remix中编译，提示要加上这一句，否则报错
pragma experimental ABIEncoderV2;

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

    mapping(address => Employee) public employees;

    // 继承了Ownable，因此此构造函数可以删除掉
    function Payroll() payable public {
        // TODO: your code here
        owner = msg.sender;
    }

    modifier employeeExist (address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
        // TODO: your code here
        var employee = employees[employeeId];
        assert(employee.id == 0x0);

        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        // TODO: your code here
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public employeeExist(oldAddress) {
        // TODO: your code here
        var employee = employees[oldAddress];
        var salary = employee.salary;
        var lastPayday = employee.lastPayday;
        employees[newAddress] = Employee(newAddress, salary, lastPayday);

        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
        // TODO: your code here
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary;
        totalSalary += salary * 1 ether;

        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday += payDuration;

        assert(nextPayday < now);

        employees[msg.sender].lastPayday = now;
        employees[msg.sender].id.transfer(employee.salary);
    }
}
