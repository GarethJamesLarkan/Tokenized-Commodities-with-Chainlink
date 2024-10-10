// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;
import "../TestSetup.sol";

contract Tokenization1155ConstructorTests is TestSetup {

    function setUp() public {
        setUpTests();
    }

    function test_InitializesVariablesCorrectly() public {
        assertEq(tokenization1155Contract.maxNumberOfTokensAvailable(), 1_000_000);
        assertEq(tokenization1155Contract.numberOfTokensSold(), 0);
        assertEq(tokenization1155Contract.goldNftId(), 1);
        assertEq(tokenization1155Contract.coreContractAddress(), address(coreContract));
        assertEq(tokenization1155Contract.owner(), owner);
        assertEq(tokenization1155Contract.uri(0), "BaseURI");
    }
}