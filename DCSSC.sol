pragma solidity ^0.5.0;

contract DCSSC {
    
    address DCSSCowner;
    address newDCSSC;
    uint256 commision;
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
        address authenticator;
        address publisher;
        address seller;
        address owner;
        uint256 price;
    }
    
    struct contentForSale {
        uint id;
        bool auction;
        bool awarded;
        uint price;
        uint royality;
    }
    
    mapping (uint => contentForSale) contentsForSale;
    
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

    function createItem (string memory _title, string memory _desc, uint _version, string memory _hash, string memory _link) public returns (uint id, uint serial, string memory title) {
        uint256 _count = contentCounter;
        Content memory item = Content(_title,_desc,_version,_hash,0,_link,msg.sender,address(0),address(0),address(0),msg.sender,0);
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
        address authenticator,
        address publisher,
        address seller,
        address owner,
        uint256 price
    ) {
        return (product[_id][_serial].creator, product[_id][_serial].authenticator,
            product[_id][_serial].publisher, product[_id][_serial].seller, product[_id][_serial].owner, product[_id][_serial].price);
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
    
    //add event
    function putContentForSale (uint _id, uint _price, uint _royality) public {
        if ((msg.sender == product[_id][0].creator) && (product[_id][0].publisher == address(0)) && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == false) ) {
            contentsForSale[_id].id = _id;
            contentsForSale[_id].auction = true;
            contentsForSale[_id].price = _price;
            contentsForSale[_id].royality = _royality;
        }
    }
    
    //add event
    function authenticate (uint _id/*, string memory _hash*/) public {
        //if (keccak256(_hash) == keccak256(product[_id][0].contentHash)){
            product[_id][0].authenticator = msg.sender;
        //}
    }
    
    function() external payable {}
    
}