pragma solidity ^0.4.21;

contract Payroll {
    uint salary = 1 ether;
    address frank = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        if (msg.sender != frank) {
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        lastPayday = nextPayday;
        frank.transfer(salary);
    }

//    设置新的地址
    function set(address newAddress) {
        frank = newAddress;
    }

//    设置新的薪水
    function set(uint newSalary) {
        salary = newSalary;
    }

}