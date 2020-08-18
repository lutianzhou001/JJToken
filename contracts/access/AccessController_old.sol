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
    
    event StoreEvent(string storeName , string storeId, address storeAddress);
    event EnterpriseEvent(string enterpriseName , string enterpriseId, address enterpriseAddress);
    event EnterpriseUpdated(string enterpriseId , string enterpriseName,address enterpriseAddress);
    event EnterpriseDelete(string enterpriseId);
    
    struct store{
      string storeName;
      string storeId;
      address storeAddress;
    }
    
    struct enterprise{
      string enterpriseName;
      string enterpriseId;
      address enterpriseAddress;
    }
    
   store[] public stores; 
   enterprise[] public enterprises;
   

   uint256 public totalStores;
   uint256 public totalEnterprises;
   
   
    function appendStore(string memory _newStoreName, string memory _newStoreId ,address _newStoreAddress) onlyAdmin external returns ( uint256 totalStores) {
        require(_newStoreAddress != address(0));
        store memory newStore = store(_newStoreName , _newStoreId, _newStoreAddress);
        stores.push(newStore);
        //emit event
        emit StoreEvent (_newStoreName, _newStoreId, _newStoreAddress);
        return totalStores;
    }
    
    function appendEnterprise (string memory _newEnterpriseName, string memory _newEnterpriseId ,address  _newEnterpriseAddress ) onlyAdmin external returns ( uint256 totalEnterprises) {
        require(_newEnterpriseAddress != address(0));
        enterprise memory newEnterprise = enterprise(_newEnterpriseName , _newEnterpriseId, _newEnterpriseAddress);
        enterprises.push(newEnterprise);
        //emit event
        emit EnterpriseEvent (_newEnterpriseName, _newEnterpriseId, _newEnterpriseAddress);
        return totalEnterprises;
    }
    
    function updateEnterprise(string memory _enterpriseId, string memory _newEnterpriseName ,address  _newEnterpriseAddress ) onlyAdmin external returns (bool success){
       //This has a problem we need loop
       for(uint256 i =0; i< enterprises.length; i++){
           if(compareStrings(enterprises[i].enterpriseId , _enterpriseId)){
              enterprises[i].enterpriseAddress = _newEnterpriseAddress;
              enterprises[i].enterpriseName = _newEnterpriseName;
              emit EnterpriseUpdated(_enterpriseId,_newEnterpriseName,_newEnterpriseAddress);
              return true;
           }
       }
       return false;
    }
    
    
     function deleteEnterprise(string memory _enterpriseId) onlyAdmin external returns(bool success){
        for(uint256 i =0; i< enterprises.length; i++){
           if(compareStrings(enterprises[i].enterpriseId , _enterpriseId)){
              enterprises[i] = enterprises[totalEnterprises-1]; // pushing last into current arrray index which we gonna delete
              delete enterprises[totalEnterprises-1]; // now deleteing last index
              totalEnterprises--; //total count decrease
              // enterprises.length--; // array length decrease
              //emit event
              emit EnterpriseDelete(_enterpriseId);
              return true;
           }
       }
       return false;
   }
   
    
    
    function compareStrings (string memory a, string memory b) internal pure returns (bool){
       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
   
   
    function setAdmin(address _newAdmin) external {
        require(_newAdmin != address(0));
        adminAddress = _newAdmin;
    }
    
 
    modifier onlyAdmin() {
        require(msg.sender == adminAddress);
        _;
    }

}
