pragma solidity ^0.5.0;

contract DCSSC {
    
    address payable DCSSCowner;
    address newDCSSC;
    uint256 commision;
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
    
    modifier onlyOwner {
        require(msg.sender == DCSSCowner);
        _;
    }
    
    event ContentPutForSale(uint id);
    
    event ContentAuthenticated(uint id);
    
    event ContentAwarded(uint id);
    
    event ContentMassSale(uint id);
    
    event ContentMassBought(uint id, uint quantity);
    
    event ItemPutForSale(uint id, uint serial);
    
    event ItemSold(uint id, uint serial);
    
    constructor (uint _commision) public {
        DCSSCowner = msg.sender;
        newDCSSC = address(0);
        commision = _commision;
    }
    
    mapping(uint => mapping (uint => Content)) product;

    function createItem (string memory _title, string memory _desc, uint _version, string memory _hash, string memory _link) public returns (uint id, uint serial, string memory title) {
        if (newDCSSC != address(0)){
        uint256 _count = contentCounter;
        Content memory item = Content(_title,_desc,_version,_hash,0,_link,msg.sender,address(0),address(0),address(0),msg.sender,0);
        product[_count][0] = item;
        contentCounter++;
        return (_count, 0, product[_count][0].title);
        }
    }
    
    function getItem (uint _id, uint _serial) public view returns (
        string memory title,
        string memory description,
        uint256 version,
        string memory contentHash,
        uint256 serialNumber,
        string memory link
    ) {
        return (product[_id][_serial].title, product[_id][_serial].description, product[_id][_serial].version, contentsForSale[_id].authHash,product[_id][_serial].serialNumber, product[_id][_serial].link);
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
    
    function putContentForSale (uint _id, uint _price, uint _royality) public {
        if ((msg.sender == product[_id][0].creator) && (product[_id][0].publisher == address(0)) && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == false) ) {
            contentsForSale[_id].id = _id;
            contentsForSale[_id].auction = true;
            contentsForSale[_id].price = _price;
            contentsForSale[_id].royality = _royality;
            contentsForSale[_id].currentSerial = 1;
            emit ContentPutForSale(_id);
        }
    }
    
    function getContentForSale (uint _id) public view returns (
        uint id,
        bool auction,
        bool awarded,
        bool massSale,
        uint price,
        uint royality,
        string memory authHash
        ){
        return (contentsForSale[_id].id, contentsForSale[_id].auction,contentsForSale[_id].awarded,contentsForSale[_id].massSale,contentsForSale[_id].price,contentsForSale[_id].royality,contentsForSale[_id].authHash);
    }
    
    function authenticate (uint _id, string memory _hash) public {
        if ((keccak256(abi.encodePacked(_hash)) == keccak256(abi.encodePacked(product[_id][0].contentHash))) && (product[_id][0].authenticator == address(0))){
            contentsForSale[_id].authHash = _hash;
            product[_id][0].authenticator = msg.sender;
            emit ContentAuthenticated(_id);
        }
    }
    
    function buyContentForSale (uint _id) payable public  {
        if ((msg.value >= contentsForSale[_id].price) && (product[_id][0].publisher == address(0)) 
        && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == true) ) {
            product[_id][0].creator.transfer(msg.value);
            contentsForSale[_id].awarded = true;
            product[_id][0].publisher = msg.sender;
            emit ContentAwarded(_id);
        }
    }
    
    function putMassSale (uint _id, uint _itemPrice) public {
        if ((product[_id][0].publisher == msg.sender) && (product[_id][0].authenticator != address(0)) && (contentsForSale[_id].awarded == true) && (contentsForSale[_id].massSale == false)) {
            product[_id][0].price = _itemPrice + contentsForSale[_id].royality + commision;
            contentsForSale[_id].massSale = true;
            emit ContentMassSale(_id);
        }
    }
    
    function estimateMassSale (uint _id, uint _quantity) public view returns (uint total) {
        return (product[_id][0].price * _quantity);
    }
    
    function buyMassSale (uint _id, uint _quantity) public payable {
        if ((contentsForSale[_id].massSale == true) && (msg.value == estimateMassSale(_id,_quantity))) {
            product[_id][0].publisher.transfer(msg.value);
            massBuyStock[_id][msg.sender] = _quantity;
            emit ContentMassBought(_id,_quantity);
        }
    }
    
    function sellItem (uint _id, uint _itemPrice) public returns (uint serialNumber) {
        if (massBuyStock[_id][msg.sender] > 0){
            uint _inc = contentsForSale[_id].currentSerial;
            product[_id][_inc] = product[_id][0];
            product[_id][_inc].seller = msg.sender;
            product[_id][_inc].price = _itemPrice;
            contentsForSale[_id].currentSerial++;
            massBuyStock[_id][msg.sender]--;
            emit ItemPutForSale(_id,_inc);
            return _inc;
        }
    }
    
    function buyItem (uint _id, uint _serial) public payable {
        if ((_serial != 0) && (product[_id][_serial].owner == address(0)) && (product[_id][_serial].price == msg.value)
        && (contentsForSale[_id].massSale == true) && (product[_id][_serial].seller != address(0))  ){
            DCSSCowner.transfer(commision);
            product[_id][_serial].creator.transfer(contentsForSale[_id].royality);
            product[_id][_serial].seller.transfer(msg.value - commision - contentsForSale[_id].royality);
            product[_id][_serial].owner = msg.sender;
            emit ItemSold(_id,_serial);
        }
    }
    
    function() external payable {}
    
}