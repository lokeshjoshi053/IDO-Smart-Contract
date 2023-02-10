// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract Auction {
    address public seller;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public endTime;

    event NewBid(address bidder, uint256 bid);
    event AuctionEnded(address winner, uint256 winningBid);

    constructor(uint256 auctionDuration) {
        seller = msg.sender;
        endTime = block.timestamp + auctionDuration;
    }

    function bid() public payable {
        require(msg.value > highestBid, "Bid must be higher than current highest bid");
        require(block.timestamp <= endTime, "Auction has already ended");
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit NewBid(msg.sender, msg.value);
    }

    function endAuction() public {
        require(msg.sender == seller, "Only the seller can end the auction");
        require(block.timestamp >= endTime, "Auction has not yet ended");
        require(highestBid > 0, "No bids were made in the auction");
        highestBidder.transfer(highestBid);
        emit AuctionEnded(highestBidder, highestBid);
    }
}
