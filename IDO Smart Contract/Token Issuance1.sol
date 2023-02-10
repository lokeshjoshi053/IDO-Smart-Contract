// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Token {
    // Token name
    string public name = "My Token";
    // Token symbol
    string public symbol = "MYT";
    // Token decimals
    uint8 public decimals = 18;
    // Total supply of tokens
    uint256 public totalSupply;
    // Balance of each account
    mapping (address => uint256) public balanceOf;
    // Event to track token transfers
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Function to create the initial supply of tokens
    constructor()  {
        totalSupply = 1000000000 * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
    }

    // Function to transfer tokens from one account to another
    function transfer(address recipient, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }
}
