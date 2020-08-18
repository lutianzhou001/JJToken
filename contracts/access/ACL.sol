// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./Roles.sol";

contract ACL {

    address constant deployedAddress = 0x22e7Dd9B7C2708dE833b880EF9804D3E31689Fa6;

    modifier onlyEnterprise() {
        Roles rl = Roles(deployedAddress);
        uint flag = 0;
        for (uint i = 0; i < rl.enterpriseCount(); i++) {
            if ( msg.sender  ==  rl.veryEnterprise(i).enterpriseAddress) {
            flag = 1;
            }
        }
        require(flag == 1);
        _;
    }

    function getFeeAddress() public view returns (address fAddress){
         Roles rl = Roles(deployedAddress);
         return rl.feeAddress();
    }

    modifier onlyAdmin() {
        Roles rl = Roles(deployedAddress);
        require(msg.sender == rl.adminAddress());
        _;
    }

    modifier onlyStore() {
        Roles rl = Roles(deployedAddress);
        uint flag = 0;
        for (uint i = 0; i < rl.storesCount(); i++) {
            if ( msg.sender  == rl.veryStore(i).storeAddress) {
            flag = 1;
            }
        }
        require(flag == 1);
        _;
    }

}
