// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract _WETH is ERC20, ERC20Burnable, Ownable {
    constructor(address initialOwner) ERC20("Wrapped VANRY", "WVANRY") Ownable(initialOwner) {}

    // Function to wrap VANRY into WVANRY
    function deposit() external payable {
        _mint(msg.sender, msg.value);
    }

    // Function to unwrap WVANRY back into VANRY
    function withdraw(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
    }

    // Function to allow the owner to withdraw any Ether accidentally sent to the contract
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Fallback function to handle direct Ether transfers
    fallback() external payable {
        _mint(msg.sender, msg.value);
    }

    // Receive function to handle plain Ether transfers
    receive() external payable {
        _mint(msg.sender, msg.value);
    }
}