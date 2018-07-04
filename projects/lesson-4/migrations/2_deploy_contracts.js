/**
 * @Author: zhicai
 * @Date:   2018-06-30T09:31:40+08:00
 * @Last modified by:   zhicai
 * @Last modified time: 2018-07-01T00:30:23+08:00
 */

var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function (deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);

  deployer.link(Ownable, Payroll);
  deployer.link(SafeMath, Payroll);
  deployer.deploy(Payroll);
};
