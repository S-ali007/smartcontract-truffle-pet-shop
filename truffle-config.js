const HDWalletProvider = require("@truffle/hdwallet-provider")

const mnemonic ="seminar first gloom business urban credit cave mouse giraffe focus speak stay";
const infuraId="51b04b4da06f4fa5bdc6d61c111b0123";
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    develop: {
      port: 8545
    },
    sepolia: {
      provider: () => new HDWalletProvider(mnemonic, `https://sepolia.infura.io/v3/51b04b4da06f4fa5bdc6d61c111b0123`),
      network_id: 11155111,
      chain_id: 5,
      gas: 2000000, 
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },
  compilers:{
    solc:{
      version: "0.8.19"
    }
  }
};
