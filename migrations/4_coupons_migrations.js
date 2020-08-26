var Coupons = artifacts.require("Coupons");

module.exports = function (deployer) {
    // deployment steps
    deployer.deploy(Coupons, "MGJ100T", "MGT", "C001", ["s001", "s002"], 1001, 1002);
};