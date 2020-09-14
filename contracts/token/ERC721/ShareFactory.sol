pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

import '../../math/SafeMath.sol';
import '../ERC721/ERC721.sol';
// import "github.com/Arachnid/solidity-stringutils/strings.sol";

// import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ShareFactory is ERC721 {
    
 constructor (string memory name, string memory symbol) ERC721(name,symbol) public{
     
 }

  using SafeMath for uint256;
  
  event NewShare(uint id, string name, string license,string scope,string expireDate);

  struct share {
    uint256 shareId;
    string license;
    uint256 percentage;
  }

  share[] public shares;
  uint256 shareLength = 0;
  
  uint256 percentage1 = 0;
  uint256 percentage2 = 0; 

  mapping (uint => address) public shareToOwner;
  mapping (address => uint) ownerShareCount;

  function findIndexByShareId(uint256 _shareId) public view returns (uint256 index) {
       for(uint256 i = 0; i< shareLength; i++) {
           if(shares[i].shareId == _shareId) {
              return i;
        }
    }
  }
  
  function findLincenseByShareId(uint256 _shareId) public view returns (string memory ls) {
       for(uint256 i = 0; i< shareLength; i++) {
           if(shares[i].shareId == _shareId) {
              return shares[i].license;
        }
    }
  }
 
  
  function createShare(string memory _license, address _address) public {
    // using keccak256 to generate tokenId with _license
    uint256 shareId = uint256(keccak256(abi.encodePacked(_license)));
    shares.push(share(shareId, _license, 100));
    shareLength = shareLength + 1;
    shareToOwner[shareLength - 1] = _address;
    ownerShareCount[_address]++;
    _safeMint( _address, shareId);
    // NewCrt(id,_name,_license,_scope,_expireDate);
  }
  
  
  function compareStrings (string memory a, string memory b) internal pure returns (bool){
       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
  }
    
  
    
  function mergeShares(uint256 _shareId1, uint256 _shareId2 ) public {
      
      
      uint256 index1 = findIndexByShareId(_shareId1);
      uint256 index2 = findIndexByShareId(_shareId2);
      require(ownerOf(index1) == ownerOf(index2), "not applicable, owner not same");
      require(ownerOf(_shareId1) == ownerOf(_shareId2),"not applicable, owner not same");
      string memory license1 = findLincenseByShareId(_shareId1);
      string memory license2  = findLincenseByShareId(_shareId2);
      address owner = ownerOf(index1);

      require(compareStrings(license1,license2) , "license not same");
  
       // now we delete two elements 
              
       shares[index1] = shares[shareLength - 1]; // pushing last into current arrray index which we gonna delete
       delete shares[shareLength - 1]; // now deleteing last index
       shareLength = shareLength - 1;
           
       shares[index2] = shares[shareLength - 1]; // pushing last into current arrray index which we gonna delete
       delete shares[shareLength - 1]; // now deleteing last index
       shareLength = shareLength - 1;

        // add the new one 
       uint256 shareId = uint256(keccak256(abi.encodePacked(_shareId1.add(_shareId2))));
       shares.push(share(shareId, license1, percentage1.add(percentage2)));
       shareLength = shareLength + 1;
       shareToOwner[shareLength - 1] = owner;
       ownerShareCount[owner]++;
       _safeMint(owner, shareId);
       // now we gonna burn these two tokens
       _burn(_shareId1);
       _burn(_shareId2);
  }
  
  function dispenseShares(uint256 _shareId, uint256 percentage) public {
      // shareId's percentage must greater than the percentage;
      for(uint256 i = 0; i < shareLength; i++) {
           if(shares[i].shareId == _shareId) {
              require(shares[i].percentage > percentage,"not applicable, percentage cannot greater than origin ");
              
              percentage1 = percentage;
              percentage2 = shares[i].percentage - percentage1;
      
              string memory license1 = shares[i].license;
              string memory license2 = shares[i].license;
              uint256 shareId1 = uint256(keccak256(abi.encodePacked(_shareId.add(1))));
              uint256 shareId2 = uint256(keccak256(abi.encodePacked(_shareId.add(2))));
              
              // add one
              shares.push(share(shareId1, license1, percentage1));
              shareLength = shareLength + 1;
              shareToOwner[shareLength-1] = ownerOf(i);
              ownerShareCount[ownerOf(i)] ++;
              _safeMint(ownerOf(i), shareId1);
       
              // add another one 
              shares.push(share(shareId2, license2, percentage2));
              shareLength = shareLength + 1;
              shareToOwner[shareLength-1] = ownerOf(i);
              ownerShareCount[ownerOf(i)] ++;
              _safeMint(ownerOf(i), shareId2);
              
              
              // delete the origin one 
              shares[i] = shares[shareLength - 1]; // pushing last into current arrray index which we gonna delete
              delete shares[shareLength - 1]; // now deleteing last index
              shareLength = shareLength - 1;
              _burn(_shareId);
         }
      }
  }
 
  
   function balanceOf(address _owner) override public view returns (uint256 _balance) {
    return ownerShareCount[_owner];
  }

  function ownerOf(uint256 _tokenId) override public view returns (address _owner) {
    return shareToOwner[_tokenId];
  }
  
  function transfer(address _to, uint256 _tokenId) public {
    _transfer(msg.sender, _to, _tokenId);
    ownerShareCount[_to] = ownerShareCount[_to].add(1);
    ownerShareCount[msg.sender] = ownerShareCount[msg.sender].sub(1);
    shareToOwner[_tokenId] = _to;
  }
}
