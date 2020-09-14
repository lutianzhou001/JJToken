// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import '../../math/SafeMath.sol';
import '../../access/Ownable.sol';
import './ERC721.sol';

contract Crts is ERC721 {
    
        
 constructor (string memory name, string memory symbol) ERC721( name, symbol) public{
     
 }
 

  using SafeMath for uint256;
  
  uint digits = 16;
  uint modulus = 10 ** digits;
  uint256 crtLength = 0;

  event NewCrt(uint id, string name, string license,string scope,string expireDate);

  struct crt {
    string name;
    string license;
    string scope;
    uint256 expireDate;
  }

  crt[] public crts;

  mapping (uint => address) public crtToOwner;
  mapping (address => uint) ownerCrtCount;
 

  function createCrt(address _address, string memory _name, string memory _license, string memory _scope, uint256 _expireDate) public {
    //  uint256 randomId = _generateRandomId(_license);
    crts.push(crt(_name, _license, _scope, _expireDate));
    crtLength = crtLength + 1;
    crtToOwner[crtLength - 1] = _address;
    ownerCrtCount[_address]++;
    uint256 crtNumber = uint256(keccak256(abi.encodePacked(_address)));
    _safeMint(_address, crtNumber);
    // NewCrt(id,_name,_license,_scope,_expireDate);
  }


  function _generateRandomId(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % modulus;
  }
  
   function balanceOf(address _owner) override public view returns (uint256 _balance)  {
    return ownerCrtCount[_owner];
  }

  function ownerOf(uint256 _tokenId) override public view returns (address _owner) {
    return crtToOwner[_tokenId];
  }


  function transfer(address _to, uint256 _tokenId) public  {
    _transfer(msg.sender, _to, _tokenId);
    ownerCrtCount[_to] = ownerCrtCount[_to].add(1);
    ownerCrtCount[msg.sender] = ownerCrtCount[msg.sender].sub(1);
    crtToOwner[_tokenId] = _to;
  }
}
