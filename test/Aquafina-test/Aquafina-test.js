const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Aquafina", function () {
  let aquafina;
  let starter = 1650344633;

  beforeEach(async () => {
    const Aquafina = await ethers.getContractFactory("Aquafina");
    aquafina = await Aquafina.deploy(starter);
    await aquafina.deployed();
  });

  it("Should return the starter time with the current prices of ETH & USDC", async function () {
    let timer,
      ethPrice,
      usdcPrice = await aquafina.setTimer();
    console.log(timer, ethPrice, usdcPrice);
  });

  it("Should make the transaction for the Timer update and return the updated data", async function () {
    console.log("========== TIMER, ETH PRICE & USDC PRICE ==========");
    let timer,
      ethPrice,
      usdcPrice = await aquafina.setTimer();
    console.log(timer, ethPrice, usdcPrice);

    console.log(
      "========== STARTER, GENESIS PRICES & CURRENT PRICES =========="
    );

    let starter,
      ethGenesisPrice,
      currentEthPrice,
      usdcGenesisPrice,
      currentUsdcPrice = await aquafina.getUpdates();
    console.log(
      starter,
      ethGenesisPrice,
      currentEthPrice,
      usdcGenesisPrice,
      currentUsdcPrice
    );

    console.log(
      "========== ETH PRICE VARIATION AND ETH PORTION REGULATOR =========="
    );
    let varEth,
      regEth = await aquafina.getVariation();
    console.log(varEth, regEth);

    console.log("========== ETH AND USDC RESERVES RATIO ==========");
    let ethReserve,
      usdcReserve = await aquafina.getReservesRatio();
    console.log(ethReserve, usdcReserve);

    console.log("========== SETTING THE ALPHA ==========");
    let Alpha = await aquafina.setAlpha();
    console.log(Alpha);

    console.log("========== GETTING THE NEW GENESIS ALPHA ==========");
    let genesisAlpha = await aquafina.getGenesisAlpha();
    console.log(genesisAlpha);

    console.log(
      "========== GETTING THE EQUALIZER xETH, xUSDC  AND XSYLIX =========="
    );
    let equa,
      xeth,
      xusdc,
      xsylix = await aquafina.setEqualizer();
    console.log(equa, xeth, xusdc, xsylix);

    console.log(
      "========== 100% COLLATERAL DESGIN : GETTING ETH AND USDC PARTS IN THE DESIGN + TOTAL FOR PRECISION =========="
    );
    let partEth,
      partUsdc,
      result = await aquafina.setDesign();
    console.log(partEth, partUsdc, result);

    console.log(
      "========== ALGORITHMIC DESIGN : GETTING ETH, USDC & SYLIX PARTS ========== "
    );
    let eth,
      usdc,
      sylix = await aquafina.setAlgorithmicDesign();
    console.log(eth, usdc, sylix);
  });
});
