// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "../TestSetup.sol";

contract CoreConstructorTests is TestSetup {

    function setUp() public {
        setUpTests();
    }

    function test_FailsIfERC1155AddressIsZeroAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("Core: ERC1155 Cannot Be Address Zero");
        Core coreContractTwo = new Core(address(0), mainnetGoldAggregator);
    }

    function test_FailsIfGoldPriceFeedAddressIsZeroAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("Core: Aggregator Cannot Be Address Zero");
        Core coreContractTwo = new Core(address(tokenization1155Contract), address(0));
    }

    function test_InitializesVariablesCorrectly() public {
        assertEq(address(coreContract.erc1155()), address(tokenization1155Contract));
        assertEq(address(coreContract.goldPriceFeed()), mainnetGoldAggregator);
    }
}