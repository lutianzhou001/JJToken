// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../access/ACL.sol";

contract OrderDetails is ACL {

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);

    event OrderDetailDelete(string orderId);
    event OrderDetailEvent(string orderDetailId,string orderDetailContent) ;

    
    struct orderDetail{
        string orderDetailId; 
        string orderDetailContent;
    }
    
    orderDetail[] public orderDetails; 
   
    function appendOrderDetail(string memory _orderDetailId, string memory _orderDetailContent) external{
        orderDetail memory newOrderDetail = orderDetail(_orderDetailId, _orderDetailContent);
        orderDetails.push(newOrderDetail);
        //emit event
        emit OrderDetailEvent(_orderDetailId,_orderDetailContent);
    }
    
    function getOrderDetailById(string memory _orderDetailId) public view returns (orderDetail memory od) {
         for(uint256 i =0; i< orderDetails.length; i++){
           if(compareStrings(orderDetails[i].orderDetailId , _orderDetailId)){
              return orderDetails[i];
           }
       }
    }
    
    function orderDetailsCount() public view returns (uint256 odc){
        return orderDetails.length;
    }
    
    function deleteOrderDetail(string memory _orderDetailId) external returns(bool success){
        for(uint256 i =0; i< orderDetails.length; i++){
           if(compareStrings(orderDetails[i].orderDetailId , _orderDetailId)){
              orderDetails[i] = orderDetails[orderDetails.length-1]; // pushing last into current arrray index which we gonna delete
              delete orderDetails[orderDetails.length-1]; // now deleteing last index
              emit OrderDetailDelete(_orderDetailId);
              return true;
           }
       }
       return false;
    }
 
    function compareStrings (string memory a, string memory b) internal pure returns (bool){
       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

}