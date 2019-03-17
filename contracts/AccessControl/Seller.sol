pragma solidity ^0.5.0;

import "../Ownable/Ownable.sol";

contract SellerRole is Ownable {

    

    event ContentMassBought(uint256 id, uint256 quantity, address _address);
    
    event ItemPutForSale(uint256 id, uint256 serial, address _address);

    function estimateMassSale (uint256 _id, uint256 _quantity) public view returns (uint256) {
        return ((product[_id][0].price) * (_quantity));
    }

    function checkStock (uint256 _id, address payable _address) public view returns (uint256) {
        return massBuyStock[_id][_address];
    }
    
    function buyMassSale (uint256 _id, uint256 _quantity) public payable returns (bool) {
        if ((contentsForSale[_id].massSale == true) && (estimateMassSale ( _id, _quantity) == msg.value)) {
            product[_id][0].publisher.transfer(msg.value);
            massBuyStock[_id][msg.sender] = _quantity;
            emit ContentMassBought(_id,_quantity, msg.sender);
            return true;
        }
        return false;
    }
    
    function sellItem (uint256 _id, uint256 _itemPrice) public returns (uint256 serialNumber) {
        if (checkStock(_id,msg.sender) > 0){
            uint256 _inc = contentsForSale[_id].currentSerial;
            product[_id][_inc] = product[_id][0];
            product[_id][_inc].seller = msg.sender;
            product[_id][_inc].owner = address(0);
            product[_id][_inc].price = _itemPrice + commision + contentsForSale[_id].royality;
            contentsForSale[_id].currentSerial++;
            massBuyStock[_id][msg.sender]--;
            emit ItemPutForSale(_id,_inc,msg.sender);
            return _inc;
        }
    }
    
}