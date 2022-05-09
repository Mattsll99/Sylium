const { ethers } = require("hardhat");

describe("SYLIUM Oracle", function () {
  let syliumOracle;

  let ETHPricer;

  let USDCPricer;

  beforeEach(async () => {
    //ETHUSDPrice instance
    /*const ETHPRICER = await ethers.getContractFactory("ETHUSDPrice");
    ETHPricer = await ETHPRICER.deploy();
    await ETHPricer.deployed();*/

    //USDCUSDPrice instance
    /*const USDCPRICER = await ethers.getContractFactory("USDCUSDPrice");
    USDCPricer = await USDCPRICER.deploy();
    await USDCPricer.deployed();*/

    let SYLIUMOracle = await ethers.getContractFactory("SYLIUMOracle");
    syliumOracle = await SYLIUMOracle.deploy();
    await syliumOracle.deployed();
  });

  it("Should return the ETH price and the value of the ETH reserve", async function () {
    let ethPrice = await syliumOracle.get_eth_price();
    console.log(ethPrice);
    let ethReserve = await syliumOracle.get_eth_reserve();
    console.log(ethReserve);
  });

  it("Should return the USDC price and the value of the USDC reserve", async function () {
    let usdcPrice = await syliumOracle.get_usdc_price();
    console.log(usdcPrice);
    let usdcReserve = await syliumOracle.get_usdc_reserve();
    console.log(usdcReserve);
  });

  it("Should return the SYLIX price and the value of the SYLIX reserve", async function () {
    let sylixPrice = await syliumOracle.get_sylix_price();
    console.log("========== SYLIX PRICE ==========");
    console.log(sylixPrice);
    let sylixReserve = await syliumOracle.get_sylix_reserve();
    console.log("========== SYLIX RESERVE IN USD ==========");
    console.log(sylixReserve);
  });
});
