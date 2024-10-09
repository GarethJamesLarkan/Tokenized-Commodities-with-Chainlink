// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Core is Ownable {

    address public tokenization1155ContractAddress;
    
    constructor(address _tokenization1155ContractAddress) Ownable(msg.sender) {
        require(_tokenization1155ContractAddress != address(0), "Core: Cannot Be Address Zero");
        tokenization1155ContractAddress = _tokenization1155ContractAddress;
    }

}
