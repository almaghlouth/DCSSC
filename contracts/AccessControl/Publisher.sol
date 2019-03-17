pragma solidity ^0.5.0;

import "../Ownable/Ownable.sol";

contract PublisherRole is Ownable {

    event ContentAuthenticated(uint256 id);
    event ContentAwarded(uint256 id);
    event ContentMassSale(uint256 id);

    function getContentForSale (uint256 _id) public view returns (
        uint256 id,
        bool auction,
        bool awarded,
        bool massSale,
        uint256 price,
        uint256 royality,
        string memory authHash
        ){
        return (contentsForSale[_id].id, contentsForSale[_id].auction,contentsForSale[_id].awarded,contentsForSale[_id].massSale,
        contentsForSale[_id].price,contentsForSale[_id].royality,contentsForSale[_id].authHash);
    }
    
    function authenticate (uint256 _id, string memory _hash) public {
        if ((keccak256(abi.encodePacked(_hash)) == keccak256(abi.encodePacked(product[_id][0].contentHash))) && (product[_id][0].authenticator == address(0)) && (contentsForSale[_id].auction == true)){
            contentsForSale[_id].authHash = _hash;
            product[_id][0].authenticator = msg.sender;
            emit ContentAuthenticated(_id);
        }
    }
    
    function buyContentForSale (uint256 _id) payable public returns (bool) {
        if ((msg.value >= contentsForSale[_id].price) && (product[_id][0].publisher == address(0)) 
        && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == true) ) {
            product[_id][0].creator.transfer(msg.value);
            contentsForSale[_id].awarded = true;
            product[_id][0].publisher = msg.sender;
            emit ContentAwarded(_id);
            return true;
        }
        return false;
    }
    
    function putMassSale (uint256 _id, uint256 _itemPrice) public {
        if ((product[_id][0].publisher == msg.sender) && (product[_id][0].authenticator != address(0)) && (contentsForSale[_id].awarded == true) && (contentsForSale[_id].massSale == false)) {
            product[_id][0].price = _itemPrice;
            contentsForSale[_id].massSale = true;
            emit ContentMassSale(_id);
        }
    }
}