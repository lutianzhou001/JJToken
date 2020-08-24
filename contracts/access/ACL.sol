// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./Roles.sol";
import "../config/Config.sol";

contract ACL is Config {


    modifier onlyEnterprise() {
        Roles rl = Roles(RolesAddress);
        uint flag = 0;
        for (uint i = 0; i < rl.enterprisesCount(); i++) {
            if ( msg.sender  ==  rl.veryEnterprise(i).enterpriseAddress) {
            flag = 1;
            }
        }
        require(flag == 1);
        _;
    }

    function getFeeAddress() public view returns (address fAddress){
         Roles rl = Roles(RolesAddress);
         return rl.feeAddress();
    }

    modifier onlyAdmin() {
        Roles rl = Roles(RolesAddress);
        require(msg.sender == rl.adminAddress());
        _;
    }

    modifier onlyStore() {
        Roles rl = Roles(RolesAddress);
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
