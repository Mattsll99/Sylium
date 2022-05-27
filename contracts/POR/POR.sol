// SPDX-License-Identifier: MIT

pragma solidity 0.8.9; 

import "../SYLIUMOracle/SYLIUMOracle.sol";
import "../Aquafina/Aquafina.sol";

contract POR is SYLIUMOracle {

  /* ====================== STATE VARIABLES =========================== */
  // mapping to get the ETH Balance 
  mapping (address => uint256) ethBalance; 
  // mapping to get the USDC Balance 
  mapping (address => uint256) usdcBalance; 
  // mapping to get the SYLIUM Balance
  mapping (address => uint256) syliumBalance; 
  // mapping to get the SYLIX Balance 
  mapping (address => uint256) sylixBalance; 
  // Bool P.O.R.ing open
  bool isPorOpen;
  // Address of SYLIUMPool 
  address poolAddress;
  // Resilience margin
  uint256 margin; // set to 20%

  uint256 ethPart = 4000; //40% of the refund
  uint256 usdcPart = 6000; //60% of the refund 
  uint256 plusMargin = 500; // 5% more margin for the refund

 

  

  /* ====================== MODIFIERS ================================= */
  /* ====================== CONSTRUCTOR =============================== */
  /* ====================== VIEWS ===================================== */
  // Function to get the total reserve
  function getTotalReserve() public view returns (uint256) {
    uint256 ethReserve = get_eth_reserve();
    uint256 usdcReserve = get_usdc_reserve();
    uint256 totalReserve = ethReserve + usdcReserve;
    return totalReserve;
  }
  // Function get POR needed
  function getPORNeeded() public {
  }

  // Function : by providing THIS you get THAT amount of SYLIUM 

  // Function to return the preferential rates for ETH & USDC
  function getRates() public view {}

  /* ====================== PUBLIC FUNCTIONS ========================== */
  // P.O.R. for the Collaterals Reserves
  function PORvide() public {}

  /* ====================== RESTRICTED FUNCTIONS ====================== */
  // Function to set the PORing fees 
  function setPorFees() public {}

  // Function to set the progressive preferential rate (steps ?...)
  function setRates() public {}

  // Function to open growth intenceives 
  function openIntencives() public {}
  /* ====================== EVENTS ==================================== */
  // ETH Reserve P.O.R.ed

  // USDC Reserve P.O.R.ed 

  // SYLIX Reserve P.O.R.ed 

  // PORing fees updatetd 

  // ETH Preferential rate updated

  // USDC Preferential rate updated 
}