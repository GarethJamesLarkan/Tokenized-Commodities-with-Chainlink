// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
import "../TestSetup.sol";

contract UpdateCoreContractAddressTests is TestSetup {

    event CoreContractAddressUpdated(address indexed coreContractAddress);

    function setUp() public {
        setUpTests();
    }

    function test_OnlyOwnerCanUpdateCoreContractAddress() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(OwnableUnauthorizedAccount.selector, address(alice)));
        tokenization1155Contract.updateCoreContractAddress(alice);
    }

    function test_FailsIfSettingContractToAddressZero() public {
        vm.startPrank(owner);
        vm.expectRevert("Tokenization1155: Cannot Be Address Zero");
        tokenization1155Contract.updateCoreContractAddress(address(0));
    }

    function test_UpdatesCoreContract() public {
        assertEq(tokenization1155Contract.coreContractAddress(), address(coreContract));

        vm.startPrank(owner);
        vm.expectEmit(true, false, false, false);
        emit CoreContractAddressUpdated(alice);
        tokenization1155Contract.updateCoreContractAddress(alice);

        assertEq(tokenization1155Contract.coreContractAddress(), alice);
    }
}