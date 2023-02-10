// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract TokenSale {
    uint256 public totalSupply;
    uint256 public tokenPrice;
    uint256 public soldTokens = 0;
    uint256 public raisedEther = 0;
    uint256 public tokenSaleCap;
    uint256 public saleDuration;

    address public owner;

constructor(uint256 _totalSupply, uint256 _tokenPrice, uint256 _tokenSaleCap, uint256 _saleDuration) {
    totalSupply = _totalSupply;
    tokenPrice = _tokenPrice;
    tokenSaleCap = _tokenSaleCap;
    saleDuration = _saleDuration;
    owner = msg.sender;
}

function buyTokens() public payable {
    require(soldTokens < tokenSaleCap, "Token sale cap reached");
    require(block.timestamp < saleDuration, "Token sale is over");
    require(msg.value >= tokenPrice, "Not enough ether sent");

    uint256 tokens = msg.value / tokenPrice;
    require(soldTokens + tokens <= totalSupply, "Not enough tokens available for sale");

    raisedEther += msg.value;
    soldTokens += tokens;

    msg.sender.transfer(tokens);
}

function endSale() public {
    require(msg.sender == owner, "Only owner can end the sale");
    require(now >= saleDuration, "Sale has not ended yet");

    selfdestruct(owner);
}
}