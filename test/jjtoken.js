const JJToken = artifacts.require("JJtoken")
var web3 =  require("web3");

contract("JJToken test", async accounts => {
    //预置条件
    let accountAdmin = '0x13cd7377D9749B22764EfdC3fC98A4a3DD0F3C77'
    let amount = web3.utils.toBN(1000);
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

    it("should mint for enterprises", async () => {
        let instance = await JJToken.deployed();
        // 开始发行
        await instance.jjMint(enterprises[0].enterpriseAddress ,amount)
        // 检查发行结果
        let result = await instance.getBalance({from: enterprises[0].enterpriseAddress});
        assert.equal(Number(result),Number(amount));
    });
});
