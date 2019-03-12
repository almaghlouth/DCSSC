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
    
    mapping (uint256 => contentForSale) contentsForSale;
    
    mapping (uint256 => mapping (address => uint)) massBuyStock;
    
    modifier onlyOwner {
        require(msg.sender == DCSSCowner);
        _;
    }
    
    event ItemCreated(uint256 id, address _address);

    event ContentPutForSale(uint256 id);
    
    event ContentAuthenticated(uint256 id);
    
    event ContentAwarded(uint256 id);
    
    event ContentMassSale(uint256 id);
    
    event ContentMassBought(uint256 id, uint256 quantity, address _address);
    
    event ItemPutForSale(uint256 id, uint256 serial);
    
    event ItemSold(uint256 id, uint256 serial);
    
    constructor () public {
        DCSSCowner = msg.sender;
        newDCSSC = address(0);
        commision = 0;
    }
    
    mapping(uint256 => mapping (uint256 => Content)) product;

    function createItem (string memory _title, string memory _desc, uint256 _version, string memory _hash, string memory _link) public returns (uint256 id, uint256 serial, string memory title) {
        if (newDCSSC == address(0)){
        uint256 _count = contentCounter;
        Content memory item = Content(_title,_desc,_version,_hash,0,_link,msg.sender,address(0),address(0),address(0),msg.sender,0);
        product[_count][0] = item;
        contentCounter++;
        emit ItemCreated(_count, msg.sender);
        return (_count, 0, product[_count][0].title);
        }
    }
    
    function getItem (uint256 _id, uint256 _serial) public view returns (
        string memory title,
        string memory description,
        uint256 version,
        string memory contentHash,
        uint256 serialNumber,
        string memory link
    ) {
        return (product[_id][_serial].title, product[_id][_serial].description, product[_id][_serial].version, contentsForSale[_id].authHash,product[_id][_serial].serialNumber, product[_id][_serial].link);
    }
        
    function trackItem (uint256 _id, uint256 _serial) public view returns (
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
    
    function putContentForSale (uint256 _id, uint256 _price, uint256 _royality) public {
        if ((msg.sender == product[_id][0].creator) && (product[_id][0].publisher == address(0)) && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == false) ) {
            contentsForSale[_id].id = _id;
            contentsForSale[_id].auction = true;
            contentsForSale[_id].price = _price;
            contentsForSale[_id].royality = _royality;
            contentsForSale[_id].currentSerial = 1;
            emit ContentPutForSale(_id);
        }
    }
    
    function getContentForSale (uint256 _id) public view returns (
        uint256 id,
        bool auction,
        bool awarded,
        bool massSale,
        uint256 price,
        uint256 royality,
        string memory authHash
        ){
        return (contentsForSale[_id].id, contentsForSale[_id].auction,contentsForSale[_id].awarded,contentsForSale[_id].massSale,
        contentsForSale[_id].price,contentsForSale[_id].royality,contentsForSale[_id].authHash);
    }
    
    function authenticate (uint256 _id, string memory _hash) public {
        if ((keccak256(abi.encodePacked(_hash)) == keccak256(abi.encodePacked(product[_id][0].contentHash))) && (product[_id][0].authenticator == address(0)) && (contentsForSale[_id].auction == true)){
            contentsForSale[_id].authHash = _hash;
            product[_id][0].authenticator = msg.sender;
            emit ContentAuthenticated(_id);
        }
    }
    
    function buyContentForSale (uint256 _id) payable public returns (bool) {
        if ((msg.value >= contentsForSale[_id].price) && (product[_id][0].publisher == address(0)) 
        && (contentsForSale[_id].awarded == false) && (contentsForSale[_id].auction == true) ) {
            product[_id][0].creator.transfer(msg.value);
            contentsForSale[_id].awarded = true;
            product[_id][0].publisher = msg.sender;
            emit ContentAwarded(_id);
            return true;
        }
        return false;
    }
    
    function putMassSale (uint256 _id, uint256 _itemPrice) public {
        if ((product[_id][0].publisher == msg.sender) && (product[_id][0].authenticator != address(0)) && (contentsForSale[_id].awarded == true) && (contentsForSale[_id].massSale == false)) {
            product[_id][0].price = _itemPrice;
            contentsForSale[_id].massSale = true;
            emit ContentMassSale(_id);
        }
    }
    
    function estimateMassSale (uint256 _id, uint256 _quantity) public view returns (uint256) {
        return ((product[_id][0].price) * (_quantity));
    }

    function checkStock (uint256 _id, address payable _address) public view returns (uint256) {
        return massBuyStock[_id][_address];
    }
    
    function buyMassSale (uint256 _id, uint256 _quantity) public payable returns (bool) {
        if ((contentsForSale[_id].massSale == true) && (estimateMassSale ( _id, _quantity) == msg.value)) {
            product[_id][0].publisher.transfer(msg.value);
            massBuyStock[_id][msg.sender] = _quantity;
            emit ContentMassBought(_id,_quantity, msg.sender);
            return true;
        }
        return false;
    }
    
    function sellItem (uint256 _id, uint256 _itemPrice) public returns (uint256 serialNumber) {
        if (checkStock(_id,msg.sender) > 0){
            uint256 _inc = contentsForSale[_id].currentSerial;
            product[_id][_inc] = product[_id][0];
            product[_id][_inc].seller = msg.sender;
            product[_id][_inc].owner = address(0);
            product[_id][_inc].price = _itemPrice + commision + contentsForSale[_id].royality;
            contentsForSale[_id].currentSerial++;
            massBuyStock[_id][msg.sender]--;
            emit ItemPutForSale(_id,_inc);
            return _inc;
        }
    }
    
    function buyItem (uint256 _id, uint256 _serial) public payable returns (bool){
        if ((_serial != 0) && (product[_id][_serial].owner == address(0)) && (product[_id][_serial].price == msg.value)
        && (contentsForSale[_id].massSale == true) && (product[_id][_serial].seller != address(0))  ){
            DCSSCowner.transfer(commision);
            product[_id][_serial].creator.transfer(contentsForSale[_id].royality);
            product[_id][_serial].seller.transfer(msg.value - commision - contentsForSale[_id].royality);
            product[_id][_serial].owner = msg.sender;
            emit ItemSold(_id,_serial);
            return true;
        }
        return false;
    }
    
    function() external payable {}
    
}