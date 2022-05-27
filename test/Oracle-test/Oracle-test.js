const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ETHUSDPrice & USDCUSDPrice", function () {
  let ETHPricer;
  let USDCPricer;
  beforeEach(async () => {
    //ETH data
    let ETHPRICER = await ethers.getContractFactory("ETHUSDPrice");
    ETHPricer = await ETHPRICER.deploy();
    await ETHPricer.deployed();

    //USDC data
    let USDCPRICER = await ethers.getContractFactory("USDCUSDPrice");
    USDCPricer = await USDCPRICER.deploy();
    await USDCPricer.deployed();
  });

  it("Should be able to successfully get round data of ETH and return the decimals", async function () {
    expect(await ETHPricer.getETHLatestPrice()).not.be.null;
    console.log("========== ETH PRICE ==========");
    let price = await ETHPricer.getETHLatestPrice();
    console.log(price);
    let updatedPrice = ethers.utils.formatEther(price);
    console.log(updatedPrice);
    console.log("========== ETH DECIMALS ==========");
    let decimals = await ETHPricer.getETHDecimals();
    console.log(decimals);
  });

  it("Should be able to successfully get round data of USDC and return the decimals", async function () {
    expect(await USDCPricer.getUSDCLatestPrice()).not.be.null;
    console.log("========== USDC PRICE ==========");
    let price = await USDCPricer.getUSDCLatestPrice();
    console.log(price);
    console.log("========== UDSC DECIMALS ==========");
    let decimals = await USDCPricer.getUSDCDecimals();
    console.log(decimals);
  });
});
