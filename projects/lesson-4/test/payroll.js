var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(addEmployee) {

	it("...should addEmployee..", function() {
		return Payroll.deployed().then(function(instance) {
			PayrollInstance = instance;
			address addressId;
			uint salary;
			return PayrollInstance.addEmployee(addressId, salary);
		}).then(function() {
			address addressId;
			return PayrollInstance.removeEmployee.call(addressId);
		}).then(function() {
			PayrollInstance.getPaid();
			assert.equal(employess[addressId].salary, 0, "the Employee add remove successfully.");
		});
	});
});
