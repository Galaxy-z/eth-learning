// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

abstract contract IBank {
    address internal admin;

    mapping(address => uint) public balances;

    // 存款前三的用户地址
    address[3] public topDepositors;
    uint[3] public topDepositorsBalances;

    function deposit() public payable virtual;

    function withdraw() public virtual;
}