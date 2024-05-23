pragma solidity ^0.8.0;

contract SalaryPaymentSystem {
    struct Employee {
        address employeeAdd;
        uint salary;
    }

    uint id;
    address owner;
    uint public finaltime;

    constructor() {
        owner = msg.sender;
        finaltime = block.timestamp + 30.42 days;
    }

    mapping(uint => Employee) company_Wallet;
    mapping(address => uint) salaryInfo;

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
    }

    function depositMoney() public payable onlyOwner {}
}
