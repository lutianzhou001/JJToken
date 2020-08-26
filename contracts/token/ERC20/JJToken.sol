// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../../access/ACL.sol";


import "./ERC20.sol";
import "./IERC20.sol";
import "../../math/SafeMath.sol";


contract JJToken is ERC20, ACL {

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {}
    

    function jjBalance(address userAddress) public view returns(uint256) {
        return balanceOf(userAddress);
    }

    function jjMint(address enterprise, uint256 amount) public  {
        _mint(enterprise, amount);
    }


    function jjBurn(address account, uint256 amount) public  {
        _burn(account, amount);
    }

    function jjApproveTo(address tokenAddress, uint256 amount) onlyEnterprise public returns (bool) {
        _approve(msg.sender, tokenAddress, amount);
        return true;
    }

    function jjTransfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
}
