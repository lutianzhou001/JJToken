const JJToken = artifacts.require('JJtoken');
var web3 = require('web3');

contract('JJToken test', async accounts => {
    //预置条件
    let accountAdmin = '0x13cd7377D9749B22764EfdC3fC98A4a3DD0F3C77';
    let amount = web3.utils.toBN(1000);
    let burnAmount = web3.utils.toBN(200);
    let transferAmount = web3.utils.toBN(100);
    let stores = [{
        storeName: 'JD',
        storeId: 's001',
        storeAddress: '0x8257700fA1015B35C947444D7EA78143248e7A97',
    },
    {
        storeName: 'TB',
        storeId: 't001',
        storeAddress: '0x4e1ad8C78604219E59679e6a52Bc6b68131DFB7e',
    },
    ];

    let enterprises = [{
        enterpriseName: 'Yuanlu',
        enterpriseId: 'y001',
        enterpriseAddress: '0xD433b45D13a1c00947a4fbef7155BbeF48862D86',
    },
    {
        enterpriseName: 'Ningbo',
        enterpriseId: 'n001',
        enterpriseAddress: '0x94BEFeFF67b36281331B6D4bBf5F57C8D8cA8226',
    },
    ];

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