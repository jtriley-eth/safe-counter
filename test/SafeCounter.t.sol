// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "../src/SafeCounter.sol";
import "./mock/MockSanction.sol";

contract CounterTest is Test {
    MockSanction mockSanction;
    SafeCounter public counter;

    function setUp() public {
        vm.etch(address(SanctionsList), type(MockSanction).runtimeCode);
        mockSanction = MockSanction(address(SanctionsList));
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.current(), 1);
    }

    function testDecrement() public {
        counter.decrement();
        assertEq(counter.current(), 0);
    }

    function testFuzzIsOfacCompliant(address sanctionedEntity) public {
        mockSanction.complyWithOfac(sanctionedEntity);
        vm.expectRevert();
        counter.increment();
    }
}
