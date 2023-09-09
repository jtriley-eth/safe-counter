// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

interface ICounterImplementor {
    event Increment(uint256 indexed oldCount, uint256 indexed newCount);
    event Decrement(uint256 indexed oldCount, uint256 indexed newCount);
}
