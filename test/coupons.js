const Coupons = artifacts.require("Coupons");
const JJToken = artifacts.require("JJToken");
const CONTRACT_ADDRESS_JJTOKEN = "0xC06e0C9cA7f2e3511fcc5A2185Cbc3199F1C56BC";

var web3 = require("web3");

contract("Coupons test", async accounts => {
    //预置条件
    let storePercentage = 90;
    let accountAdmin = '0x13cd7377D9749B22764EfdC3fC98A4a3DD0F3C77'
    let platformAddress = '0x7b76Ff81b118c6B4C0E4b99250d3Bc5FE4AD899c'
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

    let staff = ["0xbA7384cC7BbA2b6915Af467c70a6a918Fd301000", "0x9E46CeCA15e4ecBfc33f4A8c6656DDCb29a0eC08"]

    let amount = web3.utils.toBN(1000000);
    let mintAmount = web3.utils.toBN(100000);
    let batchMintAmount = web3.utils.toBN(200000);

    let transferAmount = web3.utils.toBN(30000);
    let refundAmount = web3.utils.toBN(20000);
    let withdrawAmount = web3.utils.toBN(9000);
    let orderId = 'orderId001'
    let orderDetailId = ['orderDetailId001', 'orderDetailId002']
    let orderContent = 'name: vincent, address: jiangsusuzhou, store: suningyigou'
    let orderDetailContent = ['goodsName:aa,price:100', 'goodName:bbb,price:200']

    // 首先要设置admin地址
    // 其次要设置enterprise地址和fee地址
    // 这些已经在合约
    // address constant RolesAddress = 0xa8659791eF77BE09e373b27a659257fb9D2E5C66;
    // 中预先配置好了。
    // 开始销毁之前发行的所有Token，准备环境
    it("shoud burn all the JJToken at first", async () => {
        let instanceJJ = await JJToken.at(CONTRACT_ADDRESS_JJTOKEN)
        let res1 = await instanceJJ.jjBalance(enterprises[0].enterpriseAddress);
        let res2 = await instanceJJ.jjBalance(enterprises[1].enterpriseAddress);
        await instanceJJ.jjBurn(enterprises[0].enterpriseAddress, res1);
        await instanceJJ.jjBurn(enterprises[1].enterpriseAddress, res2);
        let resAfter1 = await instanceJJ.jjBalance(enterprises[0].enterpriseAddress);
        let resAfter2 = await instanceJJ.jjBalance(enterprises[1].enterpriseAddress);
        assert.equal(Number(resAfter1), Number(0));
        assert.equal(Number(resAfter2), Number(0));
    })

    it("should issue for enterprise", async () => {
        let instance = await Coupons.deployed();
        // 开始发行
        await instance.issue(enterprises[0].enterpriseAddress, amount, { from: accountAdmin })
        // 找到JJToken的balance（稳定币的balance）
        let result = await instance.getJJTokenBalance(enterprises[0].enterpriseAddress);
        assert.equal(Number(result), Number(amount));
    });

    it("should mint for staff", async () => {
        let instance = await Coupons.deployed();
        let instanceJJ = await JJToken.at(CONTRACT_ADDRESS_JJTOKEN)
        await instanceJJ.jjApproveTo(instance.address, mintAmount, { from: enterprises[0].enterpriseAddress });
        // 开始mint
        await instance.mint(staff[0], mintAmount, { from: enterprises[0].enterpriseAddress });
        // 找到消费充值卷的balance（代币balance）
        let result = await instance.getBalance(staff[0]);
        assert.equal(Number(result), Number(mintAmount));
    })

    it("should set percentage of stores", async () => {
        let instance = await Coupons.deployed();
        // 设置percetage
        await instance.setStorePercentage(storePercentage, { from: accountAdmin });
        let result = await instance.storePercentage()
        assert.equal(result, storePercentage)
    })

    it("should batchMint for all the staff", async () => {
        let instance = await Coupons.deployed();
        let instanceJJ = await JJToken.at(CONTRACT_ADDRESS_JJTOKEN)
        await instanceJJ.jjApproveTo(instance.address, batchMintAmount, { from: enterprises[0].enterpriseAddress });
        // 开始mint
        await instance.batchMint(staff, mintAmount, { from: enterprises[0].enterpriseAddress });
        let result1 = await instance.getBalance(staff[0]);
        let result2 = await instance.getBalance(staff[1]);
        assert.equal(Number(result1), Number(mintAmount) + Number(mintAmount));
        assert.equal(Number(result2), Number(mintAmount));
    })

    it("should transfer from one account to another", async () => {
        let instance = await Coupons.deployed();
        // 原来staff[0]的余额和原来商家的余额；
        let staffBefore = await instance.getBalance(staff[1]);
        let storeBefore = await instance.getBalance(stores[1].storeAddress);
        await instance.couponTransfer(stores[0].storeAddress, transferAmount, orderId, orderDetailId, orderContent, orderDetailContent, { from: staff[1] });
        // 转账好了开始验证
        let staffAfter = await instance.getBalance(staff[1]);
        let storeAfter = await instance.getBalance(stores[0].storeAddress);
        assert.equal(Number(staffBefore) - Number(transferAmount), Number(staffAfter));
        assert.equal(Number(storeBefore) + Number(transferAmount), Number(storeAfter));
    })

    it("should refund to user", async () => {
        let instance = await Coupons.deployed();
        // 原来staff[0]的余额和原来商家的余额；
        let staffBefore = await instance.getBalance(staff[1]);
        let storeBefore = await instance.getBalance(stores[0].storeAddress);
        await instance.couponRefund(staff[1], refundAmount, orderId, orderDetailId, orderContent, orderDetailContent, { from: stores[0].storeAddress });
        // 转账好了开始验证
        let staffAfter = await instance.getBalance(staff[1]);
        let storeAfter = await instance.getBalance(stores[0].storeAddress);
        assert.equal(Number(staffBefore) + Number(refundAmount), Number(staffAfter));
        assert.equal(Number(storeBefore) - Number(refundAmount), Number(storeAfter));
    })

    it("should withdraw tokens", async () => {
        let instance = await Coupons.deployed();
        let instanceJJ = await JJToken.at(CONTRACT_ADDRESS_JJTOKEN);
        let storeJJBefore = await instanceJJ.jjBalance(stores[0].storeAddress);
        let instanceJJBefore = await instanceJJ.jjBalance(instance.address);
        let platformJJBefore = await instanceJJ.jjBalance(platformAddress);
        let storeBefore = await instance.getBalance(stores[0].storeAddress);
        await instance.withdraw(withdrawAmount, { from: stores[0].storeAddress });
        let storeAfter = await instance.getBalance(stores[0].storeAddress);
        // 首先检查是否销毁
        assert.equal(Number(storeBefore) - Number(withdrawAmount), Number(storeAfter));
        // 其次检查是否到账
        let storeJJAfter = await instanceJJ.jjBalance(stores[0].storeAddress);
        let instanceJJAfter = await instanceJJ.jjBalance(instance.address);
        let platformJJAfter = await instanceJJ.jjBalance(platformAddress);

        assert.equal(Number(storeJJAfter), Number(storeJJBefore) + Number(withdrawAmount) * storePercentage / 100);
        assert.equal(Number(platformJJAfter), Number(platformJJBefore) + Number(withdrawAmount) * (100 - storePercentage) / 100)
        assert.equal(Number(instanceJJAfter), Number(instanceJJBefore) - Number(withdrawAmount))

    })

    it("should burn all token for users", async () => {
        let instance = await Coupons.deployed();
        let res1 = await instance.getBalance(staff[0]);
        let res2 = await instance.getBalance(staff[1]);
        // 销毁账户的所有Token
        await instance.burn(staff[0], res1, { from: accountAdmin });
        await instance.burn(staff[1], res2, { from: accountAdmin });
        let resAfter1 = await instance.getBalance(staff[0]);
        let resAfter2 = await instance.getBalance(staff[1]);
        assert.equal(Number(resAfter1), Number(0));
        assert.equal(Number(resAfter2), Number(0));
        // TODO: 平台账户还未销毁
    })


    // 最后删除所有enterprise地址
});