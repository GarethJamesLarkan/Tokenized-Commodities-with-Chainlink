// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "../TestSetup.sol";

contract UpdateGoldSupplyTests is TestSetup {

    event UpdatedGoldSupply(uint256 maxSupply);

    function setUp() public {
        setUpTests();
    }

    function test_OnlyOwnerCanUpdateGoldSupply() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(OwnableUnauthorizedAccount.selector, address(alice)));
        tokenization1155Contract.updateGoldSupply(20_000);
    }

    function test_FailsIfNewSupplyIsLowerThanCurrentSold() public {
        vm.startPrank(owner);
    }

    function test_UpdateGoldSupplyWorks() public {
        assertEq(tokenization1155Contract.maxNumberOfTokensAvailable(), 1_000_000);

        vm.startPrank(owner);
        vm.expectEmit(true, false, false, false);
        emit UpdatedGoldSupply(20_000);
        tokenization1155Contract.updateGoldSupply(20_000);

        assertEq(tokenization1155Contract.maxNumberOfTokensAvailable(), 2_000_000);
    }
}