const Payroll = artifacts.require('./Payroll.sol');
require('chai').use(require('chai-as-promised')).should();

const revertError = 'VM Exception while processing transaction: revert';
const invalidOpCodeError = 'VM Exception while processing transaction: invalid opcode';

assert.almostEqual = (n1, n2) => {
  const diff = Math.abs(n1 - n2);
  assert.ok(diff / n1 < 1e-5);
};

// Utility helper functions.
async function addDaysOnEVM(days) {
  const seconds = days * 3600 * 24;
  await web3.currentProvider.send({
    jsonrpc: '2.0', method: 'evm_increaseTime', params: [seconds], id: 0,
  });
  await web3.currentProvider.send({
    jsonrpc: '2.0', method: 'evm_mine', params: [], id: 0,
  });
}

async function snapshotEVM() {
  await web3.currentProvider.send({
    jsonrpc: '2.0', method: 'evm_snapshot', params: [], id: 0,
  });
}

async function revertEVM() {
  await web3.currentProvider.send({
    jsonrpc: '2.0', method: 'evm_revert', params: [], id: 0,
  });
}

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  // Added before test.
  const firstEmployee = accounts[1];
  const employee = accounts[2];
  const guest = accounts[5];
  const salary = 1;

  let payroll;

  beforeEach('Setup contract for each test cases', async () => {
    await snapshotEVM();
    payroll = await Payroll.new.call(owner, { value: web3.toWei(2, 'ether') });
    await payroll.addEmployee(firstEmployee, salary, { from: owner });
  });

  afterEach(async () => {
    await revertEVM();
  });

  it('Test call addEmployee() by owner', async () => {
    await payroll.addEmployee(employee, salary, { from: owner });
  });

  it('Test call addEmployee() by with existing employee', async () => {
    await payroll.addEmployee(firstEmployee, salary, { from: owner })
      .should.be.rejectedWith(revertError);
  });

  it('Test call addEmployee() with negative salary', async () => {
    await payroll.addEmployee(employee, -salary, { from: owner })
      .should.be.rejectedWith(invalidOpCodeError);
  });

  it('Test call addEmployee() with salary overflow', async () => {
    const hugeSalary = 2 ** 255;
    await payroll.addEmployee(employee, hugeSalary, { from: owner })
      .should.be.rejectedWith(invalidOpCodeError);
  });

  it('Test addEmployee() by guest', async () => {
    await payroll.addEmployee(employee, salary, { from: guest })
      .should.be.rejectedWith(revertError);
  });

  it('Test call removeEmployee() by owner - employee should be paid', async () => {
    const originalBalance = await web3.eth.getBalance(firstEmployee);
    await addDaysOnEVM(15);
    await payroll.removeEmployee(firstEmployee, { from: owner });
    const newBalance = await web3.eth.getBalance(firstEmployee);
    const paidSalary = newBalance.sub(originalBalance).toNumber();
    // Should be partially paid.
    assert.almostEqual(web3.toWei(0.5, 'ether'), paidSalary);
    // Contract should have less ether.
    assert.almostEqual(web3.toWei(1.5, 'ether'), await web3.eth.getBalance(payroll.address));
  });

  it('Test call removeEmployee() - employee does not exist', async () => {
    await payroll.removeEmployee(employee, { from: owner })
      .should.be.rejectedWith(revertError);
  });

  it('Test call removeEmployee() by guest', async () => {
    await payroll.removeEmployee(firstEmployee, { from: guest })
      .should.be.rejectedWith(revertError);
  });

  it('Test call getPaid() by non-employee', async () => {
    await payroll.getPaid({ from: guest })
      .should.be.rejectedWith(revertError);
  });

  it('Test call getPaid() before and after pay day', async () => {
    const originalBalance = await web3.eth.getBalance(firstEmployee);
    await addDaysOnEVM(15);
    await payroll.getPaid({ from: firstEmployee })
      .should.be.rejectedWith(invalidOpCodeError);
    // In total 31 days later, after the first pay day.
    await addDaysOnEVM(16);
    await payroll.getPaid({ from: firstEmployee });
    const newBalance = await web3.eth.getBalance(firstEmployee);
    // Employee should have more balance.
    assert.ok(newBalance.toNumber() > originalBalance.toNumber());
    // Contract should have less ether.
    assert.almostEqual(web3.toWei(1, 'ether'), await web3.eth.getBalance(payroll.address));
    // Ask for payment again, should fail.
    await payroll.getPaid({ from: firstEmployee })
      .should.be.rejectedWith(invalidOpCodeError);
  });
});
