// SPDX-License-Identifier: MIT

pragma solidity 0.8.9; 

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "hardhat/console.sol";

contract ETHUSDPrice {
    AggregatorV3Interface internal ETHpriceFeed;

    constructor() {
        ETHpriceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
    }

    function getETHLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            ,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = ETHpriceFeed.latestRoundData();
        require(
            price >= 0 && updatedAt != 0 && answeredInRound >= roundID,
            "Invalid price"
        );

        return price;
    }

    function getETHDecimals() public view returns (uint8) {
        return ETHpriceFeed.decimals();
    }
    
    
}