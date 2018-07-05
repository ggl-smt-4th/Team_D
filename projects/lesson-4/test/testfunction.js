var PayRoll = artifacts.require("Payroll");



contract('Payroll', function(accounts) {

    let payroll; // instance of the deployed PayRoll contract

    const owner = accounts[0];
  	const employee1 = accounts[1];
  	const guest = accounts[2];
  	const employee2 = accounts[3];
  	const salary = 1;
    const runway = 20;
    const payDuration = (30 + 1) * 86400;
    const fundToAdd = runway * salary;

    it("Owner add an employee", function() {    
        return PayRoll.new()
        .then(function(instance) {
            payroll = instance;
            payroll.addFund({from:owner, value: web3.toWei(fundToAdd, 'ether')});
            return payroll.addEmployee(employee1, salary, {from: owner});
        }).then(() => {
            return payroll.employees.call(employee1);
        }).then(info => {
            assert.equal( web3.fromWei(info[0].toNumber(), 'ether'), salary, "Salary for employee is not right");
            assert.equal(info[1].toNumber(), web3.eth.getBlock(web3.eth.blockNumber).timestamp, "lastPayDay is the current block time!");
        }).then(() => {
            return payroll.totalSalary.call();
        }).then(info => {
            assert.equal(web3.fromWei(info.toNumber(), 'ether'),salary,'the salary value is not right');
        });
    });

    it("Owner add an existing employee", function() {
        return payroll.addEmployee(employee1, salary, {from: owner})
        .then(() => {
     		 assert(false, "Should not be successful");
    	}).catch(function(err) {
            assert.include(err.toString(), "Error: VM Exception", "can't add existing employee");
        });
    });


    it("Other people add an employee", function() {

        return payroll.addEmployee(guest, salary, {from: employee2})
        .then(() => {
     		 assert(false, "Should not be successful");
    	}).catch(
            err => {
                assert.include(err.toString(), "Error: VM Exception", "other can't add employee");
            });
    });



    it("Other remove an employee", function() {

        return payroll.removeEmployee(employee1, {from: guest})
        .then(() => {
             assert(false, "Should not be successful");
        }).catch(
            err => {
            assert.include(err.toString(), "Error: VM Exception", "other can't remove employee");
        });
    });


    it("Owner remove a non existing employee:", function() {
        return payroll.removeEmployee(employee2, {from: owner})
        .then(() => {
             assert(false, "Should not be successful");
        }).catch(
        err => {
            assert.include(err.toString(), "Error: VM Exception", "can't remove non existing employee");
        });

    });

    it("Owner can remove an existing employee:", function() {
        return payroll.removeEmployee(employee1, {from: owner})
        .then(function() {
            return payroll.employees.call(employee1);
        }).then(
        info => {
            assert.equal(info[0].toNumber(), 0, "Salary is not cleaned.");
            assert.equal(info[1].toNumber(), 0, "lastPayDay is not cleaned");
        });

    });

    it("Test getPaid before duration", function () {
        return payroll.addEmployee(employee1, salary, {from: owner}).then(() => {
        return payroll.getPaid({from: employee1})
        }).then(
        () => {
            assert(false, "Should not be successful");
        }).catch(
        error => {
            assert.include(error.toString(), "Error: VM Exception", "Cannot getPaid before a pay duration");
        });
    });

    it("Test getPaid", function () {
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
        return payroll.calculateRunway().then( instance =>{
        var currunway = instance;
        return payroll.getPaid({from: employee1}).then(
            () => {
            return payroll.calculateRunway();
        }).then(
            info => {
                assert.equal(info.toNumber(), currunway - 1, "The runway is not correct");
            });
        });
    });

    it("get Paid by a guest", function () {    
      return payroll.getPaid({from: guest}).then(
        () => {
            assert(false, "Should not be successful");
        }).catch(
        err => {
            assert.include(err.toString(), "Error: VM Exception", "The guest cannot get paid");
        });
    });
});
