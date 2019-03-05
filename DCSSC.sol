pragma solidity ^0.5.0;

contract DCSSC {
    
    address DCSSCowner;
    address newDCSSC;
    uint256 commision;
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
        address publisher;
        address seller;
        address owner;
        uint256 price;
        uint256 royality;
    }
    
    uint contentCounter = 0;
    
    modifier onlyOwner {
        require(msg.sender == DCSSCowner);
        _;
    }
    
    constructor (uint _commision) public {
        DCSSCowner = msg.sender;
        newDCSSC = address(0);
        commision = _commision;
    }
    
    mapping(uint => mapping (uint => Content)) product;

    function createItem (string memory _title, string memory _desc, uint _version, string memory _hash, string memory _link, uint _price, uint _royality) public returns (uint id, uint serial, string memory title) {
        uint256 _count = contentCounter;
        Content memory item = Content(_title,_desc,_version,_hash,0,_link,msg.sender,address(0),address(0),msg.sender,_price,_royality);
        product[_count][0] = item;
        contentCounter++;
        return (_count, 0, product[_count][0].title);
    }
    
    function getItem (uint _id, uint _serial) public view returns (
        string memory title,
        string memory description,
        uint256 version,
        string memory contentHash,
        uint256 serialNumber,
        string memory link
    ) {
        return (product[_id][_serial].title, product[_id][_serial].description, product[_id][_serial].version, product[_id][_serial].contentHash,product[_id][_serial].serialNumber, product[_id][_serial].link);
    }
        
    function trackItem (uint _id, uint _serial) public view returns (
        address creator,
        address publisher,
        address seller,
        address owner,
        uint256 price,
        uint256 royality
    ) {
        return (product[_id][_serial].creator, 
            product[_id][_serial].publisher, product[_id][_serial].seller,product[_id][_serial].owner, product[_id][_serial].price, product[_id][_serial].royality);
    }
    
    
    function setDCSSCOwner (address _address) onlyOwner public {
        DCSSCowner = _address;
    }
    
    function getDCSSCOwner () public view returns (address) {
        return DCSSCowner;
    }
    
    function setCommision (uint _commision) onlyOwner public {
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
    
    
    function() external payable {}
    
}