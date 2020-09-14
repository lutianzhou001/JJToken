const Roles = artifacts.require("Roles");

contract("Roles test", async (accounts) => {
    //预置条件
    let accountAdmin = '0x04E6149570e0d1C9A9377970baA28E45299dc5aA'
    let platformAddress = '0x0Be20453fC613905bB0fb0c13896a57E7De774Ee'
    let stores = [{
        storeName: "JD",
        storeId: "s001",
        storeAddress: "0xfE7B6F0704BcAfc6607a829E1BE36e7FfFfd9465"
    }, {
        storeName: "TB",
        storeId: "t001",
        storeAddress: "0xd8a93bD246Ba06F8aC70933CF5C7cc8F1EC5fb67"

    }];

    let enterprises = [{
        enterpriseName: "Yuanlu",
        enterpriseId: "y001",
        enterpriseAddress: "0xCD63e143AC961078B75F51d42644EC4D150C919c",
    }, {
        enterpriseName: "Ningbo",
        enterpriseId: "n001",
        enterpriseAddress: "0x17e680F9FAe27a26C06b41348668460BF26360bC",
    }]

    let staff = ["0xbEccAa9Ab2c2273980A4216eEfAADF6cd85b1747", "0x5eaB2A4E6f1961BCbF36E371B9e10Eae527AAd4c"]

    it("should set admin to a certain account", async () => {
        let instance = await Roles.deployed();
        await instance.setAdmin(accountAdmin);
        let settledAdminAddress = await instance.adminAddress();
        assert.equal(accountAdmin, settledAdminAddress);
    });

    it("should add a store", async () => {
        // 增加一个商店
        let instance = await Roles.deployed();
        await instance.appendStore(
            stores[0].storeName,
            stores[0].storeId,
            stores[0].storeAddress,
            { from: accountAdmin }
        );
        let store = await instance.stores(0);
        assert.equal(store["0"], stores[0].storeName);
        assert.equal(store["1"], stores[0].storeId);
        assert.equal(store["2"], stores[0].storeAddress);
    });

    it("should add an enterprise", async () => {
        // 增加一个企业
        let instance = await Roles.deployed();
        await instance.appendEnterprise(
            enterprises[0].enterpriseName,
            enterprises[0].enterpriseId,
            enterprises[0].enterpriseAddress,
            { from: accountAdmin }
        );
        let enterprise = await instance.enterprises(0);
        assert.equal(enterprise["0"], enterprises[0].enterpriseName);
        assert.equal(enterprise["1"], enterprises[0].enterpriseId);
        assert.equal(enterprise["2"], enterprises[0].enterpriseAddress);
    });

    it("should get store by id", async () => {
        // 首先增加一个商店
        let instance = await Roles.deployed();
        let wrongAddress = "0x0000000000000000000000000000000000000000";
        // 正确的Id获取正确的商店
        let rightId = await instance.getStoreById(stores[0].storeId);
        assert.equal(stores[0].storeAddress, rightId);
        // 错误的Id获取不到商店
        let wrongId = await instance.getStoreById(stores[0].storeId + "1");
        assert.equal(wrongAddress, wrongId);
    });

    it("should get enterprise by id", async () => {
        let instance = await Roles.deployed();
        let wrongAddress = "0x0000000000000000000000000000000000000000";
        // 正确的Id获取正确的企业
        let rightId = await instance.getEnterpriseById(enterprises[0].enterpriseId);
        assert.equal(enterprises[0].enterpriseAddress, rightId);
        // 错误的Id获取不到企业
        let wrongId = await instance.getEnterpriseById(
            enterprises[0].enterpriseId + "1"
        );
        assert.equal(wrongAddress, wrongId);
    });

    it("should return the count of stores", async () => {
        // 增加一个商店
        let instance = await Roles.deployed();
        await instance.appendStore(
            stores[1].storeName,
            stores[1].storeId,
            stores[1].storeAddress,
            { from: accountAdmin }
        );
        let storesCount1 = await instance.storesCount();
        assert.equal(Number(storesCount1), 2);
    });

    it("should return the count of enterprises", async () => {
        // 增加一个企业
        let instance = await Roles.deployed();
        await instance.appendEnterprise(
            enterprises[1].enterpriseName,
            enterprises[1].enterpriseId,
            enterprises[1].enterpriseAddress,
            { from: accountAdmin }
        );
        let enterprisesCount1 = await instance.enterprisesCount();
        assert.equal(Number(enterprisesCount1), 2);
    });

    it("should update a store", async () => {
        let instance = await Roles.deployed();
        await instance.updateStore(
            stores[0].storeId,
            "u" + stores[0].storeName,
            stores[1].storeAddress,
            { from: accountAdmin }
        );
        let store = await instance.stores(0);
        assert.equal(store["0"], "u" + stores[0].storeName);
        assert.equal(store["1"], stores[0].storeId);
        assert.equal(store["2"], stores[1].storeAddress);
    });

    it("should update a enterprise", async () => {
        let instance = await Roles.deployed();
        await instance.updateEnterprise(
            enterprises[0].enterpriseId,
            "u" + enterprises[0].enterpriseName,
            enterprises[1].enterpriseAddress,
            { from: accountAdmin }
        );
        let enterprise = await instance.enterprises(0);
        assert.equal(enterprise["0"], "u" + enterprises[0].enterpriseName);
        assert.equal(enterprise["1"], enterprises[0].enterpriseId);
        assert.equal(enterprise["2"], enterprises[1].enterpriseAddress);
    });

    it("should delete a store", async () => {
        let instance = await Roles.deployed();
        await instance.deleteStore(stores[0].storeId, { from: accountAdmin });
        // 检查length是否改变
        let storesCount2 = await instance.storesCount();
        assert.equal(Number(storesCount2), 1);
    });

    it("should delete a enterprise", async () => {
        let instance = await Roles.deployed();
        await instance.deleteEnterprise(enterprises[0].enterpriseId, {
            from: accountAdmin,
        });
        // 检查length是否改变
        let enterprisesCount2 = await instance.enterprisesCount();
        assert.equal(Number(enterprisesCount2), 1);
    });
});
