// SPDX-License-Identifier: MIT

pragma solidity 0.8.9; 

import "hardhat/console.sol";
import "../Oracle/ETHUSDPrice.sol";
import "../Oracle/USDCUSDPrice.sol";



contract SYLIUMOracle is ETHUSDPrice, USDCUSDPrice {
  /* ====================== STATE VARIABLES =========================== */
  uint256 DECIMALS = 1e18;

  /* ====================== MODIFIERS ================================= */
  /* ====================== CONSTRUCTOR =============================== */
  constructor() {}
  /* ====================== VIEWS ===================================== */
  // Access the ETH price with the right decimals
  function get_eth_price() public view returns (uint256) {
    uint256 price = (uint256(getETHLatestPrice()) * DECIMALS) / 10**uint256(getETHDecimals());
    return price;
  }

  // Access the USDC price with the right decimals
  function get_usdc_price() public view returns (uint256) {
    uint256 price = (uint256(getUSDCLatestPrice()) * DECIMALS) / 10**uint256(getUSDCDecimals());
    return price; 
  }

  function get_sylix_price() public view returns (uint256) {
    uint256 sylix_price = (1000 * DECIMALS) / 10**2; // 100 euros //275976652819
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

  function get_sylix_reserve() public view returns (uint256) {
    uint256 amount_sylix = 100000; 
    uint256 reserve = amount_sylix * get_sylix_price();
    return reserve;
  }

  /*function get_total_minted() public view returns (uint256) {
    return totalMinted();
  }*/


 
  /* ====================== PUBLIC FUNCTIONS ========================== */
  /* ====================== RESTRICTED FUNCTIONS ====================== */
  /* ====================== EVENTS ==================================== */
}