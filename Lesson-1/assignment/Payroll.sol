pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    struct Employee{
        address id;
        uint salary;
        uint lastPayDay;
    }
    using SafeMath for uint;
    address owner;
    uint payDuration = 10 seconds ;
    mapping(address => Employee) public employees;

    uint totalSalary;

    modifier employeeExist(address employeeId){

        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    modifier employeeNotExist(address employeeId){

        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }



    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now.sub(employee.lastPayDay)).div(payDuration);

        employee.id.transfer(payment);
    }


    function addEmployee(address employeeId ,uint salary) public onlyOwner employeeExist(employeeId){

        var employee = employees[employeeId];

        uint userSalary = salary * 1 ether;
        employees[employeeId]=Employee(employeeId,userSalary,now);
        totalSalary = totalSalary.add(userSalary);

    }
    function removeEmployee(address employeeId) public onlyOwner employeeNotExist(employeeId){

        var employee = employees[employeeId];

        _partialPaid(employee);
        delete employees[employeeId];

        totalSalary = totalSalary.sub(employee.salary);
    }
    function updateEmployee(address employeeId,uint salary) public onlyOwner employeeNotExist(employeeId){

        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub((employee.salary.sub(salary)));
        employee.salary = salary;
        employee.lastPayDay=now;
    }

    function addFund() payable public returns (uint) {

        return this.balance;
    }

    function calculateRunway() public view onlyOwner returns (uint) {

        return  this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view onlyOwner returns (bool) {

        return calculateRunway()>0;
    }
    // function checkEmployee(address employeeId) public returns (uint salary,uint lastPayDay){
    //     var employee = employees[employeeId];
    //     assert(employee.id != 0x0);
    //     salary = employee.salary;
    //     lastPayDay = employee.lastPayDay;
    // }
    function getPaid() public employeeNotExist(msg.sender){
        var employee = employees[msg.sender];

        uint nextPayDay = employee.lastPayDay.add(payDuration) ;

        assert(nextPayDay < now);

        employee.lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);

    }
    function changePaymentAddress(address oldId, address newId) public onlyOwner employeeNotExist(oldId) employeeExist(newId){
        var employee = employees[oldId];

        var e = Employee(newId,employee.salary,now);
        employees[newId] = e;
        _partialPaid(employee);

        delete employees[oldId];

    }
}
