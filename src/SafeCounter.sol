// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import "./interfaces/ISafeCounterImplementor.sol";
import "./interfaces/ISafeCounterHookReceiver.sol";

error Overflow(uint256 count);
error Underflow(uint256 count);
error Blocklist(address actor);

struct SafeCounter {
    uint256 __inner;
    mapping(address => bool) __blockList;
}

using {increment, safeIncrement, decrement, safeDecrement, current, isBlocked, requireNotBlocked, sanction} for SafeCounter global;

function current(SafeCounter storage counter) view returns (uint256) {
    return counter.__inner;
}

function isBlocked(SafeCounter storage counter, address account) view returns (bool) {
    return counter.__blockList[account];
}

function requireNotBlocked(SafeCounter storage counter, address account) view returns (SafeCounter storage) {
    if (counter.isBlocked(account)) revert Blocklist(account);
    return counter;
}

function sanction(SafeCounter storage counter, address account) returns (SafeCounter storage) {
    counter.__blockList[account] = true;
    return counter;
}

function increment(SafeCounter storage counter) returns (SafeCounter storage) {
    return safeIncrement(counter, ISafeCounterHookReceiver(address(0)));
}

function safeIncrement(SafeCounter storage counter, ISafeCounterHookReceiver receiver) returns (SafeCounter storage) {
    requireNotBlocked(counter, msg.sender);
    if (counter.__inner == type(uint256).max) revert Overflow(counter.current());
    counter.__inner += 1;
    receiver.onIncrement(counter.current() - 1, counter.current());
    emit ISafeCounterImplementor.Increment(counter.current() - 1, counter.current());
    return counter;
}

function decrement(SafeCounter storage counter) returns (SafeCounter storage) {
    return safeDecrement(counter, ISafeCounterHookReceiver(address(0)));
}

function safeDecrement(SafeCounter storage counter, ISafeCounterHookReceiver receiver) returns (SafeCounter storage) {
    requireNotBlocked(counter, msg.sender);
    if (counter.current() == 0) revert Underflow(counter.current());
    counter.__inner -= 1;
    receiver.onIncrement(counter.current() + 1, counter.current());
    emit ISafeCounterImplementor.Decrement(counter.current() + 1, counter.current());
    return counter;
}
