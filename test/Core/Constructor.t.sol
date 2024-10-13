// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "../TestSetup.sol";

contract CoreConstructorTests is TestSetup {

    function setUp() public {
        setUpTests();
    }

    function test_FailsIfPlatformFeeIsToHigh() public {
        vm.startPrank(owner);
        vm.expectRevert("Core: Platform Fee Too Large");
        Core coreContractTwo = new Core(12_000, address(tokenization1155Contract), mainnetGoldAggregator, mainnetUsdc);
    }

    function test_FailsIfERC1155AddressIsZeroAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("Core: ERC1155 Cannot Be Address Zero");
        Core coreContractTwo = new Core(2_000, address(0), mainnetGoldAggregator, mainnetUsdc);
    }

    function test_FailsIfGoldPriceFeedAddressIsZeroAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("Core: Aggregator Cannot Be Address Zero");
        Core coreContractTwo = new Core(2_000, address(tokenization1155Contract), address(0), mainnetUsdc);
    }

    function test_FailsIfUsdcAddressIsZeroAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("Core: USDC Cannot Be Address Zero");
        Core coreContractTwo = new Core(2_000, address(tokenization1155Contract), mainnetGoldAggregator, address(0));
    }

    function test_InitializesVariablesCorrectly() public {
        assertEq(coreContract.platformFee(), 2_000);
        assertEq(address(coreContract.erc1155()), address(tokenization1155Contract));
        assertEq(address(coreContract.goldPriceFeed()), mainnetGoldAggregator);
        assertEq(address(coreContract.USDC()), mainnetUsdc);
    }
}