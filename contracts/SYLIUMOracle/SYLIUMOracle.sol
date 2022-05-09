// SPDX-License-Identifier: MIT

pragma solidity 0.8.9; 

import "hardhat/console.sol";
import "../Oracle/ETHUSDPrice.sol";
import "../Oracle/USDCUSDPrice.sol";

contract SYLIUMOracle is ETHUSDPrice, USDCUSDPrice {
  /* ====================== STATE VARIABLES =========================== */

  /* ====================== MODIFIERS ================================= */
  /* ====================== CONSTRUCTOR =============================== */
  constructor() {}
  /* ====================== VIEWS ===================================== */
  // Access the ETH price with the right decimals
  function get_eth_price() public view returns (uint256) {
    return uint256(getETHLatestPrice());
  }

  // Access the USDC price with the right decimals
  function get_usdc_price() public view returns (uint256) {
    return uint256(getUSDCLatestPrice()); 
  }

  function get_sylix_price() public pure returns (uint256) {
    uint256 sylix_price = 10000000000; // 100 euros //275976652819
    return sylix_price;
  }
  
  // Access the ETH Reserve 
  function get_eth_reserve() public view returns (uint256) {
    uint256 amount_eth = 5000;
    uint256 reserve = amount_eth * get_eth_price();
    return reserve;
  }

  // Access the USDC Reserve 
  function get_usdc_reserve() public view returns (uint256) {
    uint256 amount_usdc = 1000000000;
    uint256 reserve = amount_usdc * get_usdc_price();
    return reserve; 
  }

  function get_sylix_reserve() public pure returns (uint256) {
    uint256 amount_sylix = 100000; 
    uint256 reserve = amount_sylix * get_sylix_price();
    return reserve;
  }


 
  /* ====================== PUBLIC FUNCTIONS ========================== */
  /* ====================== RESTRICTED FUNCTIONS ====================== */
  /* ====================== EVENTS ==================================== */
}