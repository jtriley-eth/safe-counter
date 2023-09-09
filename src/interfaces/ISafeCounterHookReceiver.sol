// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface ISafeCounterHookReceiver {
    function onIncrement(uint256 oldCount, uint256 newCount) external;
    function onDecrement(uint256 oldCount, uint256 newCount) external;
}
