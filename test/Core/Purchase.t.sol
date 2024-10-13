// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "../TestSetup.sol";

contract PurchaseTests is TestSetup {

    event GoldPurchased(address indexed buyer, uint256 numberOfTokens);

    function setUp() public {
        setUpTests();
    }

    function test_Purchase() public {
        uint256 usdcWhaleBalance = IERC20(mainnetUsdc).balanceOf(usdcWhale);
        assertEq(tokenization1155Contract.balanceOf(usdcWhale, 1), 0);

        (, int256 answer,,,) = goldPriceFeed.latestRoundData();
        uint256 amountToPayInUsdc = uint256(answer) / 100;
        uint256 amountToPayTotal = (amountToPayInUsdc * 10) / tokenization1155Contract.TOKENS_PER_OUNCE();

        console.log("Chainlink Gold price: ", uint256(answer));
        console.log("Amount to pay in USDC: ", amountToPayInUsdc);

        vm.startPrank(usdcWhale);
        IERC20(mainnetUsdc).approve(address(coreContract), amountToPayTotal);
        vm.expectEmit(true, true, false, false);
        emit GoldPurchased(usdcWhale, 10);
        coreContract.purchase(10);

        assertEq(tokenization1155Contract.balanceOf(usdcWhale, 1), 10);
        assertEq(IERC20(mainnetUsdc).balanceOf(usdcWhale), usdcWhaleBalance - amountToPayTotal);
    }
}