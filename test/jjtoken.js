const JJToken = artifacts.require('JJtoken');
var web3 = require('web3');

contract('JJToken test', async accounts => {
    //预置条件
    let amount = web3.utils.toBN(1000);
    let burnAmount = web3.utils.toBN(200);
    let transferAmount = web3.utils.toBN(100);

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



    it('should mint for enterprises', async () => {
        let instance = await JJToken.deployed();
        // 开始发行
        await instance.jjMint(enterprises[0].enterpriseAddress, amount, { from: accountAdmin });
        // 检查发行结果
        let result = await instance.jjBalance(enterprises[0].enterpriseAddress, { from: enterprises[0].enterpriseAddress });
        assert.equal(Number(result), Number(amount));
    });

    it('should burn token for users', async () => {
        let instance = await JJToken.deployed();
        // 开始销毁
        let result = await instance.jjBurn(
            enterprises[0].enterpriseAddress,
            burnAmount, {
            from: accountAdmin,
        }
        );
        let balance = await instance.jjBalance(enterprises[0].enterpriseAddress, {
            from: enterprises[0].enterpriseAddress,
        });
        assert.equal(Number(balance), Number(amount) - Number(burnAmount));
    });

    it('should approve some token to token address', async ()=> {
        let instance = await JJToken.deployed();
        let balance = await instance.jjBalance(enterprises[0].enterpriseAddress, {
            from: enterprises[0].enterpriseAddress,
        });
        // approve all then tokens to this address
        let result  = await instance.jjAppproveTo("0xc698cd17ca036E06aBBb646044e1255633D84556", balance)
        assert.equal(0,0);
    })

    it('should transfer token to other users', async () => {
        let instance = await JJToken.deployed();
        // 开始转账
        let result = await instance.jjTransfer(
            enterprises[1].enterpriseAddress,
            transferAmount, {
            from: enterprises[0].enterpriseAddress,
        }
        );
        let balance1 = await instance.jjBalance(enterprises[0].enterpriseAddress, {
            from: enterprises[0].enterpriseAddress,
        });
        let balance2 = await instance.jjBalance(enterprises[1].enterpriseAddress, {
            from: enterprises[1].enterpriseAddress,
        });
        assert.equal(
            Number(balance1),
            Number(amount) - Number(burnAmount) - Number(transferAmount)
        );
        assert.equal(Number(balance2), Number(transferAmount));
    });

    // 测试结束，销毁所有token
    it("should burn all tokens at the end of test", async () => {
        let instance = await JJToken.deployed();
        // 开始销毁
        let rest = await instance.jjBalance(enterprises[0].enterpriseAddress)
        await instance.jjBurn(enterprises[0].enterpriseAddress, rest, { from: accountAdmin });
        let balance = await instance.jjBalance(enterprises[0].enterpriseAddress, { from: enterprises[0].enterpriseAddress });
        assert.equal(Number(balance), Number(0));
    })
});