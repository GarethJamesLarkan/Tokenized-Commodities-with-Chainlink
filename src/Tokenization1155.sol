// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tokenization1155 is ERC1155, Ownable {

    uint256 public goldNftId = 1;
    uint256 public constant TOKENS_PER_OUNCE = 100;
    uint256 public maxNumberOfTokensAvailable;
    uint256 public numberOfTokensSold;
    address public coreContractAddress;

    event UpdatedGoldSupply(uint256 maxSupply);
    event CoreContractAddressUpdated(address indexed coreContractAddress);
    
    constructor(uint256 _initialAmountOfOunces, string memory _uri) ERC1155(_uri) Ownable(msg.sender) {
        maxNumberOfTokensAvailable = _initialAmountOfOunces * TOKENS_PER_OUNCE;
    }

    function updateGoldSupply(uint256 _newNumberOfOuncesAvailable) public onlyOwner {
        uint256 numberOfTokens = _newNumberOfOuncesAvailable * TOKENS_PER_OUNCE;
        require(numberOfTokensSold < numberOfTokens, "Tokenization1155: New Supply To Low");

        maxNumberOfTokensAvailable = numberOfTokens;

        emit UpdatedGoldSupply(numberOfTokens);
    }

    function updateCoreContractAddress(address _coreContractAddress) public onlyOwner {
        require(_coreContractAddress != address(0), "Tokenization1155: Cannot Be Address Zero");
        coreContractAddress = _coreContractAddress;

        emit CoreContractAddressUpdated(_coreContractAddress);
    }

    function mint(address _to, uint256 _amount) public {
        require(msg.sender == coreContractAddress, "Tokenization1155: Only Core Contract Can Mint Tokens");
        require(
            numberOfTokensSold + _amount <= maxNumberOfTokensAvailable, "Tokenization1155: Max Supply Reached"
        );

        _mint(_to, goldNftId, _amount, "");
    }
}
