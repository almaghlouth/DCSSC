pragma solidity ^0.5.0;

import "../Base/Base.sol";

contract Ownable is Base {
    
    address payable DCSSCowner;
    address newDCSSC;
    uint256 commision;
    
    modifier onlyOwner {
        require(msg.sender == DCSSCowner);
        _;
    }
    
    function setDCSSCOwner (address payable _address) onlyOwner public {
        DCSSCowner = _address;
    }
    
    function getDCSSCOwner () public view returns (address payable) {
        return DCSSCowner;
    }
    
    function setCommision (uint256 _commision) onlyOwner public {
        commision = _commision;
    }
    
    function getCommision () public view returns (uint)  {
        return commision;
    }
    
    function setNewDCSSC (address _newDCSSC) onlyOwner public {
        newDCSSC = _newDCSSC;
    }
    
    function getNewDCSSC () public view returns (address)  {
        return newDCSSC;
    }

    
}