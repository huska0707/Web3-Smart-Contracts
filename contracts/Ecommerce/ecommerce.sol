pragma solidity ^0.8.9;

contract Ecommerce {
    struct Product {
        string title;
        string description;
        address payable seller;
        uint productId;
        address buyer;
        bool delivered;
    }

    Product [] public products;
    uint counter = 0;
    
}
