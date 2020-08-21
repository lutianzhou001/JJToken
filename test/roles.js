const Roles = artifacts.require("Roles");

contract("Roles test", async accounts => {

    let accountAdmin = '0x13cd7377D9749B22764EfdC3fC98A4a3DD0F3C77'

    it("should set admin to a certain account", async () => {
        let instance = await Roles.deployed();
        let admin = await instance.setAdmin(accountAdmin);
        let settledAdminAddress = await instance.adminAddress()
        assert.equal(accountAdmin, settledAdminAddress);
    });
});
