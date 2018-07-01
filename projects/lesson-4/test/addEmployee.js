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
        });
    });

    // test addEmployee(address employeeId, uint salary)
    it("...should add a new employee by owner.", function() {
        return payroll.addEmployee(employee, salary, {from: owner});
    });

    it("...should only be called by owner.", function() {
        return payroll.addEmployee(employee, salary, {from: guest})
        .then(assert.fail)
        .catch(function(error) {
            assert.include(error.toString(), "Error: VM Exception", "Guest can't call addEmployee!");
        });
    });

    it("...should only add new employee.", function() {
        return payroll.addEmployee(employee, salary, {from: owner})
        .then(function() {
            return payroll.addEmployee(employee, salary, {from: owner});
        }).then(assert.fail)
        .catch(function(error) {
            assert.include(error.toString(), "Error: VM Exception", "A employee can't be added twice.");
        });
    });

    it("...Salary shouldn't be negative number.", function() {
        return payroll.addEmployee(employee, -salary, {from: owner})
        .then(assert.fail)
        .catch(function(error) {
            assert.include(error.toString(), "Error: VM Exception", "Number out of range should be handled!");
        });
    });
});