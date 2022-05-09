// SPDX-License-Identifier: MIT

pragma solidity 0.8.9; 

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "hardhat/console.sol";

contract USDCUSDPrice {
    AggregatorV3Interface internal USDCpriceFeed;

    constructor() {
        USDCpriceFeed = AggregatorV3Interface(
           0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6
        );
    }

    function getUSDCLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            ,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = USDCpriceFeed.latestRoundData();
        require(
            price >= 0 && updatedAt != 0 && answeredInRound >= roundID,
            "Invalid price"
        );

        return price;
    }

    function getUSDCDecimals() public view returns (uint8) {
        return USDCpriceFeed.decimals();
    }
    
    
}