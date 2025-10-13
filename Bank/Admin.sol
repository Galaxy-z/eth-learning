// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IBank.sol";

contract Admin {
    address internal owner;

    constructor() {
        owner = msg.sender;
    }

    function adminWithdraw(IBank bank) public {
        require(msg.sender == owner, "only owner can withdraw");
        bank.withdraw();
    }
}