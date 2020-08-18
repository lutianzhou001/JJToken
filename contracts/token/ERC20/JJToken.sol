// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../../access/AccessController.sol";


import "./ERC20.sol";
import "./IERC20.sol";
import "../../math/SafeMath.sol";

contract JJToken is ERC20, AccessController {

    constructor (string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {}

    function getBalance() public view returns(uint256) {
        return balanceOf(msg.sender);
    }

    function mint(address enterprise, uint256 amount) public  {
        _mint(enterprise, amount);
    }


    function burn(address account, uint256 amount)  public  {
        _burn(account, amount);
    }

    function approveTo(address tokenAddress, uint256 amount) onlyEnterprise public virtual returns (bool) {
        _approve(msg.sender, tokenAddress, amount);
        return true;
    }
    
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
}
