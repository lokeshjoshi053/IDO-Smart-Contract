// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract TokenVesting {
    mapping(address => uint256) public vestingBalances;
    mapping(address => uint256) public lastClaimTime;
    uint256 public totalVested;

    function vest(address investor, uint256 value, uint256 cliffDuration, uint256 vestingDuration) public {
        require(value > 0, "Vesting value must be greater than 0");
        require(vestingBalances[investor] + value > vestingBalances[investor], "Overflow in adding vesting balance");
        vestingBalances[investor] += value;
        lastClaimTime[investor] = now;
        require(totalVested + value > totalVested, "Overflow in adding total vested");
        totalVested += value;
    }

    function release(address investor) public {
        uint256 vestingRemaining = vestingBalances[investor];
        uint256 cliffEndTime = lastClaimTime[investor] + cliffDuration;
        uint256 vestingEndTime = lastClaimTime[investor] + vestingDuration;
        uint256 releasedAmount = 0;

        if (now >= vestingEndTime) {
             releasedAmount = vestingRemaining;
        } else if (now >= cliffEndTime) {
            uint256 vestingPeriod = vestingDuration - cliffDuration;
            releasedAmount = (now - cliffEndTime) * vestingRemaining / vestingPeriod;
        }

        require(vestingBalances[investor] >= releasedAmount, "Underflow in subtracting vesting balance");
        vestingBalances[investor] -= releasedAmount;
        require(totalVested >= releasedAmount, "Underflow in subtracting total vested");
        totalVested -= releasedAmount;

        // send the released tokens to the investor
        require(token.transfer(investor, releasedAmount), "Failed to transfer the released tokens");
   }

