// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract SolarCoin {
    uint256 public totalSupply;
    uint256 public reserveSupply;
    mapping (address => uint256) public balanceOf;
    address public reserveAddress;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        totalSupply += msg.value;
        reserveSupply += msg.value;
        reserveAddress.transfer(msg.value);   
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough balance.");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        msg.sender.transfer(amount);
        emit Transfer(this, msg.sender, amount);
    }

    function lock(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough balance.");
        balanceOf[msg.sender] -= amount;
        reserveSupply -= amount;
        msg.sender.transfer(amount);
        emit Transfer(this, msg.sender, amount);
    }
}
