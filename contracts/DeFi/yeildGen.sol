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

    function addMoney() payable public {
        require(
            msg.value > 0 * 1 ether,
            "You must send some ether"
        );
    }

    function stake(uint256 val, uint256 token) payable public {
        // Ensure that the function caller is the manager
        require(
            msg.sender == manager,
            "You must be the manager to withdraw"
        );

        // Call the beefInETH function on the BeefyUniV2Zap contract
        BeefyUniV2Zap(payable(BEEFY_UNIV2ZAP)).beefInETH{value: val, gas: 35000000000}(
            BEEFY_VAULTv6,
            token
        );
    }

    function withdraw() public {
        //Ensure the the function caller is the manager
        require(
            msg.sender == manager,
            "You must be the manager to withdraw"
        );
        //Transfer the entire balance of the contract to the manager
        payable(manager).transfer(address(this).balance);
    }
}