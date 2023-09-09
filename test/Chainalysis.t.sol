// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "../src/Chainalysis.sol" as Chainalysis;
import "./mock/MockSanction.sol";

contract ChainalysisWrapper {
    function isSanctioned(address addr) external view returns (bool) {
        return Chainalysis.isSanctioned(addr);
    }
}

contract CounterTest is Test {
    MockSanction mockSanction;
    uint256[8] internal SupportedChainIds = [0x01, 0xa4b1, 0xfa, 0x38, 0xa86a, 0x89, 0xa4ec, 0x0a];
    ChainalysisWrapper internal chainalysis;

    function setUp() public {
        vm.etch(address(SanctionsList), type(MockSanction).runtimeCode);
        mockSanction = MockSanction(address(SanctionsList));
    }

    function testFuzzIsOfacCompliant(address sanctionedEntity) public {
        mockSanction.complyWithOfac(sanctionedEntity);
        vm.expectRevert(abi.encodePacked(SanctionsListNotSupported.selector, uint256(block.chainid)));
    }

    function testIsSanctionsListSupported() public {
        for (uint256 i; i < 8; i++) {
            assertEq(Chainalysis.isSanctionsListSupported(SupportedChainIds[i]), true);
        }
    }

    function testIsSanctioned(address sanctionedEntity) public {
        vm.expectRevert(abi.encodePacked(SanctionsListNotSupported.selector, uint256(block.chainid)));
        chainalysis.isSanctioned(sanctionedEntity);

        vm.chainId(SupportedChainIds[0]);
        assertEq(Chainalysis.isSanctioned(sanctionedEntity), false);
        mockSanction.complyWithOfac(sanctionedEntity);
        assertEq(Chainalysis.isSanctioned(sanctionedEntity), true);
    }
}
