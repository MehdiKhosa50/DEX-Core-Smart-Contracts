// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    function getAmountsOut(uint amountIn, address[] calldata path) 
        external view returns (uint[] memory amounts);
}

contract BatchLimitOrderRouter is Ownable(msg.sender) {
    IUniswapV2Router public immutable router;
    
    struct Order {
        address maker;
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint256 minAmountOut;
        uint256 deadline;
    }
    
    event OrderExecuted(
        address indexed maker,
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut,
        bool success,
        string reason
    );

    constructor(address _router) {
        router = IUniswapV2Router(_router);
    }

    function executeOrder(Order memory order) internal returns (bool) {
        // Check deadline
        if (block.timestamp > order.deadline) {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                0,
                false,
                "Order expired"
            );
            return false;
        }

        IERC20 tokenIn = IERC20(order.tokenIn);
        
        // Check allowance
        uint256 allowance = tokenIn.allowance(order.maker, address(this));
        if (allowance < order.amountIn) {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                0,
                false,
                "Insufficient allowance"
            );
            return false;
        }

        // Check balance
        uint256 balance = tokenIn.balanceOf(order.maker);
        if (balance < order.amountIn) {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                0,
                false,
                "Insufficient balance"
            );
            return false;
        }
        
        // Check expected output amount
        address[] memory path = new address[](2);
        path[0] = order.tokenIn;
        path[1] = order.tokenOut;
        
        try router.getAmountsOut(order.amountIn, path) returns (uint[] memory amounts) {
            if (amounts[1] < order.minAmountOut) {
                emit OrderExecuted(
                    order.maker,
                    order.tokenIn,
                    order.tokenOut,
                    order.amountIn,
                    0,
                    false,
                    "Price too low"
                );
                return false;
            }
        } catch {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                0,
                false,
                "Error checking price"
            );
            return false;
        }
        
        // Transfer tokens from maker to this contract
        try tokenIn.transferFrom(order.maker, address(this), order.amountIn) returns (bool success) {
            if (!success) {
                emit OrderExecuted(
                    order.maker,
                    order.tokenIn,
                    order.tokenOut,
                    order.amountIn,
                    0,
                    false,
                    "Transfer failed"
                );
                return false;
            }
        } catch {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                0,
                false,
                "Transfer failed"
            );
            return false;
        }
        
        // Approve router
        try tokenIn.approve(address(router), order.amountIn) {
        } catch {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                0,
                false,
                "Approval failed"
            );
            return false;
        }
        
        // Execute swap
        try router.swapExactTokensForTokens(
            order.amountIn,
            order.minAmountOut,
            path,
            order.maker,
            order.deadline
        ) returns (uint[] memory amounts) {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                amounts[1],
                true,
                "Success"
            );
            return true;
        } catch {
            emit OrderExecuted(
                order.maker,
                order.tokenIn,
                order.tokenOut,
                order.amountIn,
                0,
                false,
                "Swap failed"
            );
            return false;
        }
    }
    
    function executeBatchOrders(Order[] memory orders) external onlyOwner returns (bool[] memory results) {
        results = new bool[](orders.length);
        
        for (uint i = 0; i < orders.length; i++) {
            results[i] = executeOrder(orders[i]);
        }
        
        return results;
    }
    
    // Emergency function to recover stuck tokens
    function rescueTokens(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner(), amount);
    }
}