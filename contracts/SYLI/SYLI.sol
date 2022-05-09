// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0; 

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SYLI is ERC20, ERC20Burnable, Ownable {
  /* ====================== STATE VARIABLES =========================== */
  address public governanceAddress;
  /* ====================== MODIFIERS ================================= */
  modifier onlyGov() {
    require(msg.sender == governanceAddress, "This action is only feasible by the governance");
    _;
  }
  /* ====================== CONSTRUCTOR =============================== */
  constructor() ERC20("SyliumToken", "SYLI") {
  }

  /* ====================== VIEWS ===================================== */
  function getGovernanceAddress() public view returns (address) {
    return governanceAddress;
  }
  /* ====================== PUBLIC & EXTERNAL FUNCTIONS ========================== */
  // Function to Mint SYLI
  function mint_syli(address receiver, uint256 amount) public {
    _mint(receiver, amount);
    emit minting(receiver, amount);
  }

  // Function to burn SYLI 
  function burn_syli(address burnedFrom, uint256 amount) public {
    burnFrom(burnedFrom, amount); 
    emit burningFrom(burnedFrom, amount);
  }

  /* ====================== RESTRICTED FUNCTIONS ====================== */
  /* ====================== EVENTS ==================================== */
  // Minting event 
  event minting(address _receiver, uint256 _amount); 
  // Burning from event 
  event burningFrom(address _burnedFrom, uint256 _amount); 
}

// Mint SYL

// Burn SYL 