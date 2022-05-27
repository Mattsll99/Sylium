// SPDX-License-Identifier: MIT

pragma solidity 0.8.9; 

import "hardhat/console.sol";
import "../Aquafina/Aquafina.sol";
import "../SYLI/SYLI.sol";
import "../SYLIX/SYLIX.sol";
import "../mockToken/syETH.sol";
import "../mockToken/syUSDC.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";




contract SYLIUMPool is Aquafina (block.timestamp, 1) {

  /* ====================== STATE VARIABLES =========================== */
  uint256 circulatingSylium;
  
  // Instance of syETH
  syETH public syEth; // An abstraction of the ETH token 
  // Instance of syUSDC
  syUSDC public syUsdc; // An abstraction of the USDC token 
  // Instance of SYLIYM 
  SYLI private sylium;
  // Instance of SYLIX
  SYLIX  private sylix;
  // mapping to get the sylium balance 
  mapping (address => uint256) syliumBalance;
  // mapping to get the sylix balance 
  mapping (address => uint256) sylixBalance;
  // mapping to get the ETH balance
  mapping (address => uint256) ethBalance;
  // mapping to get the USDC balance 
  mapping (address => uint256) usdcBalance;

  uint256 PRECISION = 1e24;

  uint256 genesisEpoch;

  uint256 hour = 3600; 

  uint256 totalSyliumMinted;

   //ADDRESSES OF THE TOKENS
  address public syliumAddress;
  address public sylixAddress;
  address public syEthAddress;
  address public syUsdcAddress;

  //GOVERNANCE 'S ADDRESS 
  address governanceAddress; 

  uint256 mintingFees;
  uint256 redeemingFees; 
  

  /* ====================== MODIFIERS ================================= */
  modifier onlyByGov() {
    require(msg.sender == governanceAddress);
    _;
  }
  /* ====================== CONSTRUCTOR =============================== */
  constructor(uint256 _genesisEpoch) {
    genesisEpoch = _genesisEpoch;
    syliumAddress = 0xeF31027350Be2c7439C1b0BE022d49421488b72C;
    sylixAddress = 0xC66AB83418C20A65C3f8e83B3d11c8C3a6097b6F;
    syEthAddress = 0x71089Ba41e478702e1904692385Be3972B2cBf9e;
    syUsdcAddress = 0x8F4ec854Dd12F1fe79500a1f53D0cbB30f9b6134;

    sylium = SYLI(syliumAddress);
    sylix = SYLIX(sylixAddress);
    syEth = syETH(syEthAddress);
    syUsdc = syUSDC(syUsdcAddress);

  }
  /* ====================== VIEWS ===================================== */

  function getSyliumInCollateral() public view returns (uint256, uint256, uint256) {
    (uint256 pEth, uint256 pUsdc, uint256 pSylix) = setAlgorithmicDesign();
    uint256 ethAmount = (pEth * PRECISION) / get_eth_price();
    uint256 usdcAmount = (pUsdc * PRECISION) / get_usdc_price();
    uint256 sylixAmount = (pSylix * PRECISION) / get_sylix_price();

    return (ethAmount, usdcAmount, sylixAmount);
  }
  /* ====================== PUBLIC FUNCTIONS ========================== */
  // Function to get mockToken
  function getMockToken(uint256 amount) public {
    uint256 amountToken = amount * PRECISION;

    syEth.mint_syETH(msg.sender, amountToken);
    syUsdc.mint_syUSDC(msg.sender, amountToken);
    sylix.mint_sylix(msg.sender, amountToken);
  }


  // Function to Mint SYLIUM
  function mintSylium(uint256 amount) public payable {
    uint256 ethNeeded;
    uint256 usdcNeeded;
    uint256 sylixNeeded;
    // Instantiate the collateral and algorithmic parts of the equation
    (uint256 ethAmount, uint256 usdcAmount, uint256 sylixAmount) = getSyliumInCollateral();

    ethNeeded = amount * ethAmount;
    usdcNeeded = amount * usdcAmount;
    sylixNeeded = amount * sylixAmount;

    // Requirement 
    //require(ethToken.balanceOf(msg.sender) >= ethNeeded && usdcToken.balanceOf(msg.sender) >= usdcNeeded, "Insufficient funds");

    // Transfer ethAmount to the pool
    syEth.transferFrom(msg.sender, address(this), ethNeeded); //syETH is an abstraction of the ETH token used for testing 
    // Transfer usdcAmount to the pool
    syUsdc.transferFrom(msg.sender, address(this), usdcNeeded); //syUSDC is an abstraction of the USDC token used for testing
    // Burn sylixAmount
    sylix.burn_sylix(msg.sender, sylixNeeded);
    // Mint the SYLIUM
    sylium.mint_syli(msg.sender, amount);

    emit syliumMinted(amount);
  }

  // Function to Redeem SYLIUM 
  function redeemSylium(uint256 amount) public payable {
    require(sylium.balanceOf(msg.sender) >= amount, "Not enough funds");
    // Instantiate the collateral and algorithmic parts of the equation
    uint256 ethReceived;
    uint256 usdcReceived;
    uint256 sylixReceived;

    (uint256 ethAmount, uint256 usdcAmount, uint256 sylixAmount) = getSyliumInCollateral();

    ethReceived = amount * ethAmount;
    usdcReceived = amount * usdcAmount;
    sylixReceived = amount * sylixAmount;

    // Transfering the collaterals
    syEth.transferFrom(address(this), msg.sender, ethReceived);
    syUsdc.transferFrom(address(this), msg.sender, usdcReceived);
    // Minting the algorithmic part 
    sylix.mint_sylix(msg.sender, sylixReceived);

    emit syliumRedeemed(amount);

  }

  // Function to get the number of SYLIUM minted with epoch
  function totalMinted() public  pure returns (uint256) {
    return 1e6;
  }

  /* ====================== RESTRICTED FUNCTIONS ====================== */
  // Set the minting fees
  function setMintingFees() public onlyByGov {
    
  }

  // Set the redeeming fees 
  function setRedeemingFees() public onlyByGov {
  
  }
  /* ====================== EVENTS ==================================== */
  // event xSYLIUMMinted(_amount)
  event syliumMinted(uint256 _amount);

  // event xSYLIUMRedeemed(_amount)
  event syliumRedeemed(uint256 _amount);
}