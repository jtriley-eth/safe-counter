// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "../../src/SafeCounter.sol";

contract MockSanction {
    mapping(address => bool) public isSanctioned;

    function complyWithOfac(address actor) public {
        isSanctioned[actor] = true;
    }
}
