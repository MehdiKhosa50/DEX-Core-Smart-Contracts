# PeoplesDEX Core Contracts

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Core smart contracts for PeoplesDEX - A decentralized exchange protocol deployed on Vanar (Vanguard) testnet.

🌐 [Live Website](https://peoplesdex.vercel.app/)

## Overview

PeoplesDEX is a decentralized exchange featuring automated market making (AMM), yield farming, and staking capabilities. Built with a focus on efficiency and user experience, it allows users to trade tokens, provide liquidity, and participate in the DeFi ecosystem on Vanar testnet.

## Core Contracts

### PeoplesFactory
- Manages the creation of trading pairs
- Handles pair initialization and management
- Controls fee settings and protocol parameters

### PeoplesPair
- Implements the AMM logic
- Manages liquidity pools
- Handles swap execution
- Calculates price impact and slippage

### PeoplesRouter01
- Manages routing logic for trades
- Handles multi-hop swaps
- Provides price calculations
- Manages liquidity addition/removal

### WETH
- Wrapped native token contract
- Allows native token to be traded as ERC20
- Handles deposit/withdrawal of native currency

### MultiCall3
- Enables batch transactions
- Reduces gas costs for multiple operations
- Improves UX by bundling transactions

### PeoplesERC20
- Implementation for liquidity pool tokens (LP tokens)
- Handles minting/burning of LP tokens
- Manages LP token transfers

### PeoplesToken
- Native governance token of PeoplesDEX
- Used for protocol incentives
- Enables governance participation

## Features

- 🔄 Automated Market Making
- 💧 Liquidity Provision
- 🔀 Token Swapping
- 📊 Price Oracle Integration
- 🏭 Farming Capabilities
- 🔒 Security-First Design
- 🔨 Multi-token Support
- 📱 Mobile-Responsive Interface

## Technical Stack

- Solidity Smart Contracts
- OpenZeppelin Libraries
- Web3.js/Ethers.js Integration
- Hardhat Development Environment

## Security Features

- Reentrancy Guards
- Overflow Protection
- Access Controls
- Emergency Pause Functionality
- Price Impact Limits
- Slippage Protection

## Testing

```bash
npm install
npx hardhat run

Deployment
Contracts are deployed on Vanar (Vanguard) testnet. Detailed deployment instructions and addresses are available in the deployments directory.

Documentation
Detailed documentation including:

Technical specifications
Integration guides
API references
Security considerations
Available in the docs directory.

Audits
⚠️ These contracts are currently unaudited. Use at your own risk.

Contributing
Fork the repository
Create a feature branch
Commit changes
Push to branch
Create Pull Request
License
This project is licensed under the MIT License - see the LICENSE file for details.

Contact & Support
📧 Submit Issue
🌐 Website
Acknowledgments
Inspired by leading DEX protocols
Built with community feedback
Supported by Vanar ecosystem

Note: This is a testnet deployment. Exercise caution when interacting with smart contracts.