// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Mock {
    uint256 public value;
    function setValue(uint256 x) public returns (uint256) {
        value = x;
        return value;
    }
}