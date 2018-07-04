pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";


contract Payroll is Ownable {

    using SafeMath for uint;

    uint constant PAY_DURATION = 30 days;

    uint totalSalary = 0;
    mapping(address => Employee) public employees;

    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    /// @dev Use an additional flag to indicate partial pay.
    modifier employeeExists(address employeeId, bool partialPay) {
        Employee memory employee = employees[employeeId];
        require(employee.id != 0x0);
        if (partialPay) {
            uint payment = employee.salary.mul(now.sub(employee.lastPayDay)).div(PAY_DURATION);
            employee.id.transfer(payment);
        }
        _;
    }

    function Payroll() payable public {}

    function addEmployee(address employeeId, uint salary) public onlyOwner {
        Employee memory employee = employees[employeeId];
        require(employee.id == 0x0);

        employee = Employee(employeeId, salary.mul(1 ether), now);
        employees[employeeId] = employee;
        totalSalary = totalSalary.add(employee.salary);
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExists(employeeId, true) {
        Employee memory employee = employees[employeeId];

        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(
        address oldAddress,
        address newAddress
    ) public onlyOwner employeeExists(oldAddress, true)
    {
        Employee memory employee = employees[oldAddress];

        employee.id = newAddress;
        employee.lastPayDay = now;
        delete employees[oldAddress];
        employees[newAddress] = employee;
    }

    function updateEmployee(
        address employeeId,
        uint salary
    ) public onlyOwner employeeExists(employeeId, true)
    {
        Employee memory employee = employees[employeeId];

        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        employee.lastPayDay = now;
        employees[employeeId] = employee;
        totalSalary = totalSalary.add(employee.salary);
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

    function getPaid() employeeExists(msg.sender, false) public {
        Employee memory employee = employees[msg.sender];

        uint nextPayDay = employee.lastPayDay.add(PAY_DURATION);
        assert(nextPayDay < now);

        employees[msg.sender].lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
