pragma solidity ^0.5.0;

import "./AccessControl/Roles.sol";

contract DCSSC is Roles {
     
    constructor () public {
        DCSSCowner = msg.sender;
        newDCSSC = address(0);
        commision = 0;
    }
    
    function() external payable {}
    
}