// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;
import "../TestSetup.sol";

contract Tokenization1155ConstructorTests is TestSetup {

    function setUp() public {
        setUpTests();
    }

    function test_InitializesVariablesCorrectly() public {
        assertEq(tokenization1155Contract.commodityId(), 0);
        assertEq(tokenization1155Contract.coreContractAddress(), address(0));
        assertEq(tokenization1155Contract.owner(), owner);
        assertEq(tokenization1155Contract.uri(0), "BaseURI");
    }
}