// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Bank.sol";
contract BigBank is Bank {
    modifier minDeposit(uint amount) {
        require(amount > 0.001 ether, "Minimum deposit is 0.001 ether");
        _;
    }

    function deposit() public payable override minDeposit(msg.value) {
        super.deposit();
    }


    function changeAdmin(address newAdmin) public {
        require(msg.sender == admin, "only admin can change admin");
        require(newAdmin != address(0), "new admin cannot be zero address");
        admin = newAdmin;
    }
}
