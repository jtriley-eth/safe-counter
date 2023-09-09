// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import "./interfaces/ISafeCounterImplementor.sol";
import "./interfaces/ISafeCounterHookReceiver.sol";
import "./Chainalysis.sol";

error Overflow(uint256 count);
error Underflow(uint256 count);

struct SafeCounter {
    uint256 __inner;
}

using {increment, safeIncrement, decrement, safeDecrement, current, requireNotSanctioned} for SafeCounter global;

function current(SafeCounter storage counter) view returns (uint256) {
    return counter.__inner;
}

function requireNotSanctioned(SafeCounter storage counter, address account) view returns (SafeCounter storage) {
    if (isSanctioned(account)) revert SanctionedAddress(account);
    return counter;
}

function increment(SafeCounter storage counter) returns (SafeCounter storage) {
    return safeIncrement(counter, ISafeCounterHookReceiver(address(0)));
}

function safeIncrement(SafeCounter storage counter, ISafeCounterHookReceiver receiver) returns (SafeCounter storage) {
    requireNotSanctioned(counter, msg.sender);
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
    requireNotSanctioned(counter, msg.sender);
    if (counter.current() == 0) revert Underflow(counter.current());
    counter.__inner -= 1;
    receiver.onIncrement(counter.current() + 1, counter.current());
    emit ISafeCounterImplementor.Decrement(counter.current() + 1, counter.current());
    return counter;
}
