pragma solidity ^0.4;

contract Payroll{
    
    uint constant payDuration = 10 seconds;
    uint constant defaltSalary = 1 ether;
    uint salary;
    address employer;
    address employee;
    uint lastPayday;
    
    function Payroll(){
        employer = msg.sender;
        lastPayday = now;
        salary = defaltSalary;
    }
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunWay() returns(uint){
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns(bool){
        return calculateRunWay() > 0;
    }
    
    function getPaid(){
        if(msg.sender != employee){
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        
        if(nextPayday > now){
            revert();
        }
        else{
            lastPayday = nextPayday;
            employee.transfer(salary);
        }
        
    }
    
    function setEmployInfo(address addrEmployee) {
        
        if(msg.sender != employer){
            revert();
        }
        if(employee == addrEmployee){
            return;
        }
        
        if(employee != 0x0){
            uint payLastEmploy = ((now - lastPayday) / payDuration) * salary;
            employee.transfer(payLastEmploy);
        }
        
        employee = addrEmployee;
        lastPayday = now;
        
    }
    
    function changeSalary(uint employeeSalary) {
        
        if(msg.sender != employer){
            revert();
        }
        
        
        if(employee != 0x0){
            uint payLastEmploy = ((now - lastPayday) / payDuration) * salary;
            employee.transfer(payLastEmploy);
        }
        
        salary = employeeSalary * 1 ether;
        lastPayday = now;
        
        
        
    }
    
    function kill() public{
        if(msg.sender == employer){
            selfdestruct(employer);
        }
    }
    
}
