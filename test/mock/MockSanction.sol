// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "../../src/SafeCounter.sol";

contract MockSanction {
    SafeCounter internal counter;

    function complyWithOfac(address actor) public {
        counter.sanction(actor);
    }

    function incrementSafeCounter() public {
        counter.increment();
    }
}
