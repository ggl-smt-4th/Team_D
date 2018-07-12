var HDWalletProvider = require("truffle-hdwallet-provider");

var infuraAPI = process.env.INFURA_API;
var mnemonic = process.env.MNEMONIC;

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/" + infuraAPI),
      network_id: 3,
      gas: 2500000,
      gasPrice: 100000000000,
    }
  }
};
