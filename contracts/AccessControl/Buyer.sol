pragma solidity ^0.5.0;

import "../Ownable/Ownable.sol";

contract BuyerRole is Ownable {

    event ItemSold(uint256 id, uint256 serial);

    function buyItem (uint256 _id, uint256 _serial) public payable returns (bool){
        if ((_serial != 0) && (product[_id][_serial].owner == address(0)) && (product[_id][_serial].price == msg.value)
        && (contentsForSale[_id].massSale == true) && (product[_id][_serial].seller != address(0))){
            DCSSCowner.transfer(commision);
            product[_id][_serial].creator.transfer(contentsForSale[_id].royality);
            product[_id][_serial].seller.transfer(msg.value - commision - contentsForSale[_id].royality);
            product[_id][_serial].owner = msg.sender;
            emit ItemSold(_id,_serial);
            return true;
        }
        return false;
    }
    
}