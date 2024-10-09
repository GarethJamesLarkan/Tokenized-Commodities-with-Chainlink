// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tokenization1155 is ERC1155Supply, Ownable {

    uint256 public commodityId;
    address public coreContractAddress;

    mapping(uint256 commodityId => uint256 maxSupply) public commodityMaxSupply;

    event NewCommodityAdded(uint256 indexed commodityId, uint256 maxSupply);
    event ExistingCommodityMaxSupplyUpdated(uint256 indexed commodityId, uint256 maxSupply);
    event CoreContractAddressUpdated(address indexed coreContractAddress);
    
    constructor(string memory _uri) ERC1155(_uri) Ownable(msg.sender) {}

    function addNewCommodity(uint256 _maxSupply) public onlyOwner {
        commodityMaxSupply[commodityId] = _maxSupply;
        emit NewCommodityAdded(commodityId, _maxSupply);

        commodityId++;
    }

    function updateExistingCommoditiesMaxSupply(uint256 _commodityId, uint256 _maxSupply) public onlyOwner {
        require(_commodityId < commodityId, "Tokenization1155: Commodity Does Not Exist");
        require(_maxSupply > commodityMaxSupply[_commodityId], "Tokenization1155: Max Supply To Low");

        commodityMaxSupply[_commodityId] = _maxSupply;

        emit ExistingCommodityMaxSupplyUpdated(_commodityId, _maxSupply);
    }

    function updateCoreContractAddress(address _coreContractAddress) public onlyOwner {
        require(_coreContractAddress != address(0), "Tokenization1155: Cannot Be Address Zero");
        coreContractAddress = _coreContractAddress;

        emit CoreContractAddressUpdated(_coreContractAddress);
    }


    function mint(uint256 _commodityId, address _to, uint256 _amount) public {
        require(msg.sender == coreContractAddress, "Tokenization1155: Only Core Contract Can Mint Tokens");
        require(
            totalSupply(_commodityId) + _amount <= commodityMaxSupply[_commodityId], "Tokenization1155: Max Supply Reached"
        );

        _mint(_to, _commodityId, _amount, "");
    }
}
