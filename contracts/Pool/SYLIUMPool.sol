// SPDX-License-Identifier: MIT

pragma solidity 0.8.9; 

import "hardhat/console.sol";
import "../Aquafina/Aquafina.sol";
import "../SYLI/SYLI.sol";
import "../SYLIX/SYLIX.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract SYLIUMPool is Aquafina(block.timestamp) {

  /* ====================== STATE VARIABLES =========================== */
  uint256 circulatingSylium;
  IERC20 public ethToken;
  IERC20 public usdcToken;
  // Instance of SYLIYM 
  SYLI private syli;
  // Instance of SYLIX
  SYLIX private sylix;
  // ETH address
  address ethAddress = 0x64FF637fB478863B7468bc97D30a5bF3A428a1fD;
  // USDC address 
  address usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; 
  // mapping to get the sylium balance 
  mapping (address => uint256) syliumBalance;
  // mapping to get the sylix balance 
  mapping (address => uint256) sylixBalance;
  // mapping to get the ETH balance
  mapping (address => uint256) ethBalance;
  // mapping to get the USDC balance 
  mapping (address => uint256) usdcBalance;

  uint256 PRECISION = 1e20;

  uint256 genesisEpoch;

  uint256 hour = 3600; 

  uint256 totalSyliumMinted;


  /* ====================== MODIFIERS ================================= */
  /* ====================== CONSTRUCTOR =============================== */
  constructor(uint256 _genesisEpoch) {
    ethToken = IERC20(ethAddress);
    usdcToken = IERC20(usdcAddress);
    genesisEpoch = _genesisEpoch;
  }
  /* ====================== VIEWS ===================================== */
  function getSyliumIncollateral() public view returns (uint256, uint256, uint256) {
    // Getting the USD value of the tokens in the equation
    (, uint256 xEth, uint256 xUsdc, uint256 xSylix) = setEqualizer();
    uint256 ethAmount;
    uint256 usdcAmount;
    uint256 sylixAmount;

    ethAmount = (xEth * PRECISION)/ get_eth_price();
    usdcAmount = (xUsdc * PRECISION) / get_usdc_price();
    sylixAmount = (xSylix * PRECISION) / get_sylix_price();

    return (ethAmount, usdcAmount, sylixAmount);
  }
  /* ====================== PUBLIC FUNCTIONS ========================== */
  // Function to Mint SYLIUM
  function mintSylium(uint256 amount) public payable {
    uint256 ethNeeded;
    uint256 usdcNeeded;
    uint256 sylixNeeded;
    // Instantiate the collateral and algorithmic parts of the equation
    (uint256 ethAmount, uint256 usdcAmount, uint256 sylixAmount) = getSyliumIncollateral();

    ethNeeded = amount * ethAmount;
    usdcNeeded = amount * usdcAmount;
    sylixNeeded = amount * sylixAmount;

    // Requirement 
    //require(ethToken.balanceOf(msg.sender) >= ethNeeded && usdcToken.balanceOf(msg.sender) >= usdcNeeded, "Insufficient funds");

    // Transfer ethAmount to the pool
    ethToken.transferFrom(msg.sender, address(this), ethNeeded);
    // Transfer usdcAmount to the pool
    usdcToken.transferFrom(msg.sender, address(this), usdcNeeded);

    // Burn sylixAmount
    sylix.burn_sylix(msg.sender, sylixNeeded);
    // Mint the SYLIUM
    syli.mint_syli(msg.sender, amount);

    emit syliumMinted(amount);
  }

  // Function to Redeem SYLIUM 
  function redeemSylium(uint256 amount) public payable {
    require(syli.balanceOf(msg.sender) >= amount, "Not enough funds");
    // Instantiate the collateral and algorithmic parts of the equation
    uint256 ethReceived;
    uint256 usdcReceived;
    uint256 sylixReceived;

    (uint256 ethAmount, uint256 usdcAmount, uint256 sylixAmount) = getSyliumIncollateral();

    ethReceived = amount * ethAmount;
    usdcReceived = amount * usdcAmount;
    sylixReceived = amount * sylixAmount;

    // Transfering the collaterals
    ethToken.transferFrom(address(this), msg.sender, ethReceived);
    usdcToken.transferFrom(address(this), msg.sender, usdcReceived);
    // Minting the algorithmic part 
    sylix.mint_sylix(msg.sender, sylixReceived);

    emit syliumRedeemed(amount);

  }

  // Function to get the number of SYLIUM minted with epoch
  function totalMinted() public {}

  /* ====================== RESTRICTED FUNCTIONS ====================== */
  // Set the minting fees
  function setMintingFees() public view returns(uint256) {}

  // Set the redeeming fees 
  function setRedeemingFees() public view returns (uint256) {}
  /* ====================== EVENTS ==================================== */
  // event xSYLIUMMinted(_amount)
  event syliumMinted(uint256 _amount);

  // event xSYLIUMRedeemed(_amount)
  event syliumRedeemed(uint256 _amount);
}