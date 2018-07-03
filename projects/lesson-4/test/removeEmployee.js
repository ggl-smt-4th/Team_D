var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

    /**
     * 思考如何能覆盖所有的测试路径，包括
     *   各函数调用者权限
     *   重复调用    
     *   异常捕捉
     */
    const owner = accounts[0];
    const employee = accounts[1];
    const guest = accounts[2];
    const salary = 2;

    let payroll;

    beforeEach("Setup contract for each test cases", function() {
        return Payroll.new().then(function(instance) {
          payroll = instance;
          return payroll.addEmployee(employee, salary, {from: owner});
        });
    });

    // test removeEmployee(address employeeId)
    it("...should remove a employee by owner.", function() {
        return payroll.removeEmployee(employee, {from: owner});
    });
    
    it("...should only be called by owner.", function() {
        return payroll.removeEmployee(employee, {from: guest})
        .then(assert.fail)
        .catch(function(error) {
            assert.include(error.toString(), "Error: VM Exception", "Guest can't call removeEmployee()");
        });
    });

    it("...should only remove existed employee.", function() {
        return payroll.removeEmployee(guest, {from: owner})
        .then(assert.fail)
        .catch(function(error) {
            assert.include(error.toString(), "Error: VM Exception", "Unexisted employee can't be removed!");
        });
    });
});