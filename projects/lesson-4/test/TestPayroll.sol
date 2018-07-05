pragma solidity ^0.4.14;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Poyroll.sol";

contract TestPayroll {
	function testAddEmployee(address addressId, uint salary) {
		Payroll payroll = Payroll(DeployAddresses.Payroll);

		addEmployee(addressId, salary);

		Assert.equal(employees[addressId].salary, salary, "Add the employee done.");
	}

	function testRemoveEmployee(address addressId) {
		Payroll payroll = Payroll(DeployAddresses.Payroll);

		removeEmployee(addressId);

		Assert.equal(employees[addressId].lastPayDay, 0, "Remove the employee done.");
	}

	function testGetPaid() {
		
	}
}
