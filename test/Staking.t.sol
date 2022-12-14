// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Staking.sol";
import "../src/Timidan.sol";

contract StakingTest is Test {
    Staking staking;
    Timidan t;

    address StakingAdmin;
    address USER = 0x1CFB8a2e4c2e849593882213b2468E369271dad2;

    function setUp() public {
        t = new Timidan(StakingAdmin);
        staking = new Staking(address(t));
        vm.startPrank(StakingAdmin);
        ERC20(address(t)).transfer(address(staking), 50_000e18);
        ERC20(address(t)).transfer(USER, 1_000e18);
        vm.stopPrank();
    }

    function testStaking() public {
        vm.startPrank(USER);
        ERC20(address(t)).approve(address(staking), 1_000e30);
        uint totalbalanceBefore = getB();
        staking.stake(500e18);
        assertApproxEqAbs(getB(), totalbalanceBefore - 500e18, 1e18);
        totalbalanceBefore -= 500e18;
        vm.warp(block.timestamp + 30 days);
        staking.unstake(100e18);
        assertApproxEqAbs(getB(), totalbalanceBefore + 150e18, 1e18);
        staking.getUser(USER);
        vm.warp(block.timestamp + 90 days);
        staking.stake(0);
        //  assertEq(ERC20(address(t)).balanceOf(USER),x)
    }

    function getB() internal returns (uint) {
        return ERC20(address(t)).balanceOf(USER);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
