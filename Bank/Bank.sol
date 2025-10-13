// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IBank.sol";

contract Bank is IBank {
    constructor() {
        admin = msg.sender;
        topDepositors[0] = address(0);
        topDepositors[1] = address(0);
        topDepositors[2] = address(0);
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable override virtual  {
        require(msg.value > 0, "Please deposit more than 0 ether");
        balances[msg.sender] += msg.value;
        updateTop(msg.sender);
    }

    function withdraw() public override {
        require(msg.sender == admin, "only admin can withdraw");
        payable(admin).transfer(address(this).balance);
    }

    function updateTop(address user) private {
        if (user == address(0)) return;
        uint userBalance = balances[user];
        if (userBalance > topDepositorsBalances[2]) {
            uint index = 3;

            for (uint i = 0; i < 3; i++) {
                if (topDepositors[i] == user) {
                    for (uint j = i; j < 2; j++) {
                        topDepositors[j] = topDepositors[j + 1];
                        topDepositorsBalances[j] = topDepositorsBalances[j + 1];
                    }
                    topDepositors[2] = address(0);
                    topDepositorsBalances[2] = 0;
                    break;
                }
            }

            for (uint i = 0; i < 3; i++) {
                if (userBalance > topDepositorsBalances[i]) {
                    index = i;
                    break;
                }
            }

            for (uint i = 2; i > index; i--) {
                topDepositors[i] = topDepositors[i - 1];
                topDepositorsBalances[i] = topDepositorsBalances[i - 1];
            }
            topDepositors[index] = user;
            topDepositorsBalances[index] = userBalance;
        }
    }
}
