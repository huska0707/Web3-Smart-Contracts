pragma solidity ^0.8.0;

contract Record {
    address public owner;
    address[] public patientList;
    address[] public doctorList;
    address[] public appointmentList;

    constructor() {
        owner = msg.sender;
    }
}