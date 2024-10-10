// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/Core.sol";
import "../src/Tokenization1155.sol";

contract TestSetup is Test {

    Core public coreContract;
    Tokenization1155 public tokenization1155Contract;

    address owner = vm.addr(1);
    address alice = vm.addr(2);
    address bob = vm.addr(3);
    address robyn = vm.addr(4);

    error OwnableUnauthorizedAccount(address account);
    
    function setUpTests() public {    
        vm.selectFork(vm.createFork(vm.envString("MAINNET_RPC_URL")));

        vm.deal(alice, 100 ether);
        vm.deal(owner, 100 ether);
        vm.deal(bob, 100 ether);
        vm.deal(robyn, 100 ether);

        vm.startPrank(owner);
        tokenization1155Contract = new Tokenization1155(10_000, "BaseURI");
        coreContract = new Core(address(tokenization1155Contract));

        tokenization1155Contract.updateCoreContractAddress(address(coreContract));

        vm.stopPrank();
    }
}