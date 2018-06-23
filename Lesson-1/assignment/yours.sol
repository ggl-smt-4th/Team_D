/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract PayRoll{
    uint salary;
    //main account
    address mainAddr;
    
    address canPaidAddr;
    uint payDurtion = 10 seconds;
    uint lastPayDay = now;
    function PayRoll(){
        mainAddr = msg.sender;
    }
    function updateEmpoyee(address userAddr,uint money) returns (bool){
        require(msg.sender==mainAddr);
        
        if(userAddr != 0x0){
            uint payment = salary* ((now - lastPayDay)/payDurtion);
            
            canPaidAddr.transfer(payment);
        }
        
        //bool needRevert = false;
        if(canPaidAddr!=userAddr){
            canPaidAddr=userAddr;
        }
        if(salary!=money){
            salary = money * 1 ether;
        }
        lastPayDay=now;
        return true;
    }
    function changeAddr(address userAddr) returns (bool){
            require(msg.sender==mainAddr);
            

            if(canPaidAddr==userAddr){
                 revert();
            }
            
            canPaidAddr=userAddr;
            
            return true;
    }    
    function changeMoney(address userAddr,uint money) returns (bool){
            require(msg.sender==mainAddr);
            // bool needRevert = false;
            if(userAddr!=canPaidAddr){
                revert();
            }
            if(salary==money){
                revert();
            }
            
            salary = money;
            
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
        
        require(nextPayDay < now);
        lastPayDay = nextPayDay;
        canPaidAddr.transfer(salary);
        
    }
    
    function querySelfMoney() payable returns (uint){
        
        require(msg.sender==canPaidAddr);
        return canPaidAddr.balance;
    }
}
