// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "../TestSetup.sol";

contract PurchaseTests is TestSetup {

    event GoldPurchased(address indexed buyer, uint256 numberOfTokens);

    function setUp() public {
        setUpTests();
    }

    function test_FailsIfIncorrectFundsSentIn() public {
        vm.prank(alice);
        vm.expectRevert("Core: Incorrect Funds");
        coreContract.purchase{value: 0.1 ether}(10);
    }

    function test_Purchase() public {
        uint256 aliceBalance = alice.balance;
        assertEq(tokenization1155Contract.balanceOf(alice, 1), 0);

        (, int256 answer,,,) = goldPriceFeed.latestRoundData();
        uint256 amountToPay = (uint256(answer) * 10) / tokenization1155Contract.TOKENS_PER_OUNCE();

        vm.startPrank(alice);
        vm.expectEmit(true, true, false, false);
        emit GoldPurchased(alice, 10);
        coreContract.purchase{value: amountToPay}(10);

        assertEq(tokenization1155Contract.balanceOf(alice, 1), 10);
        assertEq(alice.balance, aliceBalance - amountToPay);
    }
}