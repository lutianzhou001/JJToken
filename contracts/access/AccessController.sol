// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

contract AccessController {

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);
    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public adminAddress;
    address public feeAddress;
    address[] public storeAddress;
    address[] public enterpriseAddress;
    
    modifier onlyEnterprise() {
        uint flag = 0;
        for (uint i = 0; i < enterpriseAddress.length; i++) {
            if ( msg.sender  == enterpriseAddress[i] ) {
            flag = 1;
            }
        }
        require(flag == 1);
        _;
    }
 
    modifier onlyAdmin() {
        require(msg.sender == adminAddress);
        _;
    }

    modifier onlyStore() {
        uint flag = 0;
        for (uint i = 0; i < storeAddress.length; i++) {
            if ( msg.sender  == storeAddress[i] ) {
            flag = 1;
            }
        }
        require(flag == 1);
        _;
    }
    
    function setFeeAddress(address _newFeeAddress) onlyAdmin external{
        require(_newFeeAddress != address(0));
        feeAddress = _newFeeAddress;
    }

    function setAdmin(address _newAdmin) external {
        require(_newAdmin != address(0));
        adminAddress = _newAdmin;
    }

    function setStore(address[] memory _newStore) onlyAdmin external  {
        // require(_newStore != address(0));
        uint flag = 0;
        for (uint i = 0; i < _newStore.length; i++) {
            if ( _newStore[i]  == address(0) ) {
              flag = 1;
            }
        }
        require(flag != 1);
        storeAddress = _newStore;
    }
    
    function setEnterpeise(address[] memory _newEnterprise) onlyAdmin external  {
        // require(_newStore != address(0));
        uint flag = 0;
        for (uint i = 0; i < _newEnterprise.length; i++) {
            if ( _newEnterprise[i]  == address(0) ) {
              flag = 1;
            }
        }
        require(flag != 1);
        enterpriseAddress = _newEnterprise;
    }
}
