var Migrations = artifacts.require("./StudentRegistry.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
