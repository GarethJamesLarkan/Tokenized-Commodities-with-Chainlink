// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/src/interfaces/feeds/AggregatorV3Interface.sol";
import "./Tokenization1155.sol";

contract Core is Ownable {

    Tokenization1155 public erc1155;
    AggregatorV3Interface public goldPriceFeed;

    event GoldPurchased(address indexed buyer, uint256 numberOfTokens);
    
    constructor(address _tokenization1155ContractAddress, address _chainlinkAggregator) Ownable(msg.sender) {
        require(_tokenization1155ContractAddress != address(0), "Core: ERC1155 Cannot Be Address Zero");
        require(_chainlinkAggregator != address(0), "Core: Aggregator Cannot Be Address Zero");
        erc1155 = Tokenization1155(_tokenization1155ContractAddress);
        goldPriceFeed = AggregatorV3Interface(_chainlinkAggregator);
    }
    
    function purchase(uint256 _numberOfTokens) external payable {
        (, int256 answer,,,) = goldPriceFeed.latestRoundData();
        uint256 amountToPay = (uint256(answer) * _numberOfTokens) / erc1155.TOKENS_PER_OUNCE();
        require(msg.value == amountToPay, "Core: Incorrect Funds");

        erc1155.mint(msg.sender, _numberOfTokens);

        emit GoldPurchased(msg.sender, _numberOfTokens);
    }
}
