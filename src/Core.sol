// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/src/interfaces/feeds/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./Tokenization1155.sol";

/**
 * @title Core
 * @dev Core contract for the Gold Purchase Platform
 * @notice Allow sellers to list gold and sell it to users
 * Currently only allows purchasing but no listing, still to be built
 */
contract Core is Ownable {
    using SafeERC20 for IERC20;

    uint256 public constant USDC_OFFSET = 100;
    uint256 public platformFee;
    uint256 public platformFeesForWithdrawal;
    
    Tokenization1155 public erc1155;
    AggregatorV3Interface public goldPriceFeed;
    IERC20 public USDC;

    event GoldPurchased(address indexed buyer, uint256 numberOfTokens);
    event PlatformFeeChanged(uint256 newFee);
    event PlatformFeesWithdrawn(uint256 amountWithdrawn);
    event PurchaseFundsWithdrawn(uint256 amountWithdrawn);

    constructor(
        uint256 _platformFee,
        address _tokenization1155ContractAddress, 
        address _chainlinkAggregator, 
        address _usdc
    ) Ownable(msg.sender) {
        require(_platformFee <= 10_000, "Core: Platform Fee Too Large");
        require(_tokenization1155ContractAddress != address(0), "Core: ERC1155 Cannot Be Address Zero");
        require(_chainlinkAggregator != address(0), "Core: Aggregator Cannot Be Address Zero");
        require(_usdc != address(0), "Core: USDC Cannot Be Address Zero");
        platformFee = _platformFee;
        erc1155 = Tokenization1155(_tokenization1155ContractAddress);
        goldPriceFeed = AggregatorV3Interface(_chainlinkAggregator);
        USDC = IERC20(_usdc);
    }
    
    function purchase(uint256 _numberOfTokens) external {
        (, int256 answer,,,) = goldPriceFeed.latestRoundData();
        uint256 amountToPayInUsdc = uint256(answer) / USDC_OFFSET;
        uint256 amountToPayTotal = (amountToPayInUsdc * _numberOfTokens) / erc1155.TOKENS_PER_OUNCE();

        USDC.safeTransferFrom(msg.sender, address(this), amountToPayTotal);
        erc1155.mint(msg.sender, _numberOfTokens);

        emit GoldPurchased(msg.sender, _numberOfTokens);
    }

    function setPlatformFee(uint256 _platformFee) external onlyOwner {
        require(_platformFee <= 10_000, "Core: Platform Fee Too Large");
        platformFee = _platformFee;

        emit PlatformFeeChanged(_platformFee);
    }

    function withdrawalPlatformFees() public {
        require(platformFeesForWithdrawal > 0, "Core: No Fees To Withdraw");
        uint256 amountToWithdraw = platformFeesForWithdrawal;
        platformFeesForWithdrawal = 0;

        USDC.safeTransfer(owner(), amountToWithdraw);

        emit PlatformFeesWithdrawn(amountToWithdraw);
    }

    function withdrawalPurchaseFunds() public onlyOwner {
        uint256 amountToWithdraw = USDC.balanceOf(address(this)) - platformFeesForWithdrawal;
        USDC.safeTransfer(owner(), amountToWithdraw);

        emit PurchaseFundsWithdrawn(amountToWithdraw);
    }
}
