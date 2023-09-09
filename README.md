# SafeCounter

A counter library for the 21st century.

We implement OFAC compliant address blocking, checked arithmetic, hook integrations, method
chaining for a rust-like application programming interface, event logging optimized for indexing
software, and both incrementing and decrementing the count.

## Installation

```bash
forge install jtriley-eth/safe-counter
```

## Usage

```solidity
contract MyContract {
    Counter counter;

    function blockAndSafeIncrementTwice(address sanctionedEntity) public {
        counter.requireNotBlocked()
            .sanction(sanctionedEntity)
            .safeIncrement(msg.sender)
            .safeIncrement(msg.sender);
    }
}
```
