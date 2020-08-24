var JJToken = artifacts.require("JJToken");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(JJToken, "JJToken", "JJT");
};