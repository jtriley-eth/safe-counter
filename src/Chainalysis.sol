// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import "./interfaces/ISanctionsList.sol";

error SanctionedAddress(address actor);
error SanctionsListNotSupported(uint256 chainId);

ISanctionsList constant SanctionsList = ISanctionsList(0x40C57923924B5c5c5455c48D93317139ADDaC8fb);

/**
 * @dev The "magic" modulus 13 is used to reduce each 2 byte chain id
 *      to something that can be used as an offset into a lookup table
 *      with a reasonable size in memory. Each supported chain id is
 *      stored at byte `(chainId % 13) * 2`.
 *
 *      ==============================================
 *      | Network         | Position (chainId % 13)  |
 *      ==============================================
 *      | Mainnet         | 0x01 % 13 = 1            |
 *      | Arbitrum        | 0xa4b1 % 13 = 2          |
 *      | Fantom          | 0xfa % 13 = 3            |
 *      | BNB Smart Chain | 0x38 % 13 = 4            |
 *      | Avalanche       | 0xa86a % 13 = 6          |
 *      | Polygon         | 0x89 % 13 = 7            |
 *      | Celo            | 0xa4ec % 13 = 9          |
 *      | Optimism        | 0x0a % 13 = 10           |
 *      ==============================================
 */
uint256 constant ChainIdLookupTable = (0x0001 << 16) | (0xa4b1 << 32) | (0x00fa << 48) | (0x0038 << 64) | (0xa86a << 96)
    | (0x0089 << 112) | (0xa4ec << 144) | (0x000a << 160);

// Checks whether the Chainalysis sanctions list is deployed
// on the current chain.
function isSanctionsListSupported(uint256 chainId) pure returns (bool supportedChainId) {
    assembly {
        // Lookup `chainId % 13` in the lookup table and verify it matches
        // the chainId.
        supportedChainId := eq(chainId, and(0xffff, shr(shl(4, mod(chainId, 13)), ChainIdLookupTable)))
    }
}

// Checks if an address is on a sanctions list according to Chainalysis.
function isSanctioned(address account) view returns (bool) {
    if (!isSanctionsListSupported(block.chainid)) {
        revert SanctionsListNotSupported(block.chainid);
    }
    return SanctionsList.isSanctioned(account);
}
