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
        uint256 version;
        string contentHash;
        uint256 serialNumber;
        string link;
        address creator;
        address owner;
        address publisher;
        address seller;
        uint256 price;
        uint256 royality;
    }
    
    uint contentCounter = 0;
    
    mapping(uint => mapping (uint => Content)) product;

    function createItem (string memory _title, string memory _desc, uint _version, string memory _hash, string memory _link, uint _price, uint _royality) public returns (uint id, string memory title) {
        uint256 _count = contentCounter;
        Content memory item = Content(_title,_desc,_version,_hash,0,_link,msg.sender,address(0),address(0),address(0),_price,_royality);
        product[_count][0] = item;
        contentCounter++;
        return (_count, product[_count][0].title);
    }

    function() external payable {}
    
}