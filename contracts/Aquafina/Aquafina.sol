// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "hardhat/console.sol";
import "../SYLIUMOracle/SYLIUMOracle.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";


contract Aquafina is SYLIUMOracle {
    using SafeMath for uint256;
    /* ====================== STATE VARIABLES =========================== */
    uint256 public starter;
    uint256 public ethGenesisPrice;
    uint256 public usdcGenesisPrice;
    uint256 pricePrecision = 1e3;
    uint256 varPrecision = 1e4; 
    uint256 dollarPrecision = 1e18; //$1.00 * 1e5
    uint256 genesisDemand = 20000;
    uint256 genesisAlpha; // 0.1
    uint256 step = 1;
    uint256 alphaStarter;
    uint256 refresh = 3600;
    uint256 beta = 10;
    /* ====================== MODIFIERS ================================= */
    /* ====================== CONSTRUCTOR =============================== */
    constructor(uint256 _starter, uint256 _genesisAlpha) {
      starter = _starter;
      genesisAlpha = _genesisAlpha;
      alphaStarter = block.timestamp - 3600;
      ethGenesisPrice = get_eth_price();
      usdcGenesisPrice = get_usdc_price();
    }

        /* ====================== PUBLIC FUNCTIONS ========================== */
    function getUpdates()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256 currentEthPrice = get_eth_price() + 70 * DECIMALS; //70*1e18 i.e + $70
        uint256 currentUsdcPrice = get_usdc_price() - 5 * 1e16; // i.e - 0.05
        return (starter, ethGenesisPrice, currentEthPrice, usdcGenesisPrice, currentUsdcPrice);
    }

    
    // Get ETH (and only ETH!) variations 
    function getVariation() public view returns (uint256, uint256) {
        // Intiatisation
         (,uint256 ethGenesis, uint256 ethCurrent,,) = getUpdates();
         uint256 stepEth;
         uint256 varEth;
         uint256 regEth; 

         //ETH
         if (ethGenesis >= ethCurrent) {
             stepEth = (ethGenesis - ethCurrent) * varPrecision;
             varEth = stepEth / ethCurrent;
         } else {
             stepEth = (ethCurrent - ethGenesis) * varPrecision;
             varEth = stepEth / ethGenesis;
         }
         if (varEth < 1000) { // Variation rate <= 10% (10: 0.1%, 100: 1%, 1000: 10%)
             regEth = 1000;
         } else {
             regEth = varEth; // Leads to 0 Eth in the final equation; max variation supported < 10%
         }
        return (varEth, regEth);
    }


    // Set the timer
    function setTimer() public {
        uint256 _timer;
        if (
            block.timestamp >= starter + 60 * 60 &&
            block.timestamp < starter + 24 * 60 * 60
        ) {
            _timer = starter;
        } else if (block.timestamp > starter + 24 * 60 * 60) {
            starter = block.timestamp;
            _timer = starter;
            ethGenesisPrice = get_eth_price();
            usdcGenesisPrice = get_usdc_price();
        }
        emit TimerUpdatetd(_timer);
    }

    // Get the ETH and USDC reserve ratio
    function getReservesRatio() public view returns (uint256, uint256) {
        // Getting the Reserve in USD
        (,,uint256 ethPrice,,) = getUpdates();
        (,,,,uint256 usdcPrice) = getUpdates();
        uint256 ethReserve = get_eth_reserve() * ethPrice;
        uint256 usdcReserve = get_usdc_reserve() * usdcPrice;

        // Getting the ratios 
        uint256 ethRatio = (ethReserve * pricePrecision) / (ethReserve + usdcReserve);

        uint256 usdcRatio = (usdcReserve * pricePrecision) / (ethReserve + usdcReserve);

        return (ethRatio, usdcRatio);
    }

     function getGenesisAlpha() public view returns (uint256) {
        return genesisAlpha;
    }

    /* ====================== RESTRICTED FUNCTIONS ====================== */
    // Function to set the equalizers
    function setEqualizer() public view returns (uint256, uint256, uint256, uint256) {
        uint256 equa; 
        // Getting the alpha
        uint256 alpha = getGenesisAlpha();
        // USDC, ETH and SYLIX in init dollar 
        uint256 xEth = 1; 
        uint256 xUsdc = get_eth_price() /get_usdc_price();
        uint256 xSylix = get_eth_price() / get_sylix_price();
        // Getting regEth and varEth
        (uint256 varEth, uint256 regEth) = getVariation();
        // Getting ETH and USDC reserves ratio
        (uint256 ethRatio, uint256 usdcRatio) = getReservesRatio();

        equa = dollarPrecision / ((regEth - varEth) *ethRatio * xEth + 10 * (usdcRatio * xUsdc + alpha * xSylix));
        return (equa, xEth, xUsdc, xSylix);
    }

    function getDemand() public pure returns (uint256) {
        return 30000;
    }
    
    function setAlpha() public {
        // Get the timing
        require(block.timestamp >= alphaStarter + refresh, "You need to wait for the refresh");
        uint256 syliumDemand = getDemand();
        uint256 alpha;

        if (syliumDemand >= genesisDemand) {
            genesisAlpha += step;
            alpha = genesisAlpha;
        } else {
            genesisAlpha -= step;
            alpha = genesisAlpha;
        }
    }

    function setAlgorithmicDesign() public view returns (uint256, uint256, uint256) {
        // initialization for the alpha
        uint256 alpha = getGenesisAlpha();
        // Getting xprices and the equalizer
        (uint256 equa, uint256 xEth, uint256 xUsdc, uint256 xSylix) = setEqualizer();
        // Getting the ETH variations data
        (uint256 varEth, uint256 regEth) = getVariation();
        // Getting the reserves ratios
        (uint256 ethRatio, uint256 usdcRatio) = getReservesRatio();

        //SYLIX Part
        uint256 sylixPart = equa * beta * alpha * xSylix;
        // ETH Part
        uint256 ethPart = equa * (regEth - varEth) * ethRatio * xEth;
        // USDC Part
        uint256 usdcPart = equa * beta * usdcRatio * xUsdc;
        // Getting the total
        //uint256 total = sylixPart + usdcPart + ethPart;

        return (ethPart, usdcPart, sylixPart);

    }

    // Function to set the alpha 
    /* ====================== EVENTS ==================================== */
    // Time updated
    event TimerUpdatetd(uint256 _epoch);

    // alpha updated
}














//https://mochajs.org/#delayed-root-suite
// https://ethereum-waffle.readthedocs.io/en/latest/migration-guides.html?highlight=time#time-based-tests
// https://ethereum.stackexchange.com/questions/106288/how-to-write-tests-for-time-based-contracts
// https://ethereum.stackexchange.com/questions/86633/time-dependent-tests-with-hardhat
// https://mochajs.org/#hooks
// https://www.chaijs.com/api/plugins/

// https://blog.chain.link/how-to-calculate-price-volatility-for-defi-variance-swaps/
// https://remy-nts.medium.com/chainlink-price-feed-decimals-5ac7263dac0b



