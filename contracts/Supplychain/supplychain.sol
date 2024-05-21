//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9
pragma experimental ABIEncoderV2;

contract Supplychain {
    struct S_Item {
        uint256 _index;
        string _identifier;
        uint256 _priceInWei;
    }

    mapping(uint256 => ProductDetails) public productData;

    S_Item[] public productArr;

    mapping(uint256 => S_Item) public items;

    uint256 index;

    enum SupplyChainSteps {
        Created,
        Paid,
        Delivered
    }
}