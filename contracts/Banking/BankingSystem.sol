pragma solidity ^0.8.0

contract BankingSystem {
    mapping(address => uint256) public balanceOf;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
    }
}