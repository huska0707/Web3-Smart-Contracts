// SPDX-License-Identifier: MIT
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

    function depositMoney() public payable onlyOwner {
        require(msg.value > 0, "check balance once");
    }

    function registerEmployee(
        address _employeeAdd,
        uint _salary
    ) public onlyOwner {
        require(_salary > 0, "Enter the salary of employee");
        require(
            salaryInfo[_employeeAdd] == 0,
            "You can't Register employee twice"
        );
        company_Wallet[id] = Employee(_employeeAdd, _salary);
        salaryInfo[_employeeAdd] = _salary;
        ++id;
    }
}
