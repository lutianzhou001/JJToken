// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

contract Roles {

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);
    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public adminAddress;
    address public feeAddress;
    address[] public storeAddress;
    address[] public enterpriseAddress;
    uint256 storesLength = 0;
    uint256 enterprisesLength = 0;
    
    event StoreEvent(string storeName , string storeId, address storeAddress);
    event EnterpriseEvent(string enterpriseName , string enterpriseId, address enterpriseAddress);
    event EnterpriseUpdated(string enterpriseId , string enterpriseName,address enterpriseAddress);
    event StoreUpdated(string storeId , string storeName,address storeAddress);
    event EnterpriseDelete(string enterpriseId);
    event StoreDelete(string storeId);


    
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
   
    function appendStore(string memory _newStoreName, string memory _newStoreId ,address _newStoreAddress) onlyAdmin external{
        require(_newStoreAddress != address(0));
        store memory newStore = store(_newStoreName , _newStoreId, _newStoreAddress);
        stores.push(newStore);
        storesLength = storesLength + 1;
        //emit event
        emit StoreEvent (_newStoreName, _newStoreId, _newStoreAddress);
    }
    
    function appendEnterprise (string memory _newEnterpriseName, string memory _newEnterpriseId ,address  _newEnterpriseAddress ) onlyAdmin external {
        require(_newEnterpriseAddress != address(0));
        enterprise memory newEnterprise = enterprise(_newEnterpriseName , _newEnterpriseId, _newEnterpriseAddress);
        enterprises.push(newEnterprise);
        enterprisesLength = enterprisesLength + 1;
        //emit event
        emit EnterpriseEvent (_newEnterpriseName, _newEnterpriseId, _newEnterpriseAddress);
    }
    
    
    function getStoreById(string memory _storeId) public view returns (address sAddress) {
         for(uint256 i =0; i< storesLength; i++){
           if(compareStrings(stores[i].storeId , _storeId)){
              return stores[i].storeAddress;
           }
       }
    }
    
    function getEnterpriseById(string memory  _enterpriseId) public view returns (address eAddress) {
        for(uint256 i =0; i< enterprisesLength; i++){
           if(compareStrings(enterprises[i].enterpriseId , _enterpriseId)){
              return enterprises[i].enterpriseAddress;
           }
       }
    }
    
    
    function storesCount() public view returns (uint256 sc){
        return storesLength;
    }
    
    function veryStore(uint index) public view returns (store memory vs){
        return stores[index];
    }  

    function enterprisesCount() public view returns (uint256 ec){
        return enterprisesLength;
    }
    
    function veryEnterprise(uint index) public view returns (enterprise memory ve){
        return enterprises[index];
    }  
    
    function updateEnterprise(string memory _enterpriseId, string memory _newEnterpriseName ,address  _newEnterpriseAddress ) onlyAdmin external returns (bool success){
       //This has a problem we need loop
       for(uint256 i =0; i< enterprisesLength; i++){
           if(compareStrings(enterprises[i].enterpriseId , _enterpriseId)){
              enterprises[i].enterpriseAddress = _newEnterpriseAddress;
              enterprises[i].enterpriseName = _newEnterpriseName;
              emit EnterpriseUpdated(_enterpriseId,_newEnterpriseName,_newEnterpriseAddress);
              return true;
           }
       }
       return false;
    }
    
    function updateStore(string memory _storeId, string memory _newStoreName ,address  _newStoreAddress ) onlyAdmin external returns (bool success){
       //This has a problem we need loop
       for(uint256 i =0; i< storesLength; i++){
           if(compareStrings(stores[i].storeId , _storeId)){
              stores[i].storeAddress = _newStoreAddress;
              stores[i].storeName = _newStoreName;
              emit StoreUpdated(_storeId,_newStoreName,_newStoreAddress);
              return true;
           }
       }
       return false;
    }
    
    
    function deleteEnterprise(string memory _enterpriseId) onlyAdmin external returns(bool success){
        for(uint256 i =0; i< enterprisesLength; i++){
           if(compareStrings(enterprises[i].enterpriseId , _enterpriseId)){
              enterprises[i] = enterprises[enterprisesLength - 1]; // pushing last into current arrray index which we gonna delete
              delete enterprises[enterprisesLength - 1]; // now deleteing last index
              enterprisesLength = enterprisesLength - 1;
              emit EnterpriseDelete(_enterpriseId);
              return true;
           }
       }
       return false;
   }
   
    
    function deleteStore(string memory _storeId) onlyAdmin external returns(bool success){
        for(uint256 i =0; i< storesLength; i++){
           if(compareStrings(stores[i].storeId , _storeId)){
              stores[i] = stores[storesLength - 1]; // pushing last into current arrray index which we gonna delete
              delete stores[storesLength - 1]; // now deleteing last index
              storesLength = storesLength - 1;
              emit StoreDelete(_storeId);
              return true;
           }
       }
       return false;
   }
   
    
    function compareStrings (string memory a, string memory b) internal pure returns (bool){
       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
   
    function setFeeAddress(address _newFeeAddress) onlyAdmin external{
        require(_newFeeAddress != address(0));
        feeAddress = _newFeeAddress;
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
