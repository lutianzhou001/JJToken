var Orders = artifacts.require("Orders");

module.exports = function (deployer) {
    // deployment steps
    deployer.deploy(Orders);
};