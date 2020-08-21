var Roles = artifacts.require("Roles");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(Roles);
};
