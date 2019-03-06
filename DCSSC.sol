pragma solidity ^0.5.0;

contract DCSSC {
    
    address payable DCSSCowner;
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
        address payable creator;
        address authenticator;
        address payable publisher;
        address payable seller;
        address owner;
        uint256 price;
    }
    
    uint contentCounter = 0;
    
    struct contentForSale {
        uint id;
        bool auction;
        bool awarded;
        bool massSale;
        uint price;
        uint royality;
        string authHash;
        uint currentSerial;
    }
    
    mapping (uint => contentForSale) contentsForSale;
    
    mapping (uint => mapping (address => uint)) massBuyStock;

    mapping (uint => mapping (uint => Content)) product;
    
    modifier onlyOwner {
        require(msg.sender == DCSSCowner);
        _;
    }
    
    constructor (uint _commision) public {
        DCSSCowner = msg.sender;
        newDCSSC = address(0);
        commision = _commision;
    }
    
    

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
    
    
    function setDCSSCOwner (address payable _address) onlyOwner public {
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
    
    function setNewDCSSC (address payable _newDCSSC) onlyOwner public {
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
            contentsForSale[_id].currentSerial = 1;
        }
    }
    
    function getContentForSale (uint _id) public view returns (
        uint id,
        bool auction,
        bool awarded,
        uint price,
        uint royality,
        string memory authHash
        ){
        return (contentsForSale[_id].id, contentsForSale[_id].auction,contentsForSale[_id].awarded,contentsForSale[_id].price,contentsForSale[_id].royality,contentsForSale[_id].authHash);
    }
    
    //add event
    function authenticate (uint _id, string memory _hash) public {
            contentsForSale[_id].authHash = _hash;
            product[_id][0].authenticator = msg.sender;
    }
    
    //add event
    function buyContentForSale (uint _id) payable public  {
        if ((msg.value >= contentsForSale[_id].price) && (product[_id][0].publisher == address(0)) 
        && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == true) ) {
            product[_id][0].creator.transfer(msg.value);
            contentsForSale[_id].awarded = true;
            product[_id][0].publisher = msg.sender; 
        }
    }
    
    //add event
    function putMassSale (uint _id, uint _itemPrice) public {
        if ((product[_id][0].publisher == msg.sender) && (contentsForSale[_id].awarded == true) && (contentsForSale[_id].massSale == false)) {
            product[_id][0].price = _itemPrice + contentsForSale[_id].royality + commision;
            contentsForSale[_id].massSale = true;
        }
    }
    
    function estimateMassSale (uint _id, uint _quantity) public view returns (uint total) {
        return (product[_id][0].price * _quantity);
    }
    
    //add event
    function buyMassSale (uint _id, uint _quantity) public payable {
        if ((contentsForSale[_id].massSale == true) && (msg.value == estimateMassSale(_id,_quantity))) {
            product[_id][0].publisher.transfer(msg.value);
            massBuyStock[_id][msg.sender] = _quantity;
        }
    }
    
    //add event
    function sellItem (uint _id, uint _itemPrice) public returns (uint serialNumber) {
        if (massBuyStock[_id][msg.sender] > 0){
            uint inc = contentsForSale[_id].currentSerial;
            product[_id][inc] = product[_id][0];
            product[_id][inc].seller = msg.sender;
            product[_id][inc].price = _itemPrice;
            contentsForSale[_id].currentSerial++;
            massBuyStock[_id][msg.sender]--;
            return inc;
        }
    }
    
    function buyItem (uint _id, uint _serial) public payable {
        if ((_serial != 0) && (product[_id][_serial].owner == address(0)) && (product[_id][_serial].price == msg.value)){
            DCSSCowner.transfer(commision);
            product[_id][_serial].creator.transfer(contentsForSale[_id].royality);
            product[_id][_serial].seller.transfer(msg.value - commision - contentsForSale[_id].royality);
            product[_id][_serial].owner = msg.sender;
        }
    }
    
    function() external payable {}
    
}