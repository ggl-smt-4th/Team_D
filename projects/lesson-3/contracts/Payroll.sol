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

    mapping(address => Employee) public employees;

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
 
    
    function Payroll() payable public Ownable {
        owner = msg.sender;
    }

   
    modifier shouldNotExist(address employeeId) {
        var temp = employees[employeeId];
        assert(temp.id == 0x0);
        _;
    }

    modifier shouldExist(address employeeId) {
        var temp = employees[employeeId];
        assert(temp.id != 0x0);
        _;
    }
    
    function _partialPaid(address employeeId) private {
        var temp = employees[employeeId];
        uint payment = temp.salary.mul((now.sub(temp.lastPayday))).div(payDuration);
        temp.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner shouldNotExist(employeeId) {
        // TODO: your code here
        uint salaryInEther = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salaryInEther, now);
        totalSalary = totalSalary.add(salaryInEther);
    }

    function removeEmployee(address employeeId) public onlyOwner shouldExist(employeeId){
        // TODO: your code here
        _partialPaid(employeeId);
        uint salary = employees[employeeId].salary;
        totalSalary = totalSalary.sub(salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public 
    onlyOwner shouldExist(oldAddress) shouldNotExist(newAddress) {
        // TODO: your code here
        _partialPaid(oldAddress);
        var temp = employees[oldAddress];
        employees[newAddress] = Employee(newAddress,temp.salary,now);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public 
    onlyOwner shouldExist(employeeId)
    {
        // TODO: your code here
        _partialPaid(employeeId);
        var temp =  employees[employeeId];
        uint oldSalary = temp.salary;
        uint salaryInEther = salary.mul(1 ether);

        temp.salary = salaryInEther;
        temp.lastPayday = now;
        totalSalary = totalSalary.add(salaryInEther).sub(oldSalary);
        
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint runways) {
        // TODO: your code here
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool ) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public shouldExist(msg.sender) {
        // TODO: your code here
        var temp =  employees[msg.sender];
        uint nextPayday = temp.lastPayday.add(payDuration);
        assert(nextPayday < now);
        temp.lastPayday = nextPayday;
        msg.sender.transfer(temp.salary);
    }
}
