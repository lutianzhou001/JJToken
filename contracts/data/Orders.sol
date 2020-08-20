// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../access/ACL.sol";

contract Orders is ACL {

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);

    event OrderDelete(string orderId);
    event OrderEvent(string orderId,string orderContent) ;

    
    struct order{
        string orderId; 
        string orderContent;
    }
    
    
    order[] public orders; 
   
    function appendOrder(string memory _orderId, string memory _orderContent) external{
        order memory newOrder = order(_orderId,_orderContent);
        orders.push(newOrder);
        //emit event
        emit OrderEvent(_orderId,_orderContent);
    }
    
    
    function getOrderById(string memory _orderId) public view returns (order memory o) {
         for(uint256 i =0; i< orders.length; i++){
           if(compareStrings(orders[i].orderId , _orderId)){
              return orders[i];
           }
       }
    }
    
    function ordersCount() public view returns (uint256 oc){
        return orders.length;
    }
    
    function deleteOrder(string memory _orderId) external returns(bool success){
        for(uint256 i =0; i< orders.length; i++){
           if(compareStrings(orders[i].orderId , _orderId)){
              orders[i] = orders[orders.length-1]; // pushing last into current arrray index which we gonna delete
              delete orders[orders.length-1]; // now deleteing last index
              emit OrderDelete(_orderId);
              return true;
           }
       }
       return false;
    }
 
    function compareStrings (string memory a, string memory b) internal pure returns (bool){
       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

}
