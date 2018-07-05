pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {

  function testItAddsAEmployee() public {
    Payroll payroll = Payroll(DeployedAddresses.Payroll());

    payroll.set('zyoa98sdhfasausdfh2928393uhfasjdfasd', 1);

    uint expected = 89;

    Assert.equal(simpleStorage.get(), expected, "It should store the value 89.");
  }

}
