// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract BBD_SecurityFundContract {
    address public owner;
    address public mainContract;

    constructor() {
        owner = msg.sender;
    }
    
    function IsOwner() internal view returns (bool)
    {
        return msg.sender == owner;
    }

    modifier onlyMainContract() {
        require(msg.sender == mainContract, "Only MainContract");
        _;
    }

    function setMainContract(address _contract) external {
        require(IsOwner(), "Only owner");
        mainContract = _contract;
    }

    function TransferTokens(address token, address user, uint256 amount) external onlyMainContract {
        if (token == address(0)) {
            payable(user).transfer(amount);
        } else {
            IERC20(token).transfer(user, amount);
        }
    }

    // Accept native deposits
    receive() external payable {}
}
