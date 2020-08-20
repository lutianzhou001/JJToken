// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../../access/ACL.sol";
import "./JJToken.sol";

import "./ERC20.sol";
import "./IERC20.sol";
import "../../math/SafeMath.sol";

contract Coupons is ERC20, ACL {

    mapping (address => mapping (address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)

    event OrderForUser(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint nonce, address maker, bytes32 indexed orderHash);
    event TradeForUser(bytes32 indexed orderHash, uint amount, address give);
    event Cancel(bytes32 indexed orderHash);
    event Deposit(address token, address user, uint amount, uint balance);
    event Withdraw(address token, address user, uint amount, uint balance);
    event FundsMigrated(address user, address newContract);

    struct Coupon {
        string name;
        string symbol;
        string id;
        string[] storeId;
        uint256 expireTime;
        uint256 issueTime;
    }

    event NewCoupon(string name ,string symbol, string id, string[] storeId, uint256 expireTime, uint256 issueTime);

    constructor (string memory name, string memory symbol, string memory id, string[] memory storeId, uint256 expireTime, uint256 issueTime )
        ERC20(name, symbol)
        public
    {
        _mint(msg.sender, 0 * 10 ** uint(decimals()));
        // begin recording message here.
        // setAdmin(msg.sender);
        coupons.push(Coupon(name, symbol ,id ,storeId ,expireTime,issueTime));
        emit NewCoupon(name, symbol ,id ,storeId ,expireTime,issueTime);

    }
    Coupon[] public coupons;

    function getInfo() public view returns (Coupon memory cp){
        return coupons[0];
    }

    function getBalance(address userAddress) public view returns(uint256) {
        return balanceOf(userAddress);
    }

    function withdraw(address tokenAddress, uint256 amount) public payable returns(address) {
        require(getBalance(msg.sender) >= amount, "not larger than amount");
        burn(msg.sender,amount);
        JJToken jToken = JJToken(tokenAddress);
        // 商家分成商家分成商家90%；
        jToken.jjTransfer(msg.sender, amount.mul(9).div(10));
        // 平台分成10%；
        jToken.jjTransfer(getFeeAddress(), amount.mul(1).div(10));
    }

    function batchMint(address tokenAddress, address[] memory staff,uint256 amount) onlyAdmin public {
        for (uint i = 0; i < staff.length; i++) {
            JJToken jToken = JJToken(tokenAddress);
            jToken.transferFrom(msg.sender, address(this), amount);
            _mint(staff[i], amount);
        }
    }

    function issue(address tokenAddress, address enterpriseAddress,uint256 amount) onlyAdmin public{
        JJToken jToken = JJToken(tokenAddress);
        jToken.jjMint(enterpriseAddress,amount);
    }

    function mint(address tokenAddress, address staff, uint256 amount) onlyEnterprise public  {
        JJToken jToken = JJToken(tokenAddress);
        jToken.transferFrom(msg.sender, address(this), amount);
        _mint(staff, amount);
    }

    function burn(address account, uint256 amount) onlyStore public  {
        _burn(account, amount);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function refund(address recipient, uint256 amount) onlyStore public virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
}
