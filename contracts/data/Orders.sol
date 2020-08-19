// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

contract Orders {

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);
    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public adminAddress;
    address public feeAddress;
    address[] public storeAddress;
    address[] public enterpriseAddress;


    event OrderDelete(string ORDER_ID);
    event OrderEvent(string ORDER_ID, string USER_ID, string CONSIGNOR, string CONSIGNEE,string CONSIGNEE_TEL,string TRANSACTION_DATE, uint256 TOTAL_PRICE,string  	CONSIGNEE_ADDRESS,string  	STATUS,string  	DELIVERY,string  	CREATE_USER,string  	CREATE_TIME	,string  UPDATE_USER	,string  UPDATE_TIME	,string  ACCOUNT_NAME	,string  ACCOUNT_ID,string  TEL	,string  APP_KEY ,uint256  PAY_MONEY,uint256  SUM_INTEGRAL,string THIRD_ORDER_ID) ;


    struct order{
        string ORDER_ID;
        string USER_ID;
        string CONSIGNOR;
        string CONSIGNEE;
        string CONSIGNEE_TEL;
        string TRANSACTION_DATE;
        uint256 TOTAL_PRICE;
        string CONSIGNEE_ADDRESS;
        string STATUS;
        string DELIVERY;
        string CREATE_USER;
        string CREATE_TIME;
        string UPDATE_USER;
        string UPDATE_TIME;
        string ACCOUNT_NAME;
        string ACCOUNT_ID;
        string TEL;
        string APP_KEY;
        uint256 PAY_MONEY;
        uint SUM_INTEGRAL;
        string THIRD_ORDER_ID;
    }

    order[] public orders;

    function appendOrder(string memory ORDER_ID, string memory USER_ID, string memory CONSIGNOR, string memory CONSIGNEE, string memory CONSIGNEE_TEL,string memory TRANSACTION_DATE, uint256 TOTAL_PRICE, string memory CONSIGNEE_ADDRESS,string memory STATUS,string memory DELIVERY,string memory CREATE_USER,string memory  CREATE_TIME, string memory UPDATE_USER, string memory UPDATE_TIME, string memory ACCOUNT_NAME, string memory ACCOUNT_ID, string memory TEL, string memory APP_KEY, uint256 PAY_MONEY,uint256  SUM_INTEGRAL,string memory THIRD_ORDER_ID) onlyAdmin external{
        order memory newOrder = order(ORDER_ID	,USER_ID,	CONSIGNOR,	CONSIGNEE,	CONSIGNEE_TEL,	TRANSACTION_DATE,	TOTAL_PRICE	,CONSIGNEE_ADDRESS,	STATUS,	DELIVERY,	CREATE_USER	,CREATE_TIME	,UPDATE_USER	,UPDATE_TIME,	ACCOUNT_NAME,	ACCOUNT_ID,	TEL	,APP_KEY,	PAY_MONEY,	SUM_INTEGRAL	,THIRD_ORDER_ID);
        orders.push(newOrder);
        //emit event
        emit OrderEvent(ORDER_ID ,USER_ID,	CONSIGNOR,	CONSIGNEE,	CONSIGNEE_TEL,	TRANSACTION_DATE,	TOTAL_PRICE	,CONSIGNEE_ADDRESS,	STATUS,	DELIVERY,	CREATE_USER	,CREATE_TIME	,UPDATE_USER	,UPDATE_TIME,	ACCOUNT_NAME,	ACCOUNT_ID,	TEL	,APP_KEY,	PAY_MONEY,	SUM_INTEGRAL	,THIRD_ORDER_ID);
    }


    function getOrderById(string memory ORDER_ID) public view returns (order memory o) {
         for(uint256 i =0; i< orders.length; i++){
           if(compareStrings(orders[i].ORDER_ID , ORDER_ID)){
              return orders[i];
           }
       }
    }


    function ordersCount() public view returns (uint256 storesCount){
        return orders.length;
    }

    function deleteOrder(string memory ORDER_ID) onlyAdmin external returns(bool success){
        for(uint256 i =0; i< orders.length; i++){
           if(compareStrings(orders[i].ORDER_ID , ORDER_ID)){
              orders[i] = orders[orders.length-1]; // pushing last into current arrray index which we gonna delete
              delete orders[orders.length-1]; // now deleteing last index
              emit OrderDelete(ORDER_ID);
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
