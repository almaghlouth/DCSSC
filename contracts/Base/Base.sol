pragma solidity ^0.5.0;

contract Base {
    

    mapping (uint256 => contentForSale) contentsForSale;

    struct Content {
        string title;
        string description;
        uint256 version;
        string contentHash;
        uint256 serialNumber;
        string link;
        address payable creator;
        address authenticator;
        address payable publisher;
        address payable seller;
        address owner;
        uint256 price;
    }

    uint256 contentCounter = 0;

    struct contentForSale {
        uint256 id;
        bool auction;
        bool awarded;
        bool massSale;
        uint256 price;
        uint256 royality;
        string authHash;
        uint256 currentSerial;
    }
    
    mapping(uint256 => mapping (uint256 => Content)) product;

    mapping (uint256 => mapping (address => uint)) massBuyStock;
    
}