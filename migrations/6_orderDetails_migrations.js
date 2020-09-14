var OrderDetails = artifacts.require("OrderDetails");

module.exports = function (deployer) {
    // deployment steps
    deployer.deploy(OrderDetails);
};