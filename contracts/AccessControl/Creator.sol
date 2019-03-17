pragma solidity ^0.5.0;

import "../Ownable/Ownable.sol";

contract CreatorRole is Ownable {

    event ItemCreated(uint256 id, address _address);
    event ContentPutForSale(uint256 id, uint256 price, uint256 royality);
    
    function createItem (string memory _title, string memory _desc, uint256 _version, string memory _hash, string memory _link) public returns (uint256 id, uint256 serial, string memory title) {
        if (newDCSSC == address(0)){
        uint256 _count = contentCounter;
        Content memory item = Content(_title,_desc,_version,_hash,0,_link,msg.sender,address(0),address(0),address(0),msg.sender,0);
        product[_count][0] = item;
        contentCounter++;
        emit ItemCreated(_count, msg.sender);
        return (_count, 0, product[_count][0].title);
        }
    }

    function putContentForSale (uint256 _id, uint256 _price, uint256 _royality) public {
        if ((msg.sender == product[_id][0].creator) && (product[_id][0].publisher == address(0)) && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == false) ) {
            contentsForSale[_id].id = _id;
            contentsForSale[_id].auction = true;
            contentsForSale[_id].price = _price;
            contentsForSale[_id].royality = _royality;
            contentsForSale[_id].currentSerial = 1;
            emit ContentPutForSale(_id,_price,_royality);
        }
    }
    

}