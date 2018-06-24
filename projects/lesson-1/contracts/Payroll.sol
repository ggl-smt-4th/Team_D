pragma solidity ^0.4.14;


contract Payroll {
    // 1 month.
    uint constant PAY_DURATION = 30 days;

    address public owner;

    uint salary = 1 ether;
    address employee;
    uint lastPayday;

    function Payroll() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    function update(address _employee, uint _salaryInEther) private onlyOwner {
        // Sending remaining salary to the previous employee.
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / PAY_DURATION;
            employee.transfer(payment);
        }

        employee = _employee;
        salary = _salaryInEther * 1 ether;
        lastPayday = now;
    }

    /// @dev Update salary for the same employee.
    function updateEmployeeSalary(uint _salaryInEther) public onlyOwner {
        // No-op if no change.
        if (_salaryInEther * 1 ether == salary) {
            return;
        }
        update(employee, _salaryInEther);
    }

    /// @dev Only update the address, not changing employee.
    function updateEmployeeAddress(address _employee) public onlyOwner {
        require(_employee != 0x0);
        // No-op if same employee.
        if (_employee == employee) {
            return;
        }
        update(_employee, salary / 1 ether);
    }

    function addFund() public payable returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance / salary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        require(msg.sender == employee);

        uint nextPayday = lastPayday + PAY_DURATION;
        require(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }

}
