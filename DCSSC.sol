pragma solidity ^0.5.0;

contract DCSSC {
    
    address DCSSCowner;
    address newDCSSC;
    int256 commision;
    //contentForSale
    //contentMassSale
    //itemForSale
    struct Content {
        string title;
        string description;
        int256 version;
        string contentHash;
        int256 serialNumber;
        string link;
        address creator;
        address owner;
        address publisher;
        address seller;
        int256 price;
        int256 royality;
    }
    
    Content[] Product;

    
    function() external payable {}
    
}