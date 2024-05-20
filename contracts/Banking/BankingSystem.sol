pragma solidity ^0.8.0

contract BankingSystem {
    mapping(address => uint256) public balanceOf;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balanceOf[msg.sender] >= _amount, "Insufficent Funds");

        balanceOf[msg.sender] -= _amount;

        (bool sent,) = msg.sender.call{value: _amount}("sent")

        require(sent, "Failed to Complete")
    }
}