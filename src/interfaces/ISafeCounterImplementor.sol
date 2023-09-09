// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface ISafeCounterImplementor {
    event Increment(uint256 indexed oldCount, uint256 indexed newCount);
    event Decrement(uint256 indexed oldCount, uint256 indexed newCount);
}
