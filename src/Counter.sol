// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import "./interfaces/ICounterImplementor.sol";
import "./interfaces/ICounterHookReceiver.sol";

error Overflow(uint256 count);
error Underflow(uint256 count);
error Blocklist(address actor);

struct Counter {
    uint256 __inner;
    mapping(address => bool) __blockList;
}

using {increment, safeIncrement, decrement, safeDecrement, current, isBlocked, requireNotBlocked} for Counter global;

function current(Counter storage counter) view returns (uint256) {
    return counter.__inner;
}

function isBlocked(Counter storage counter, address account) view returns (bool) {
    return counter.__blockList[account];
}

function requireNotBlocked(Counter storage counter, address account) view returns (Counter storage) {
    if (counter.isBlocked(account)) revert Blocklist(account);
    return counter;
}

function sanction(Counter storage counter, address account) returns (Counter storage) {
    counter.__blockList[account] = true;
    return counter;
}

function increment(Counter storage counter) returns (Counter storage) {
    return safeIncrement(counter, ICounterHookReceiver(address(0)));
}

function safeIncrement(Counter storage counter, ICounterHookReceiver receiver) returns (Counter storage) {
    requireNotBlocked(counter, msg.sender);
    if (counter.__inner == type(uint256).max) revert Overflow(counter.current());
    counter.__inner += 1;
    receiver.onIncrement(counter.current() - 1, counter.current());
    emit ICounterImplementor.Increment(counter.current() - 1, counter.current());
    return counter;
}

function decrement(Counter storage counter) returns (Counter storage) {
    return safeDecrement(counter, ICounterHookReceiver(address(0)));
}

function safeDecrement(Counter storage counter, ICounterHookReceiver receiver) returns (Counter storage) {
    requireNotBlocked(counter, msg.sender);
    if (counter.current() == 0) revert Underflow(counter.current());
    counter.__inner -= 1;
    receiver.onIncrement(counter.current() + 1, counter.current());
    emit ICounterImplementor.Decrement(counter.current() + 1, counter.current());
    return counter;
}
