// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract SolarCoin {
    uint256 public totalSupply;
    uint256 public reserveSupply;
    mapping (address => uint256) public balanceOf;
    address payable public reserveAddress;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Swap(address indexed from, uint256 inAmount, address indexed to, uint256 outAmount);

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        totalSupply += msg.value;
        reserveSupply += msg.value;
        require(reserveAddress.send(msg.value), "Transfer failed");   
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
        require(msg.sender.send(amount), "Transfer failed");
        emit Transfer(this, msg.sender, amount);
    }

    function swap(address token, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough balance.");

        (bool success, uint256 outAmount) = address(token).call.value(amount)("swap");
        require(success, "Swap failed");

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        require(msg.sender.send(outAmount), "Transfer failed");
        emit Transfer(this, msg.sender, outAmount);
        emit Swap(msg.sender, amount, token, outAmount);
    }
}
   