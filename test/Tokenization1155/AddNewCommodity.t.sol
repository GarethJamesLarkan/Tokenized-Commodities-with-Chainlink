// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;
import "../TestSetup.sol";

contract AddNewCommodityTests is TestSetup {

    event NewCommodityAdded(uint256 indexed commodityId, uint256 maxSupply);

    function setUp() public {
        setUpTests();
    }

    function test_OnlyOwnerCanAddNewCommodity() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(OwnableUnauthorizedAccount.selector, address(alice)));
        tokenization1155Contract.addNewCommodity(20_000);
    }

    function test_AddNewCommodityWorks() public {
        assertEq(tokenization1155Contract.commodityMaxSupply(0), 0);
        assertEq(tokenization1155Contract.commodityId(), 0);

        vm.startPrank(owner);
        vm.expectEmit(true, true, false, false);
        emit NewCommodityAdded(0, 20_000);
        tokenization1155Contract.addNewCommodity(20_000);

        assertEq(tokenization1155Contract.commodityMaxSupply(0), 20_000);
        assertEq(tokenization1155Contract.commodityId(), 1);
    }
}