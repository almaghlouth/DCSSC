pragma solidity ^0.5.0;

import "./Creator.sol";
import "./Publisher.sol";
import "./Seller.sol";
import "./Buyer.sol";

contract Roles is CreatorRole,PublisherRole,SellerRole,BuyerRole {

    function trackItem (uint256 _id, uint256 _serial) public view returns (
        address creator,
        address authenticator,
        address publisher,
        address seller,
        address owner,
        uint256 price
    ) {
        return (product[_id][_serial].creator, product[_id][_serial].authenticator,
            product[_id][_serial].publisher, product[_id][_serial].seller, product[_id][_serial].owner, product[_id][_serial].price);
    }


    function getItem (uint256 _id, uint256 _serial) public view returns (
        string memory title,
        string memory description,
        uint256 version,
        string memory contentHash,
        uint256 serialNumber,
        string memory link
    ) {
        return (product[_id][_serial].title, product[_id][_serial].description, product[_id][_serial].version, contentsForSale[_id].authHash,product[_id][_serial].serialNumber, product[_id][_serial].link);
    }
    
    
}