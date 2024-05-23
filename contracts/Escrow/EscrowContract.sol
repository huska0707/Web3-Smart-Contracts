pragma solidity ^0.8.9;

contract Escrow {
    enum Status {
        OPEN,
        PENDING,
        DELIVERY,
        CONFIRMED,
        COMPLETED
    }

    address public buyer;
    address public seller;
    address public arbiter;
    uint256 public immutable arbiter_fee = 0.00001 ether;
    uint256 public balance;
    uint256 public totalItems;
    mapping(uint256 => ItemStruct) private items;
    mapping(uint256 => address) public ownerOf;
    mapping(uint256 => uint256) public priceOf;

    struct ItemStruct {
        uint256 itemId;
        uint256 price;
        address owner;
        Status status;
    }

    constructor() {
        arbiter = msg.sender;
        balance = 0;
        totalItems = 0;
    }

    event Action(
        uint256 itemId,
        string description,
        Status status,
        address indexed function_caller
    );

    function createNewItem(uint256 _price) external payable {
        require(msg.sender != arbiter, "Arbiter cannot create/sell item");
        require(msg.value >= arbiter_fee, "Arbiter fee not met");
        pay(arbiter, arbiter_fee);

        uint256 _itemId = totalItems + 1;
        totalItems++;
        ItemStruct storage item = items[_itemId];

        item.itemId = _itemId;
        item.price = _price;
        item.owner = msg.sender;
        item.status = Status.OPEN;

        ownerOf[_itemId] = msg.sender;
        priceOf[_itemId] = _price;
        seller = msg.sender;

        emit Action(_itemId, "New Item Created", Status.OPEN, msg.sender);
    }
    
    function orderItem(uint256 itemId) external payable {
        require(msg.sender != ownerOf[itemId], "Owner cannot buy his own item");
        require(msg.sender != arbiter, "Arbiter cannot order the item");
        require(
            msg.value >= priceOf[itemId],
            "Pay the correct price of the item"
        );

        items[itemId].status = Status.PENDING;

        buyer = msg.sender;

        //money for the item sent to the contract to be held till delivery
        balance += msg.value;

        emit Action(itemId, "Item Ordered", Status.PENDING, msg.sender);
    }

    function performDelivery(uint256 itemId) external {}

    function paySeller(uint256 itemId) external {}

    function pay(address payee, uint256 amount) internal {}
}
