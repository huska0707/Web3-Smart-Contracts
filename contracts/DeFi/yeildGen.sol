pragma solidity ^0.8.0;

interface BeefyUniV2Zap {
    function beefInETH (address beefyVault, uint256 tokenAmountOutMin) external payable;
}

contract YieldGen {
    address private constant BEEFY_UNIV2ZAP = 0x540A9f99bB730631BF243a34B19fd00BA8CF315C;
    address private constant BEEFY_VAULTv6 = 0xdb15F201529778b5e2dfa52D41615cd1AB24c765;
    address public manager;

    constructor() {
        manager = msg.sender;
    }
}