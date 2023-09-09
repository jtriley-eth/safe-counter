// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

interface ICounterHookReceiver {
    function onIncrement(uint256 oldCount, uint256 newCount) external;
    function onDecrement(uint256 oldCount, uint256 newCount) external;
}
