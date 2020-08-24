const Roles = artifacts.require("Roles");

contract("Roles test", async accounts => {
    //预置条件
    let accountAdmin = '0x13cd7377D9749B22764EfdC3fC98A4a3DD0F3C77'
    let stores = [{
        storeName: "JD",
        storeId: "s001",
        storeAddress: "0x8257700fA1015B35C947444D7EA78143248e7A97"
    }, {
        storeName: "TB",
        storeId: "t001",
        storeAddress: "0x4e1ad8C78604219E59679e6a52Bc6b68131DFB7e"

    }];

    let enterprises = [{
        enterpriseName: "Yuanlu",
        enterpriseId: "y001",
        enterpriseAddress: "0xD433b45D13a1c00947a4fbef7155BbeF48862D86",
    }, {
        enterpriseName: "Ningbo",
        enterpriseId: "n001",
        enterpriseAddress: "0x94BEFeFF67b36281331B6D4bBf5F57C8D8cA8226",
    }]

    it("should set admin to a certain account", async () => {
        let instance = await Roles.deployed();
        await instance.setAdmin(accountAdmin);
        let settledAdminAddress = await instance.adminAddress()
        assert.equal(accountAdmin, settledAdminAddress);
    });

    it("should add a store", async () => {
        // 增加一个商店
        let instance = await Roles.deployed();
        await instance.appendStore(stores[0].storeName, stores[0].storeId, stores[0].storeAddress, { from: accountAdmin });
        let store = await instance.stores(0)
        assert.equal(store['0'], stores[0].storeName);
        assert.equal(store['1'], stores[0].storeId);
        assert.equal(store['2'], stores[0].storeAddress);
    })

    it("should add an enterprise", async () => {
        // 增加一个企业
        let instance = await Roles.deployed();
        await instance.appendEnterprise(enterprises[0].enterpriseName, enterprises[0].enterpriseId, enterprises[0].enterpriseAddress, { from: accountAdmin });
        let enterprise = await instance.enterprises(0)
        assert.equal(enterprise['0'], enterprises[0].enterpriseName);
        assert.equal(enterprise['1'], enterprises[0].enterpriseId);
        assert.equal(enterprise['2'], enterprises[0].enterpriseAddress);
    })

    it("should get store by id", async () => {
        // 首先增加一个商店
        let instance = await Roles.deployed();
        let wrongAddress = '0x0000000000000000000000000000000000000000'
        // 正确的Id获取正确的商店
        let rightId = await instance.getStoreById(stores[0].storeId);
        assert.equal(stores[0].storeAddress, rightId)
        // 错误的Id获取不到商店
        let wrongId = await instance.getStoreById(stores[0].storeId + "1")
        assert.equal(wrongAddress, wrongId)
    })


    it("should get enterprise by id", async () => {
        let instance = await Roles.deployed();
        let wrongAddress = '0x0000000000000000000000000000000000000000'
        // 正确的Id获取正确的企业
        let rightId = await instance.getEnterpriseById(enterprises[0].enterpriseId);
        assert.equal(enterprises[0].enterpriseAddress, rightId)
        // 错误的Id获取不到企业
        let wrongId = await instance.getEnterpriseById(enterprises[0].enterpriseId + "1")
        assert.equal(wrongAddress, wrongId)
    })


    it("should return the count of stores", async () => {
        // 增加一个商店
        let instance = await Roles.deployed();
        await instance.appendStore(stores[1].storeName, stores[1].storeId, stores[1].storeAddress, { from: accountAdmin });
        let storesCount1 = await instance.storesCount()
        assert.equal(Number(storesCount1), 2)
    })

    it("should return the count of enterprises", async () => {
        // 增加一个企业
        let instance = await Roles.deployed();
        await instance.appendEnterprise(enterprises[1].enterpriseName, enterprises[1].enterpriseId, enterprises[1].enterpriseAddress, { from: accountAdmin });
        let enterprisesCount1 = await instance.enterprisesCount()
        assert.equal(Number(enterprisesCount1), 2)
    })


    it("should update a store", async () => {
        let instance = await Roles.deployed();
        await instance.updateStore(stores[0].storeId, "u" + stores[0].storeName, stores[1].storeAddress, { from: accountAdmin });
        let store = await instance.stores(0)
        assert.equal(store['0'], "u" + stores[0].storeName);
        assert.equal(store['1'], stores[0].storeId);
        assert.equal(store['2'], stores[1].storeAddress);
    })

    it("should update a enterprise", async () => {
        let instance = await Roles.deployed();
        await instance.updateEnterprise(enterprises[0].enterpriseId, "u" + enterprises[0].enterpriseName, enterprises[1].enterpriseAddress, { from: accountAdmin });
        let enterprise = await instance.enterprises(0)
        assert.equal(enterprise['0'], "u" + enterprises[0].enterpriseName);
        assert.equal(enterprise['1'], enterprises[0].enterpriseId);
        assert.equal(enterprise['2'], enterprises[1].enterpriseAddress);
    })

    it("should delete a store", async () => {
        let instance = await Roles.deployed();
        await instance.deleteStore(stores[0].storeId, { from: accountAdmin });
        // 检查length是否改变
        let storesCount2 = await instance.storesCount()
        assert.equal(Number(storesCount2), 1)
    })

    it("should delete a enterprise", async () => {
        let instance = await Roles.deployed();
        await instance.deleteEnterprise(enterprises[0].enterpriseId, { from: accountAdmin });
        // 检查length是否改变
        let enterprisesCount2 = await instance.enterprisesCount()
        assert.equal(Number(enterprisesCount2), 1)
    })
});
