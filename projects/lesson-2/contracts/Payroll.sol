pragma solidity ^0.4.14;

contract Payroll{
    struct Employee{
        address id;
        uint salary;
        uint lastPayDay;
    }

    address owner;
    uint payDuration = 10 seconds;
    Employee[] employees;

    uint totalSalary;

    function Payroll() public{

        owner = msg.sender;

    }

    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayDay)/payDuration;
        employee.id.transfer(payment);
    }
    function _findEmployee(address employeeId) private view returns (Employee,uint){
        for(uint i=0;i<employees.length;i++){
            if(employees[i].id==employeeId){
                return (employees[i],i);
            }
        }
    }
    function addEmployee(address employeeId ,uint salary) public{
        require(msg.sender==owner);
        var (employee, ) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint userSalary = salary * 1 ether;
        employees.push(Employee(employeeId,userSalary,now));
        totalSalary+=userSalary;

    }
    function removeEmployee(address employeeId) public{
        require(msg.sender==owner);

        assert(employees.length>0);

        var (employee, index) = _findEmployee(employeeId);

        assert(employee.id != 0x0);

        _partialPaid(employee);
        delete employees[index];
        if(employees.length>1){
            employees[index]=employees[employees.length-1];
        }

        employees.length-=1;
        totalSalary-=employee.salary;
    }
    function updateEmployee(address employeeId,uint salary) public{
        require(msg.sender==owner && employees.length>0);

        // assert(employees.length>0);

        var (employee, index) = _findEmployee(employeeId);

        assert(employee.id!= 0x0 && employee.salary != salary);

        _partialPaid(employee);
        totalSalary -= (employee.salary-salary);
        employees[index].salary = salary;
        employees[index].lastPayDay=now;
    }

    function addFund() payable public returns (uint) {

        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        require(msg.sender==owner);

        return  this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        require(msg.sender==owner);
        return calculateRunway()>0;
    }

    function getPaid() payable external{
        var (employee, ) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayDay = employee.lastPayDay + payDuration;

        assert(nextPayDay < now);

        employee.lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);

    }

}
