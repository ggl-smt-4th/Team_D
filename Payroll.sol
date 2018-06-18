pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address boss = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration = 30 days;
    uint lastPayday = now;
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if(msg.sender != frank){
            revert();
        }
        
        uint nextPayDay = lastPayday + payDuration;
        
        if(nextPayDay > now) {
            revert();
            
        }
        
        lastPayday = nextPayDay;
        frank.transfer(salary);
    }

    //homework
    //only frank can set the address
    function setAddress(address addr) {
        if(msg.sender != frank) {
            revert();
        }
        
        frank = addr;
    }
    
    // only the boss can adjust the salary
    function setSalary(uint sal) {
        if(msg.sender != boss) {
            revert();
        }
        
        salary = sal;
    }
}