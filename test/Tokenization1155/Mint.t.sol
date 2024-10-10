// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "../TestSetup.sol";

contract MintTests is TestSetup {

    function setUp() public {
        setUpTests();
    }

    function test_FailsIfNotCoreContractCalling() public {
        vm.prank(alice);
        vm.expectRevert("Tokenization1155: Only Core Contract Can Mint Tokens");
        tokenization1155Contract.mint(alice, 1_000);
    }

    function test_FailsIfMaxSupplyReached() public {
        vm.prank(address(coreContract));
        vm.expectRevert("Tokenization1155: Max Supply Reached");
        tokenization1155Contract.mint(alice, 1_000_001);
    }

    function test_MintsTokensToUser() public {
        assertEq(tokenization1155Contract.balanceOf(alice, 1), 0);
        vm.prank(address(coreContract));
        tokenization1155Contract.mint(alice, 10_000);
        assertEq(tokenization1155Contract.balanceOf(alice, 1), 10_000);
    }
}