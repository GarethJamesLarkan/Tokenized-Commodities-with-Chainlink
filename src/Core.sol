// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Tokenization1155.sol";

contract Core is Ownable {

    Tokenization1155 public erc1155;

    event GoldPurchased(address indexed buyer, uint256 numberOfTokens);
    
    constructor(address _tokenization1155ContractAddress) Ownable(msg.sender) {
        require(_tokenization1155ContractAddress != address(0), "Core: Cannot Be Address Zero");
        erc1155 = Tokenization1155(_tokenization1155ContractAddress);
    }
    
    function purchase(uint256 _numberOfTokens) external payable {
        // Use Chainlink oracle to fetch price of an Ounce
        // Use this to calculate price of one token based on tokens_per_ounce
        // Make sure value paid is correct

        erc1155.mint(msg.sender, _numberOfTokens);

        emit GoldPurchased(msg.sender, _numberOfTokens);
    }

}
