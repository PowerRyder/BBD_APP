// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BBDToken is ERC20, Ownable {
    uint256 public constant TOTAL_SUPPLY = 10_000_000_000 * 1e18;
    uint256 public constant PUBLIC_SUPPLY = 1_000_000_000 * 1e18;
    uint256 public constant LOCKED_SUPPLY = TOTAL_SUPPLY - PUBLIC_SUPPLY;

    uint256 public immutable startTimestamp;
    uint256 public lastUnlockMonth;
    uint256 public totalUnlocked;

    address public liquidityListing = 0x7Ec13697D98925bA1dC2BcC705c071bd168B10C2;
    address public gameTreasury = 0x8de119e98707Ac240abA2cB77E83B29882A34357;
    address public marketing = 0x03499C18F7265BE9AFDA16504A34CD1892F278AE;
    address public stakingReward = 0xcc234a1d3e32148461b7eaCb5a8bf4D0C4b6Be74;
    address public referralBonus = 0xCeEA0E87B553bc445C5Eb2242b5F28Cd81B4ACaA;
    address public awardBonus = 0x7E23E2781a1Da5DACe87b4f0e7bf68191263Fc32;

    event TokensUnlocked(uint256 month, uint256 amountPerWallet, uint256 totalUnlocked);

    constructor(address owner_) ERC20("BBD Token", "BBD") Ownable(owner_) {
        _mint(owner_, PUBLIC_SUPPLY);          // 1 billion to owner
        _mint(address(this), LOCKED_SUPPLY);   // 9 billion stays locked in contract

        startTimestamp = block.timestamp;
        lastUnlockMonth = 0;
    }

    function unlockTokens() external onlyOwner {
        require(totalUnlocked < LOCKED_SUPPLY, "All tokens already unlocked");

        uint256 monthsElapsed = (block.timestamp - startTimestamp) / 30 days;
        require(monthsElapsed > lastUnlockMonth, "No new month to unlock");

        uint256 tokensToUnlock = 0;

        for (uint256 m = lastUnlockMonth + 1; m <= monthsElapsed; m++) {
            if (m <= 3) {
                tokensToUnlock += (LOCKED_SUPPLY * 5) / 1000; // 0.5%
            } else if (m <= 6) {
                tokensToUnlock += (LOCKED_SUPPLY * 1) / 100; // 1%
            } else if (m <= 9) {
                tokensToUnlock += (LOCKED_SUPPLY * 2) / 100; // 2%
            } else {
                tokensToUnlock += (LOCKED_SUPPLY * 3) / 100; // 3%
            }
        }

        if (tokensToUnlock + totalUnlocked > LOCKED_SUPPLY) {
            tokensToUnlock = LOCKED_SUPPLY - totalUnlocked; // Adjust final unlock if exceeding
        }

        require(tokensToUnlock > 0, "Nothing to unlock");

        lastUnlockMonth = monthsElapsed;
        totalUnlocked += tokensToUnlock;

        uint256 share = tokensToUnlock / 6;

        _transfer(address(this), liquidityListing, share);
        _transfer(address(this), gameTreasury, share);
        _transfer(address(this), marketing, share);
        _transfer(address(this), stakingReward, share);
        _transfer(address(this), referralBonus, share);
        _transfer(address(this), awardBonus, share);

        emit TokensUnlocked(lastUnlockMonth, share, totalUnlocked);
    }

    function updateDistributionAddress(uint256 index, address newAddress) external onlyOwner {
        require(index >= 1 && index <= 6, "Invalid index");

        if(index == 1) liquidityListing = newAddress;
        else if(index == 2) gameTreasury = newAddress;
        else if(index == 3) marketing = newAddress;
        else if(index == 4) stakingReward = newAddress;
        else if(index == 5) referralBonus = newAddress;
        else if(index == 6) awardBonus = newAddress;
    }

    function getNextUnlockInfo() external view returns (uint256 month, uint256 amountTotal, uint256 perWallet) {
        uint256 m = lastUnlockMonth + 1;

        if (m <= 3) {
            amountTotal = (LOCKED_SUPPLY * 5) / 1000;
        } else if (m <= 6) {
            amountTotal = (LOCKED_SUPPLY * 1) / 100;
        } else if (m <= 9) {
            amountTotal = (LOCKED_SUPPLY * 2) / 100;
        } else {
            amountTotal = (LOCKED_SUPPLY * 3) / 100;
        }

        if (amountTotal + totalUnlocked > LOCKED_SUPPLY) {
            amountTotal = LOCKED_SUPPLY - totalUnlocked;
        }

        return (m, amountTotal, amountTotal / 6);
    }
}
