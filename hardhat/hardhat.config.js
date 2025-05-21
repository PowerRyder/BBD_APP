require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.28",
  settings: {
      optimizer: {
        enabled: true,
        runs: 10,
      },
    },
  networks: {
    testnet: {
      url: process.env.RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      // allowUnlimitedContractSize: true
    },
    hardhat: {
      // allowUnlimitedContractSize: true
    }
  }
};
