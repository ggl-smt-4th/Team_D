/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract PayRoll{
    uint salary;
    address mainAddr;
    
    address canPaidAddr;
    uint payDurtion = 10 seconds;
    uint lastPayDay = now;
    function PayRoll(){
        mainAddr = msg.sender;
    }
    function updateEmployee(address userAddr,uint money) returns (bool){
        require(msg.sender==mainAddr);
        
        if(userAddr != 0x0){
            uint payment = salary* ((now - lastPayDay)/payDurtion);
            canPaidAddr.transfer(payment);
        }
        
        if(canPaidAddr!=userAddr){
            canPaidAddr=userAddr;
        }
        if(salary!=money){
            salary = money * 1 ether;
        }
        lastPayDay=now;
        return true;
    }
    
    function addFund() payable returns (uint){
        require(msg.sender==mainAddr);
        return this.balance;
    }
    
    function calculteRunway() returns (uint){
        require(msg.sender==mainAddr);
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        require(msg.sender==mainAddr);
        return calculteRunway()>0;
    }
    
    function getPaid(){
        require(msg.sender==canPaidAddr);
        
        uint nextPayDay = lastPayDay + payDurtion;
        
        assert(nextPayDay < now);
        
        lastPayDay = nextPayDay;
        canPaidAddr.transfer(salary);
        
    }

}
