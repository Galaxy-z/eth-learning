// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 导入IERC20接口，用于与BERC20代币交互
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
}

contract TokenBank {
    IERC20 public token;
    mapping(address => uint256) public balances;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
    }
    function deposit(uint256 amount) public {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        require(token.transfer(msg.sender, amount), "Token transfer failed");
    }

}
