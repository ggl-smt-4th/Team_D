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
    const fund = 20;
    const payDuration = (30 + 1) * 86400;

    let payroll;

    beforeEach("Setup contract for each test cases", function() {
        return Payroll.new().then(function(instance) {
          payroll = instance;
          return payroll.addEmployee(employee, salary, {from: owner})
          .then(function() {
              return payroll.addFund({from: owner, value: web3.toWei(fund, 'ether')});
          });
        });
    });

    // test getPaid()    
    /** `getPaid()` 函数需要在一定时间之后调用才可领薪酬，
     * 思考如何对 timestamp 进行修改，
     * 是否需要对所测试的合约进行修改来达到测试的目的？
     */     
    it("...should be payed after duration.", function() {
        return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0})
        .then(function() {
            return payroll.getPaid({from: employee});
        });
    });
    
    it("...should only be called by existed employee.", function() {
        return payroll.getPaid({from: guest})
        .then(assert.fail)
        .catch(function(error) {
            assert.include(error.toString(), "Error: VM Exception", "Unexisted employee can't call getPaid()!");
        });
    });

    it("...shouldn't be payed before duration", function() {
        return payroll.getPaid({from: employee})
        .then(assert.fail)
        .catch(function(error) {
            assert.include(error.toString(), "Error: VM Exception", "Can't get paid before duration!");
        });
    });
});