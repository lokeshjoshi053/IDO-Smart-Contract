// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract TokenLockup {
    uint256 public totalLocked;
    mapping (address => uint256) public lockedBalanceOf;
    mapping (address => uint256) public lockupExpiry;

    event TokenLocked(address indexed account, uint256 value, uint256 expiry);
    event TokenUnlocked(address indexed account, uint256 value);

    function lock(uint256 value, uint256 expiry) public {
        require(value > 0, "Invalid lockup amount");
        require(expiry >= block.timestamp + 1 minutes, "Expiry must be at least 1 minute in the future");
        require(lockedBalanceOf[msg.sender] + value <= totalLocked + value, "Lockup amount exceeds balance");

        lockedBalanceOf[msg.sender] += value;
        lockupExpiry[msg.sender] = expiry;
        totalLocked += value;
        emit TokenLocked(msg.sender, value, expiry);
    }

    function unlock() public {
        require(lockupExpiry[msg.sender] <= block.timestamp + 1 minutes, "Lockup period has not yet expired");
        uint256 value = lockedBalanceOf[msg.sender];

        lockedBalanceOf[msg.sender] = 0;
        lockupExpiry[msg.sender] = 0;
        totalLocked -= value;

        emit TokenUnlocked(msg.sender, value);
    }
}

