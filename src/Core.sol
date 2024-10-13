// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/src/interfaces/feeds/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./Tokenization1155.sol";

contract Core is Ownable {
    using SafeERC20 for IERC20;

    Tokenization1155 public erc1155;
    AggregatorV3Interface public goldPriceFeed;
    IERC20 public USDC;

    event GoldPurchased(address indexed buyer, uint256 numberOfTokens);
    
    constructor(address _tokenization1155ContractAddress, address _chainlinkAggregator, address _usdc) Ownable(msg.sender) {
        require(_tokenization1155ContractAddress != address(0), "Core: ERC1155 Cannot Be Address Zero");
        require(_chainlinkAggregator != address(0), "Core: Aggregator Cannot Be Address Zero");
        require(_usdc != address(0), "Core: USDC Cannot Be Address Zero");
        erc1155 = Tokenization1155(_tokenization1155ContractAddress);
        goldPriceFeed = AggregatorV3Interface(_chainlinkAggregator);
        USDC = IERC20(_usdc);
    }
    
    function purchase(uint256 _numberOfTokens) external {
        (, int256 answer,,,) = goldPriceFeed.latestRoundData();
        uint256 amountToPayInUsdc = uint256(answer) / 100;
        uint256 amountToPayTotal = (amountToPayInUsdc * _numberOfTokens) / erc1155.TOKENS_PER_OUNCE();

        USDC.safeTransferFrom(msg.sender, address(this), amountToPayTotal);
        erc1155.mint(msg.sender, _numberOfTokens);

        emit GoldPurchased(msg.sender, _numberOfTokens);
    }
}
