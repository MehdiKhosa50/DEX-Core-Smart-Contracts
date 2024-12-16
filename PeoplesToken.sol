// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PeoplesToken is ERC20, ERC20Burnable, Ownable {
    uint256 public constant INITIAL_MINT = 1000000 * (10 ** 18); // 1 million tokens
    uint256 public constant TOTAL_SUPPLY = 100000000 * (10 ** 18); // 100 million tokens
    uint256 public constant VESTING_AMOUNT = TOTAL_SUPPLY - INITIAL_MINT; // 99 million tokens
    uint256 public constant VESTING_DURATION = 4 * 365 days; // 4 years
    uint256 public constant VESTING_INTERVAL = 180 days; // Every 6 months

    uint256 public vestingStart;
    uint256 public lastVestedTime;
    uint256 public totalVested;

    constructor(address initialOwner)
        ERC20("PeoplesDEXToken", "PDT")
        Ownable(initialOwner)
    {
        _mint(initialOwner, INITIAL_MINT); // Mint initial 1 million tokens
        vestingStart = block.timestamp;
        lastVestedTime = vestingStart;
        totalVested = 0;
    }

    function releaseVestedTokens() public onlyOwner {
        require(block.timestamp >= vestingStart, "Vesting has not started yet");
        
        uint256 elapsedTime = block.timestamp - lastVestedTime;
        uint256 vestingPeriods = elapsedTime / VESTING_INTERVAL;

        require(vestingPeriods > 0, "No vesting period has passed");

        uint256 amountToVest = (VESTING_AMOUNT * vestingPeriods * VESTING_INTERVAL) / VESTING_DURATION;

        if (amountToVest + totalVested > VESTING_AMOUNT) {
            amountToVest = VESTING_AMOUNT - totalVested; // Prevent vesting more than the total vesting amount
        }

        require(amountToVest > 0, "No tokens to vest at this time");

        _mint(owner(), amountToVest); // Use owner() to get the current owner address
        totalVested += amountToVest;
        lastVestedTime += vestingPeriods * VESTING_INTERVAL;
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        _transferOwnership(newOwner);
    }
}