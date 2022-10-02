// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate.git/tokens/ERC20.sol";

contract Timidan is ERC20("Timidan", "TMD", 18) {
    constructor(address user) {
        _mint(user, 100000e18);
    }
}
