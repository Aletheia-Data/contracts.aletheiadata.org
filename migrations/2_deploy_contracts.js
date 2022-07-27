const ConvertLib = artifacts.require("ConvertLib");
const PDNFT = artifacts.require("PDNFT");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, PDNFT);
  deployer.deploy(PDNFT);
};
