// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Lottery {
    // Address of the manager who deployed the contract
    address public manager;

    // Array to store the addresses of players who entered the lottery
    address[] public players;

    // Modifier to restrict access to certain functions
    modifier restricted() {
        require(
            msg.sender == manager,
            "Only the manager can access this function"
        );
        _;
    }

    // Constructor to set the manager to the address deploying the contract
    constructor() {
        manager = msg.sender;
    }

    // Function for players to enter the lottery by sending ether
    function enter() public payable {
        // Require that the sent ether is greater than 0.005 ether
        require(
            msg.value > 0.005 ether,
            "Insufficient ether sent to enter the lottery"
        );

        // Add the sender's address to the players array
        players.push(msg.sender);
    }

    // Function to retrieve the array of player addresses
    function playersData() public view returns (address[] memory) {
        return players;
    }

    // Function to generate a pseudo-random number based on block information and players array
    function random() public view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    // Function for the manager to pick a winner randomly
    function pickWinner() public restricted {
        // Generate a random index within the range of the players array
        uint index = random() % players.length;

        // Transfer the contract's balance to the randomly picked player
        payable(players[index]).transfer(address(this).balance);

        // Reset the players array for the next round of lottery
        players = new address;
    }
}
