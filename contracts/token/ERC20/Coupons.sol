// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../../access/ACL.sol";
import "./JJToken.sol";

import "./ERC20.sol";
import "./IERC20.sol";
import "../../math/SafeMath.sol";
import "../../data/Orders.sol";
import "../../data/OrderDetails.sol";


contract Coupons is ERC20, ACL {
    
    mapping (address => mapping (address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)

    event OrderForUser(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint nonce, address maker, bytes32 indexed orderHash);
    event TradeForUser(bytes32 indexed orderHash, uint amount, address give);
    event Cancel(bytes32 indexed orderHash);
    event Deposit(address token, address user, uint amount, uint balance);
    event Withdraw(address token, address user, uint amount, uint balance);
    event FundsMigrated(address user, address newContract);
    
    // storePercentage and platformPercentage
    uint256 public storePercentage;
    

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

    function getJJTokenBalance(address userAddress) public view returns(uint256) {
        JJToken jToken = JJToken(JJTokenAddress);
        return jToken.balanceOf(userAddress);
    }
    
    function setStorePercentage(uint256 _storePercentage) onlyAdmin public returns(bool) {
        uint256 total = 100;
        require( _storePercentage < total);
        storePercentage = _storePercentage;
    }
    
    function withdraw(uint256 amount) public payable returns(address) {
        require(getBalance(msg.sender) >= amount, "not larger than amount");
        burnMyself(amount);
        JJToken jToken = JJToken(JJTokenAddress);
        jToken.jjTransfer(msg.sender, amount.mul(storePercentage).div(100));
        // 默认只有平台和商家参与分成
        uint256 total = 100;
        uint256 platformPercentage = total.sub(storePercentage);
        jToken.jjTransfer(getFeeAddress(), amount.mul(platformPercentage).div(100));
    }

    function batchMint(address[] memory staff,uint256 amount) onlyEnterprise public {
        for (uint i = 0; i < staff.length; i++) {
            JJToken jToken = JJToken(JJTokenAddress);
            jToken.transferFrom(msg.sender, address(this), amount);
            _mint(staff[i], amount);
        }
    }

    function issue(address enterpriseAddress,uint256 amount) onlyAdmin public{
        JJToken jToken = JJToken(JJTokenAddress);
        jToken.jjMint(enterpriseAddress, amount);
    }

    function mint(address staff, uint256 amount) onlyEnterprise public  {
        JJToken jToken = JJToken(JJTokenAddress);
        jToken.transferFrom(msg.sender, address(this), amount);
        _mint(staff, amount);
    }

    function burnMyself(uint256 amount) public  {
        _burn(msg.sender, amount);
    }

    function burn(address account, uint256 amount) onlyAdmin public {
        _burn(account, amount);
    }

    function couponTransfer(address recipient, uint256 amount,string memory _orderId, string[] memory _orderDetailId, string memory _orderContent, string[] memory _orderDetailContent) public virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        // then record it!
        Orders o = Orders(OrdersAddress);
        o.appendOrder(_orderId,_orderContent);
        OrderDetails od = OrderDetails(OrderDetailsAddress);
        require(_orderDetailId.length == _orderDetailContent.length, "orderDetailsId length must be same as orderDetailsContent length");
        for (uint i = 0; i < _orderDetailId.length; i++) {
             od.appendOrderDetail(_orderDetailId[i],  _orderDetailContent[i]);
        }
        return true;
    }

    function couponRefund(address recipient, uint256 amount,string memory _orderId, string[] memory _orderDetailId, string memory _orderContent, string[] memory _orderDetailContent) onlyStore public virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        Orders o = Orders(OrdersAddress);
        o.appendOrder(_orderId,_orderContent);
        OrderDetails od = OrderDetails(OrderDetailsAddress);
        require(_orderDetailId.length == _orderDetailContent.length, "orderDetailsId length must be same as orderDetailsContent length");
        for (uint i = 0; i < _orderDetailId.length; i++) {
            od.appendOrderDetail(_orderDetailId[i],  _orderDetailContent[i]);
        }
        return true;
    }
}
