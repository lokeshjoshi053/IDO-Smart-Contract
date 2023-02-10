// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract SolarCoin {
    mapping (address => uint256) private _balanceOf;
    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(uint256 initialSupply) public {
        require(initialSupply > 0, "Initial supply must be greater than 0");
        _totalSupply = initialSupply;
        _balanceOf[msg.sender] = initialSupply;
    }

    //Alternatively, you can make the contract abstract:

abstract contract SolarCoin {
    uint256 _totalSupply;
    mapping (address => uint256) _balanceOf;

    constructor(uint256 initialSupply) public {
        require(initialSupply > 0, "Initial supply must be greater than 0");
        _totalSupply = initialSupply;
        _balanceOf[msg.sender] = initialSupply;
    }
}

    function distribute(address to, uint256 value) public {
        require(isValidTransfer(msg.sender, to, value), "Invalid transfer");
        _balanceOf[msg.sender] -= value;
        _balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function isValidTransfer(address from, address to, uint256 value) private view returns (bool) {
        return _balanceOf[from] >= value && value > 0 && from != address(0) && to != address(0);
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balanceOf[account];
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
}
