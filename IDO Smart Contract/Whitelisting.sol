// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Whitelist {
    // List of approved addresses
    mapping (address => bool) public approved;
    // Event to track approvals
    event Approval(address indexed addr);
    // Event to track rejections
    event Rejection(address indexed addr);

    // Function to approve an address
    function approve(address addr) public {
        require(!approved[addr], "Address already approved");
        approved[addr] = true;
        emit Approval(addr);
    }

    // Function to reject an address
    function reject(address addr) public {
        require(!approved[addr], "Address already rejected or approved");
        emit Rejection(addr);
    }

    // Function to check if an address is approved
    function isApproved(address addr) public view returns (bool) {
        return approved[addr];
    }
}
