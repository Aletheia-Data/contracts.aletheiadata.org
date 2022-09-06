require("dotenv").config()
require("@nomicfoundation/hardhat-toolbox");

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_PRIVATE_KEY = process.env.ETHERSCAN_PRIVATE_KEY;

const NETWORK_ENDPOINT = process.env.NETWORK_ENDPOINT;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    mumbai: {
      url: `${NETWORK_ENDPOINT}/${ALCHEMY_API_KEY}`,
      accounts: [PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: ETHERSCAN_PRIVATE_KEY
    }
  }
};
