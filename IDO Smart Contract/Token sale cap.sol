// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract TokenSale {
    uint256 public totalSupply;
    uint256 public tokenSaleCap;
    uint256 public soldTokens = 0;

constructor(uint256 _totalSupply, uint256 _tokenSaleCap) {
    totalSupply = _totalSupply;
    tokenSaleCap = _tokenSaleCap;
}

function buyTokens(uint256 _amount) public payable {
    require(soldTokens + _amount <= tokenSaleCap, "Token sale cap reached");
    require(soldTokens + _amount <= totalSupply, "Not enough tokens available for sale");
    require(msg.value >= _amount, "Not enough ether sent");

    soldTokens += _amount;
}
}
