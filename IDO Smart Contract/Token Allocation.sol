// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract TokenAllocation {
    // Total supply of tokens
    uint256 public totalSupply;

    // Balance of each account
    mapping (address => uint256) public balanceOf;

    // Event to track token allocation
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Function to allocate tokens
    function allocateTokens(address recipient, uint256 amount) public {
        require(balanceOf[recipient] + amount <= totalSupply, "Token allocation exceeded total supply");
        balanceOf[recipient] += amount;
        totalSupply -= amount;
        emit Transfer(address(0), recipient, amount);
    }
}
