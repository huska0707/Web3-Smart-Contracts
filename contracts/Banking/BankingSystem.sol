// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankingSystem {

    // Mapping to store the balance of each address
    mapping(address => uint256) public balanceOf;

    // Function to deposit ether into the sender's account
    function deposit() public payable {
        // Increase the balance of the sender by the amount of ether sent
        balanceOf[msg.sender] += msg.value;
    }

    // Function to withdraw a specified amount of ether from the sender's account
    function withdraw(uint _amount) public {
        // Ensure the sender has enough balance to withdraw the specified amount
        require(balanceOf[msg.sender] >= _amount, "Insufficent Funds");

        // Decrease the balance of the sender by the specified amount
        balanceOf[msg.sender] -= _amount;

        // Attempt to send the specified amount of ether to the sender
        (bool sent,) = msg.sender.call{value: _amount}("Sent");

        // Ensure the ether transfer was successful
        require(sent, "Failed to Complete");
    }

    // Function to transfer a specified amount of ether from the sender's account to another account
    function transferAmt(address payable _address, uint _amount) public {
        // Ensure the sender has enough balance to transfer the specified amount
        require(balanceOf[msg.sender] >= _amount, "Insufficent Funds");

        // Transfer the specified amount of ether to the specified address
        _address.transfer(_amount);
    }

}