// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

interface ISanctionsList {
    function isSanctioned(address addr) external view returns (bool);
}
