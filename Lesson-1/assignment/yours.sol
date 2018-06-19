/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract PayRoll{
    uint salary;
    //main account
    address mainAddr = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
    
    address canPaidAddr;
    uint payDurtion = 10 seconds;
    uint lastPayDay = now;
    function PayRoll(){
        
    }
    function changeAddrAndMoney(address userAddr,uint money) returns (bool){
            if(msg.sender!=mainAddr){
                revert();
            }
            //bool needRevert = false;
            if(canPaidAddr!=userAddr){
                canPaidAddr=userAddr;
                
            }
            if(salary!=money){
                salary = money;
            }
            
            return true;
    }
     //修改员工地址
    function changeAddr(address userAddr) returns (bool){
            if(msg.sender!=mainAddr){
                revert();
            }
            
            //内部比较有消耗吗？
            if(canPaidAddr==userAddr){
                 revert();
            }
            
            canPaidAddr=userAddr;
            
            return true;
    }    
    //修改员工金额
    function changeMoney(address userAddr,uint money) returns (bool){
            if(msg.sender!=mainAddr){
                revert();
            }
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
        if(msg.sender!=mainAddr){
            revert();
        }
        return this.balance;
    }
    
    function calculteRunway() returns (uint){
        if(msg.sender!=mainAddr){
            revert();
        }
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        if(msg.sender!=mainAddr){
            revert();
        }
        return calculteRunway()>0;
    }
    
    function getPaid(){
        
        if(salary<=0 || msg.sender != canPaidAddr){
            revert();
        }
        uint nextPayDay = lastPayDay + payDurtion;
        if(nextPayDay > now){
            revert();
        }
        
        lastPayDay = nextPayDay;
        canPaidAddr.transfer(salary);
        
    }
    
    function querySelfMoney() payable returns (uint){
        if(msg.sender!=canPaidAddr){
            revert();
        }
        
        return canPaidAddr.balance;
    }
}
